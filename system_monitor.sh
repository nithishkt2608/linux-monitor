#!/bin/bash

# System Monitor with AWS SNS Alerts
# Author: Nithishkannan
# MCS @ Illinois Tech

SNS_TOPIC="arn:aws:sns:us-east-1:207495628549:system-monitor-alerts"
LOG_FILE="/var/log/system_monitor.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

# Thresholds
CPU_THRESHOLD=80
MEM_THRESHOLD=75
DISK_THRESHOLD=90

log_message() {
    echo "[$DATE] $1" >> $LOG_FILE
}

send_alert() {
    aws sns publish \
        --topic-arn "$SNS_TOPIC" \
        --message "$1" \
        --subject "🚨 System Alert - EC2 Monitor"
}

# CPU Check
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
log_message "CPU Usage: ${CPU_USAGE}%"
if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
    send_alert "ALERT: CPU usage is ${CPU_USAGE}% - above threshold of ${CPU_THRESHOLD}%"
    log_message "ALERT SENT: CPU above threshold"
fi

# Memory Check
MEM_USAGE=$(free | awk '/Mem/{printf("%.0f"), $3/$2*100}')
log_message "Memory Usage: ${MEM_USAGE}%"
if [ "$MEM_USAGE" -gt "$MEM_THRESHOLD" ]; then
    send_alert "ALERT: Memory usage is ${MEM_USAGE}% - above threshold of ${MEM_THRESHOLD}%"
    log_message "ALERT SENT: Memory above threshold"
fi

# Disk Check
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
log_message "Disk Usage: ${DISK_USAGE}%"
if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    send_alert "ALERT: Disk usage is ${DISK_USAGE}% - above threshold of ${DISK_THRESHOLD}%"
    log_message "ALERT SENT: Disk above threshold"
fi

# Services Check
for service in sshd crond; do
    if ! systemctl is-active --quiet $service; then
        send_alert "ALERT: Service $service is DOWN on EC2!"
        log_message "ALERT SENT: Service $service is down"
    fi
done

log_message "Monitor check complete"
echo "✅ Monitor check complete - $(date)"
