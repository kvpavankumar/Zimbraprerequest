
userid=$(whoami) 

if [ "$userid" != "zimbra" ]; then
  echo "Run as zimbra user!"
  echo "Enter below command to Enter into Zimbra user"
  echo "su - zimbra"
  exit 1
fi


echo -e "Backup started: "
echo -e "Please enter New Server IP"
read NewServerIP
echo -e "Please enter enter New Server USER ID Ex: root"
read $USERID

echo -e "creating Backup Folder"
folder=/tmp/zmigrate/
mkdir $folder
cd  $folder
mkdir userpass userdata alias
echo -e "Backup Started"
echo -ne '#####                     (10%)\r'
zmprov -l gaa | grep -v galsync | grep -v spam. | grep -v ham. | grep -v virus-quarantine. >emails.txt
zmprov gad > domains.txt
echo -ne '#############             (30%)\r'
j=1
K=$(wc -l emails.txt | awk '{print $1}' )
for i in `cat emails.txt`; do echo -ne "Account $j/Total Account $K"; zmprov  -l ga $i userPassword | grep userPassword: | awk '{ print $2}' > userpass/$i.shadow;  j++ ;done
for i in `cat emails.txt`; do zmprov ga $i  | grep -i Name: > userdata/$i.txt ; done
zmprov gaaa > admins.txt
echo -ne '#####################     (90%)\r'
postconf mynetworks > postconf.txt

echo -n "Please Enter Destination Server IP (New Server) : "
rsync -avp -e /tmp/zmigrate  $USERID@$NewServerIP:/tmp/
echo -ne '##########################(100%)\r'
echo -ne 'Backup Completed'

