#!/bin/bash
PWD=`pwd`

if [ ! -f "$PWD/shadowsocks.json" ];then
    echo 'file ./shadowsocks.json not found !'
    exit
fi

yum -y install net-tools vim
wget --no-check-certificate https://bootstrap.pypa.io/get-pip.py
python2.7 get-pip.py
pip install shadowsocks
cp $PWD/shadowsocks.json /etc/shadowsocks.json
systemctl stop firewalld
systemctl disable firewalld
ssserver -c /etc/shadowsocks.json -d start 
