# Linux System Monitor

A shell script monitoring tool that runs on AWS EC2
and sends SNS alerts when CPU, memory or disk
crosses defined thresholds.

---

## What It Does

- Monitors CPU usage every 5 minutes
- Monitors memory usage
- Monitors disk space
- Monitors critical running services
- Sends SNS email alert when threshold breached
- Logs all activity to file
- Runs automatically via cron job

---

## Tech Stack

- Bash Shell Scripting
- AWS EC2 ( Amazon Linux 2023)
- AWS SNS for alerts
- Cron for scheduling

---

## How to Run

```bash
git clone https://github.com/nithishkt2608/linux-monitor
cd linux-monitor
chmod +x monitor.sh
./monitor.sh
```

---

## Thresholds

| Metric | Alert Threshold |
|---|---|
| CPU | Above 80% |
| Memory | Above 75% |
| Disk | Above 90% |

---
Built by Nithishkannan | MCS @ Illinois Tech
