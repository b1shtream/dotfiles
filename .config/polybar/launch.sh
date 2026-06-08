#!/usr/bin/env bash
# Launch (or relaunch) Polybar.

# Terminate any already-running bars
polybar-msg cmd quit >/dev/null 2>&1 || killall -q polybar
# wait until fully shut down
while pgrep -u "$UID" -x polybar >/dev/null; do sleep 0.2; done

# Detect the AMD k10temp CPU sensor (hwmon numbering changes across reboots)
for h in /sys/class/hwmon/hwmon*; do
  if [ "$(cat "$h/name" 2>/dev/null)" = "k10temp" ]; then
    export TEMP_HWMON="$h/temp1_input"
    break
  fi
done

# Launch the bar
polybar main 2>&1 | tee -a /tmp/polybar.log & disown

echo "polybar launched (TEMP_HWMON=${TEMP_HWMON:-unset})"
