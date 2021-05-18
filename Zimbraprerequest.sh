#!/bin/bash

echo -n "Please insert your Domain name. : "
read DOMAIN
echo -n "Please insert your IP Address : "
read IPADDRESS


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
