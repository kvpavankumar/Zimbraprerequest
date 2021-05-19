userid=$(whoami) 
if [ "userid" != "zimbra" ]; then
  echo "Run as zimbra!"
  exit 1
fi

for i in `cat /tmp/zmigrate/domains.txt `; do  zmprov cd $i zimbraAuthMech zimbra ;echo $i ;done

USERPASS="/tmp/zmigrate/userpass"
USERDDATA="/tmp/zmigrate/userdata"
USERS="/tmp/zmigrate/emails.txt"

for i in `cat $USERS`
do
givenName=$(grep givenName: $USERDDATA/$i.txt | cut -d ":" -f2)
displayName=$(grep displayName: $USERDDATA/$i.txt | cut -d ":" -f2)
shadowpass=$(cat $USERPASS/$i.shadow)
tmpPass="CHANGEme"
zmprov ca $i CHANGEme cn "$givenName" displayName "$displayName" givenName "$givenName"
zmprov ma $i userPassword "$shadowpass"
done
for i in `cat /tmp/zmigrate/admins.txt`; do zmprov ma $i zimbraIsAdminAccount TRUE ; done

