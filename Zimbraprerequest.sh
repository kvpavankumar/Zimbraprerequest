#!/bin/bash
ID=`id -u`

if [ "x$ID" != "x0" ]; then
  echo "Run as root!"
  exit 1
fi

echo net.ipv6.conf.all.disable_ipv6=1 >>  /etc/sysctl.conf
echo net.ipv6.conf.default.disable_ipv6=1 >>  /etc/sysctl.conf
echo net.ipv6.conf.lo.disable_ipv6=1 >>  /etc/sysctl.conf
sudo sysctl -p


echo -n "Please Enter your Domain or hostname name. : "
read DOMAIN
echo -e "Install dependencies"
sleep 3

apt-get update -y
apt-get upgrade -y
apt-get install -y netcat-openbsd sudo libidn11 libpcre3 libgmp10 libexpat1 libstdc++6 libperl5* libaio1 resolvconf unzip pax sysstat sqlite3 net-tools mysql-client postgresql-client mysql-client
sudo apt install net-tools sshpass

sudo apt install  -y postgresql-client mysql-client

IPADDRESS=$(ifconfig | grep 'inet' |  awk '{print $2}' | grep -v '127.0.0.1')

echo -e "Disable service postfix and sendmail"
sleep 3
systemctl stop sendmail
systemctl stop postfix
systemctl disable sendmail
systemctl disable postfix
echo -e "Making Host Entries"
cp /etc/hosts /etc/hosts.backup
echo "$IPADDRESS   $DOMAIN       mail" > /etc/hosts
echo "127.0.0.1       localhost" >> /etc/hosts
echo -e "Defining Hostname Name"
hostnamectl set-hostname $DOMAIN
echo -e "Configuring Dns Entries"
cp /etc/resolvconf/resolv.conf.d/head /etc/resolvconf/resolv.conf.d/head.backup
echo "search $DOMAIN" > /etc/resolvconf/resolv.conf.d/head
echo "nameserver $IPADDRESS" >> /etc/resolvconf/resolv.conf.d/head
echo "nameserver 8.8.8.8" >> /etc/resolvconf/resolv.conf.d/head
echo -e "Downloading Zimbra Source File"
wget https://download.zextras.com/zcs-9.0.0_OSE_UBUNTU20_latest-zextras.tgz
       
tar xvf zcs-9.0.0_OSE_UBUNTU20_latest-zextras.tgz
cd zcs-9.0.0_ZEXTRAS_20231104.UBUNTU20_64.20231124123003

echo -e "Installing Zimbra "
sleep 5
./install.sh 
wget https://raw.githubusercontent.com/kvpavankumar/Zimbraprerequest/main/zimbrainfosec.sh > zimbrainfosec.sh
chmod 777 zimbrainfosec.sh
sh zimbrainfosec.sh

