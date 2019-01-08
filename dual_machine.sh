#!/bin/bash

#解绑虚拟ip
function_remove_vip()
{
    /sbin/ifconfig enp0s8:$1 $2 broadcast 192.168.56.255 netmask 255.255.255.0 down
}

#绑定虚拟ip
function_bind_vip()
{
    /sbin/ifconfig enp0s8:$1 $2 broadcast 192.168.56.255 netmask 255.255.255.0 up
    /sbin/route add -host $2 dev enp0s8:$1
}

#广播地址
function_vip_arping()
{
    /sbin/arping -I enp0s8 -c 3 -s $1 192.168.56.1
}

IP1='192.168.56.104'
IP2='192.168.56.105'

VIP1='192.168.56.110'
VIP2='192.168.56.111'

BIND_VIP1="Y"
BIND_VIP2="Y"

PORT=8765

while true;do

    if [ `ifconfig |grep ${VIP1}|wc -l` -eq 0 ]; then
        BIND_VIP1="N"
    else
        BIND_VIP1="Y"
    fi

    if [ `ifconfig |grep ${VIP2}|wc -l` -eq 0 ]; then
        BIND_VIP2="N"
    else
        BIND_VIP2="Y"
    fi

    STATUS1=`nmap -sS -p ${PORT} ${IP1}|grep open`
    STATUS2=`nmap -sS -p ${PORT} ${IP2}|grep open`

#监测IP1
    if [ -z "$STATUS1" ]; then
        if [ ${BIND_VIP1} == "Y" ]; then
            function_remove_vip 1 ${VIP1}
            BIND_VIP1="N"
        fi
    else
        if [ ${BIND_VIP1} == "N" ]; then
            function_bind_vip 1 ${VIP1}
            function_vip_arping ${VIP1}
            BIND_VIP1="Y"
        fi
    fi
#监测IP2
    if [ ! -z "$STATUS2" ]; then
        if [ ${BIND_VIP2} == "Y" ]; then
            function_remove_vip 2 ${VIP2}
            BIND_VIP2="N"
        fi
    else
        if [ ${BIND_VIP2} == "N" ]; then
            function_bind_vip 2 ${VIP2}
            function_vip_arping ${VIP2}
            BIND_VIP2="Y"
        fi
    fi
    sleep 2
done

