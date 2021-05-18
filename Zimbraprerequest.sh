#!/bin/bash

echo -n "Please Enter your Domain name. : "
read DOMAIN
IPADDRESS=$(ifconfig | grep 'inet' |  awk '{print $2}' | grep -v '127.0.0.1')

echo -e "Install dependencies"
sleep 3
apt-get update -y
apt-get upgrade -y
apt-get install -y bind9 bind9utils netcat-openbsd sudo libidn11 libpcre3 libgmp10 libexpat1 libstdc++6 libperl5.26 libaio1 resolvconf unzip pax sysstat sqlite3 net-tools


echo -e "Disable service postfix and sendmail"
sleep 3
systemctl stop sendmail
systemctl stop postfix
systemctl disable sendmail
systemctl disable postfix

cp /etc/hosts /etc/hosts.backup

echo "$IPADDRESS   $DOMAIN       mail" >> /etc/hosts
echo "127.0.0.1       localhost" > /etc/hosts


hostnamectl set-hostname $DOMAIN

cp /etc/resolvconf/resolv.conf.d/head /etc/resolvconf/resolv.conf.d/head.backup

echo "search $DOMAIN" > /etc/resolvconf/resolv.conf.d/head
echo "nameserver $IPADDRESS" >> /etc/resolvconf/resolv.conf.d/head
echo "nameserver 8.8.8.8" >> /etc/resolvconf/resolv.conf.d/head


 wget https://files.zimbra.com/downloads/8.8.15_GA/zcs-8.8.15_GA_3869.UBUNTU18_64.20190918004220.tgz
 
 tar xvf zcs-8.8.15_GA_3869.UBUNTU18_64.20190918004220.tgz
 
 cd zcs-8.8.15_GA_3869.UBUNTU18_64.20190918004220
 
 ./install.sh


