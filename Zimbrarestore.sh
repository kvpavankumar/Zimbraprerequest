#!/bin/bash

userid=$(whoami)

if [[ "$userid" != "zimbra" ]]; then
  echo "Run as zimbra user!"
  echo "Enter below command to Enter into Zimbra user"
  echo "su - zimbra"
  exit 1
fi

echo -e "Restoration process Started "

[ ! -e "/tmp/zmigrate/domains.txt" ] && { echo "File Not exists"; exit 1; }

for i in $(cat /tmp/zmigrate/domains.txt); do
  # Add a check to see if the domain exists
  zmprov gd $i &>/dev/null
  if [ $? -ne 0 ]; then
    echo "Domain $i does not exist."
    continue
  fi

  zmprov cd $i zimbraAuthMech zimbra
  echo $i
done

USERPASS="/tmp/zmigrate/userpass"
USERDDATA="/tmp/zmigrate/userdata"
USERS="/tmp/zmigrate/emails.txt"

[ ! -e "$USERPASS" ] && { echo "File Not exists"; exit 1; }
[ ! -e "$USERDDATA" ] && { echo "File Not exists"; exit 1; }
[ ! -e "$USERS" ] && { echo "File Not exists"; exit 1; }

for i in $(cat $USERS); do
  givenName=$(grep givenName: $USERDDATA/$i.txt | cut -d ":" -f2)
  displayName=$(grep displayName: $USERDDATA/$i.txt | cut -d ":" -f2)
  shadowpass=$(cat $USERPASS/$i.shadow)
  tmpPass="CHANGEme"
  zmprov ca $i CHANGEme cn "$givenName" displayName "$displayName" givenName "$givenName"
  zmprov ma $i userPassword "$shadowpass"
done

for i in $(cat /tmp/zmigrate/admins.txt); do
  zmprov ma $i zimbraIsAdminAccount TRUE
done
