# Linux System Monitor

A shell script monitoring tool that runs on AWS EC2 and sends SNS email alerts when CPU, memory or disk crosses defined thresholds.

## What It Does
- Monitors CPU usage every 5 minutes
- Monitors memory usage
- Monitors disk space
- Monitors critical running services (sshd, crond)
- Sends SNS email alert when threshold is breached
- Logs all activity to file
- Runs automatically via cron job

## Tech Stack
- Bash Shell Scripting
- AWS EC2 (Amazon Linux 2023)
- AWS SNS for email alerts
- AWS IAM for secure credentials
- Cron for scheduling

## ⚠️ Note
This script is designed to run on **AWS EC2 (Amazon Linux 2023)**.
It will not run correctly on Mac/Windows locally.

## How to Run
git clone https://github.com/nithishkt2608/linux-monitor
cd linux-monitor
chmod +x system_monitor.sh
./system_monitor.sh

## Thresholds
| Metric | Alert Threshold |
|--------|----------------|
| CPU | Above 80% |
| Memory | Above 75% |
| Disk | Above 90% |

## Architecture
EC2 Instance → Shell Script → AWS SNS → Email Alert

## Author
Built by Nithishkannan | MCS @ Illinois Tech
