# vuln-scan-automation

 Vulnerability Scanning Automation with GVM

This project automates vulnerability scanning using the Greenbone Vulnerability Manager (GVM). It includes scripts for setting up GVM, creating targets and tasks, running scans, and generating reports. The solution is modular and supports cron jobs for scheduling scans and reports.

---

 Project Structure

plaintext
vulnerability-scanning-automation/
├── scripts/
│   ├── setup_kali_gvm.sh              Installs and sets up GVM on Kali Linux
│   ├── fix_postgresql.sh              Fixes PostgreSQL issues during GVM setup
│   ├── create_target.sh               Creates a target in GVM
│   ├── create_task.sh                 Creates a task for a target in GVM
│   ├── scan_and_generate_report.py    Runs a scan and generates a vulnerability report
├── README.md                          Documentation for the project
└── LICENSE                            License for the project


---

 Setup Instructions

 1. Prerequisites
- A machine running Kali Linux.
- Administrative privileges.
- Python 3 installed.
- GVM installed on the system.

---

 2. Installation

1. Clone the Repository:
   bash
   git clone https://github.com/your-username/vulnerability-scanning-automation.git
   cd vulnerability-scanning-automation
   

2. Set Up GVM:
   Run the setup script to install and configure GVM:
   bash
   sudo ./scripts/setup_kali_gvm.sh
   

3. Fix PostgreSQL Issues (if needed):
   bash
   sudo ./scripts/fix_postgresql.sh
   

---

 3. Workflow

 Step 1: Create a Target
Run the script to create a target. Replace TARGET_NAME and TARGET_HOST in the script with your desired values.
bash
sudo ./scripts/create_target.sh

The script will save the target ID to target_id.txt.

 Step 2: Create a Task
Run the script to create a task for the target. Replace TASK_NAME in the script with your desired value.
bash
sudo ./scripts/create_task.sh

The script will save the task ID to task_id.txt.

 Step 3: Run a Scan and Generate a Report
Run the Python script to start the scan and generate a report:
bash
sudo python3 ./scripts/scan_and_generate_report.py

The report will be saved as filtered_report.txt in the project directory.

---

 Cron Job Setup

Automate the scanning and reporting process by setting up cron jobs.

 Add the Following Cron Jobs
1. Schedule Scans and Reports Every 72 Hours:
   bash
   sudo crontab -e
   
   Add the following lines to the crontab:
   plaintext
    Run vulnerability scan and generate report every 72 hours
   0 0 /3   /usr/bin/python3 /path/to/vulnerability-scanning-automation/scripts/scan_and_generate_report.py >> /var/log/scan_and_report.log 2>&1
   

2. Verify Cron Jobs:
   List the cron jobs to ensure they are set up correctly:
   bash
   sudo crontab -l
   

3. Optional: Test Cron Jobs
   Test a cron job manually by running:
   bash
   sudo run-parts /etc/cron.hourly
   

---

 Reports

- Reports are saved as filtered_report.txt in the project directory.
- Vulnerabilities are filtered by severity (CVSS >= 4.0 for medium, high, and critical vulnerabilities).
- Modify the SEVERITY_THRESHOLD in scan_and_generate_report.py to adjust the severity filter.

---

 Troubleshooting

 Common Issues
1. No Report Generated:
   - Ensure the scan completes successfully.
   - Check the GVM logs:
     bash
     sudo tail -f /var/log/gvm/gvmd.log
     

2. Permission Denied Errors:
   - Ensure scripts have executable permissions:
     bash
     chmod +x ./scripts/.sh
     

3. Missing Task or Target ID:
   - Verify target_id.txt and task_id.txt exist and contain valid IDs.

---

 Customization

 Adjust Severity Filter
To include only high and critical vulnerabilities (CVSS >= 7.0), edit the SEVERITY_THRESHOLD value in scan_and_generate_report.py:
python
SEVERITY_THRESHOLD = 7.0   High and critical vulnerabilities only
