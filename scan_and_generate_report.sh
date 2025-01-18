#!/usr/bin/env python3

import time
from gvm.connections import UnixSocketConnection
from gvm.protocols.gmp import Gmp
from gvm.transforms import EtreeTransform
from xml.etree import ElementTree

# Path to the Unix socket
socket_path = '/run/gvmd/gvmd.sock'

# Default placeholders for credentials and task ID
task_id = 'replace-with-task-id'  # Replace with your Task ID
username = 'replace-with-username'  # Replace with your GVM username
password = 'replace-with-password'  # Replace with your GVM password

# Severity threshold
SEVERITY_THRESHOLD = 4.0  # Include medium-severity vulnerabilities (CVSS >= 4.0)


def start_scan_and_generate_report():
    try:
        # Establish a connection to the GVM server using the Unix socket
        connection = UnixSocketConnection(path=socket_path)
        transform = EtreeTransform()  # XML transform for parsing responses

        with Gmp(connection, transform=transform) as gmp:
            # Authenticate with GVM
            gmp.authenticate(username=username, password=password)
            print("Authentication successful.")

            # Start the scan task
            response = gmp.start_task(task_id)
            task_status = response.get("status")
            if task_status != "202":
                print(f"Failed to start the scan task: {response.get('status_text')}")
                return

            print(f"Scan task {task_id} started successfully.")

            # Poll until the scan is complete
            while True:
                tasks_response = gmp.get_tasks()
                tasks = tasks_response.findall(".//task")

                # Find the task with the matching task_id
                target_task = None
                for task in tasks:
                    if task.get("id") == task_id:
                        target_task = task
                        break

                if target_task is None:
                    print(f"Task with ID {task_id} not found.")
                    return

                status = target_task.find(".//status").text
                print(f"Task status: {status}")
                if status == "Done":
                    print("Scan completed successfully.")
                    break
                elif status in ["Stopped", "Interrupted"]:
                    print(f"Scan task {task_id} did not complete successfully (status: {status}).")
                    return
                time.sleep(60)  # Wait 1 minute before checking again

            # Generate the report
            print("Fetching report details...")

            # Get the latest report ID for the task
            latest_report = target_task.find("last_report/report")
            if latest_report is None:
                print("No report found for the given task.")
                return

            report_id = latest_report.get("id")
            if not report_id:
                print("No valid report ID found.")
                return

            # Fetch the report details
            report_response = gmp.get_report(report_id=report_id, details=True)
            vulnerabilities = report_response.findall(".//result")

            if not vulnerabilities:
                print("No vulnerabilities found in the report.")
                return

            # Filter and format vulnerabilities
            filtered_vulnerabilities = []
            for vuln in vulnerabilities:
                severity_element = vuln.find("severity")
                if severity_element is None or not severity_element.text:
                    print("Skipping vulnerability with missing severity.")
                    continue

                severity = float(severity_element.text)
                if severity >= SEVERITY_THRESHOLD:
                    filtered_vulnerabilities.append({
                        "name": vuln.find("name").text if vuln.find("name") is not None else "Unknown",
                        "severity": severity,
                        "host": vuln.find("host").text if vuln.find("host") is not None else "Unknown",
                        "description": vuln.find("description").text if vuln.find("description") is not None else "No description provided",
                    })

            # Generate and save the formatted report
            report_file_path = "filtered_report.txt"
            with open(report_file_path, "w") as report_file:
                for vuln in filtered_vulnerabilities:
                    report_file.write(f"Name: {vuln['name']}\n")
                    report_file.write(f"Severity: {vuln['severity']}\n")
                    report_file.write(f"Host: {vuln['host']}\n")
                    report_file.write(f"Description: {vuln['description']}\n\n")

            print(f"Report generated at {report_file_path} with {len(filtered_vulnerabilities)} vulnerabilities (CVSS >= {SEVERITY_THRESHOLD}).")
    except Exception as e:
        print(f"An error occurred: {e}")


if __name__ == "__main__":
    start_scan_and_generate_report()
