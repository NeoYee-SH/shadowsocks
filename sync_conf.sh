#!/bin/bash

local_ip=''
remote_ip=''
cd ~
scp -P port root@${remote_ip}:/etc/shadowsocks.json ./
sed -i  "s/${remote_ip}/${local_ip}/g" ./shadowsocks.json
mv -f ./shadowsocks.json /etc/shadowsocks.json
ssserver -c /etc/shadowsocks.json -d restart
cd -