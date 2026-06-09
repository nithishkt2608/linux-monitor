#!/bin/bash

# Linux System Monitor
# Author: Nithishkannan
# Description: Monitors CPU, Memory, Disk usage and alerts if thresholds are exceeded

# Thresholds
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80

echo "=============================="
echo "   SYSTEM MONITOR REPORT"
echo "   $(date)"
echo "=============================="

# CPU Usage
CPU_USAGE=$(top -l 1 | grep "CPU usage" | awk '{print $3}' | tr -d '%')
echo ""
echo "🖥  CPU Usage: ${CPU_USAGE}%"
if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
    echo "⚠️  ALERT: CPU usage is above ${CPU_THRESHOLD}%!"
fi

# Memory Usage
MEM_TOTAL=$(sysctl hw.memsize | awk '{print $2}')
MEM_USED=$(vm_stat | awk '/Pages active/ {print $3}' | tr -d '.')
MEM_USED_MB=$((MEM_USED * 4096 / 1024 / 1024))
MEM_TOTAL_MB=$((MEM_TOTAL / 1024 / 1024))
MEM_PERCENT=$((MEM_USED_MB * 100 / MEM_TOTAL_MB))
echo ""
echo "💾  Memory Usage: ${MEM_USED_MB}MB / ${MEM_TOTAL_MB}MB (${MEM_PERCENT}%)"
if [ "$MEM_PERCENT" -gt "$MEM_THRESHOLD" ]; then
    echo "⚠️  ALERT: Memory usage is above ${MEM_THRESHOLD}%!"
fi

# Disk Usage
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
DISK_USED=$(df -h / | awk 'NR==2 {print $3}')
DISK_TOTAL=$(df -h / | awk 'NR==2 {print $2}')
echo ""
echo "💿  Disk Usage: ${DISK_USED} / ${DISK_TOTAL} (${DISK_USAGE}%)"
if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    echo "⚠️  ALERT: Disk usage is above ${DISK_THRESHOLD}%!"
fi

# Top 5 Running Processes
echo ""
echo "📊  Top 5 Processes by CPU:"
ps aux | sort -rk 3,3 | head -6 | tail -5 | awk '{printf "   %-10s %s%%\n", $11, $3}'

echo ""
echo "=============================="
echo "   END OF REPORT"
echo "=============================="