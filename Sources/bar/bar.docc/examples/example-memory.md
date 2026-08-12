# Memory

A script that prints the current memory usage.

```shell
#!/bin/zsh

# Query vm_stat once (the previous version called it 5 times)
total_memory=$(sysctl -n hw.memsize)
vm=$(vm_stat)
page_size=$(echo "$vm" | awk 'NR==1 {print $8}')

active=$(echo "$vm"     | awk '/Pages active/    {sub("\\.","",$3); print $3}')
inactive=$(echo "$vm"   | awk '/Pages inactive/  {sub("\\.","",$3); print $3}')
speculative=$(echo "$vm" | awk '/Pages speculative/{sub("\\.","",$3); print $3}')
wired=$(echo "$vm"      | awk '/Pages wired down/{sub("\\.","",$4); print $4}')

used_mem_bytes=$(( (active + inactive + speculative + wired) * page_size ))
percentage=$(awk -v used="$used_mem_bytes" -v total="$total_memory" 'BEGIN { printf "%.0f", (used/total)*100 }')

(( percentage > 80 )) && echo " 􀧖 $percentage% " || exit 0
```

> Note: The block becomes visible only if usage exceeds 80%.
