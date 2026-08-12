# CPU

A script that prints the current CPU usage.

```shell
#!/bin/zsh

core_count=$(sysctl -n machdep.cpu.thread_count)
user=$(whoami)
cpu_info=$(ps -eo pcpu,user)

# Split CPU usage into system (other users) vs. current user, normalised by core count
cpu_sys=$(echo "$cpu_info"  | grep -v "$user" | sed 's/[^ 0-9.]//g' | awk "{sum+=\$1} END {print sum/(100.0 * $core_count)}")
cpu_user=$(echo "$cpu_info" | grep "$user"    | sed 's/[^ 0-9.]//g' | awk "{sum+=\$1} END {print sum/(100.0 * $core_count)}")

percentage=$(awk -v sys="$cpu_sys" -v user="$cpu_user" 'BEGIN { printf "%.0f", (sys + user) * 100 }')

(( percentage > 10 )) && echo " 􀧓 $percentage% " || exit 0
```

> Note: The block becomes visible only if usage exceeds 10%.
