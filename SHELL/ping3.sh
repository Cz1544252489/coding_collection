#!/bin/bash

# 三个目标
local_ip="192.168.100.1"      # 路由器
china_ip="baidu.com"
server_ip="192.168.194.12"    # Zerotier 虚拟内网服务器

# 输出表头
printf "%-25s %-25s %-25s\n" "Router($local_ip)" "Baidu($china_ip)" "Server($server_ip)"
echo "-------------------------------------------------------------------------------"

i=0
# 无限循环
while true; do
    # 分别获取三次 ping 的延迟
	ping1=$(ping -n 1 $local_ip | grep -Eo '=[0-9]+ms' | sed -e 's/=//');
	ping2=$(ping -n 1 $china_ip | grep -Eo '=[0-9]+ms' | sed -e 's/=//');
	ping3=$(ping -n 1 $server_ip | grep -Eo '=[0-9]+ms' | sed -e 's/=//');

    # 如果超时，显示 "timeout"
    [[ -z "$ping1" ]] && ping1="timeout"
    [[ -z "$ping2" ]] && ping2="timeout"
    [[ -z "$ping3" ]] && ping3="timeout"

    # 打印一行结果
    printf "%-5s %-25s %-25s %-25s\n" "$i" "$ping1" "$ping2" "$ping3"
	((i++))
	if (( i% 5 ==0)); then
		IP=$(curl -s cip.cc | grep IP | sed -e 's/^.*: //');
		printf "%-5s ----- %-25s --------------\n" "$i" "$IP"
	fi
    sleep 1
done

