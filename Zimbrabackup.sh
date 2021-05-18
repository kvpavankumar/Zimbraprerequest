echo -n "Backup started: "
read NewServerIP
folder=/tmp/zmigrate/
mkdir $folder
cd  $folder
mkdir userpass userdata alias
zmprov -l gaa | grep -v galsync | grep -v spam. | grep -v ham. | grep -v virus-quarantine. >emails.txt
zmprov gad > domains.txt
for i in `cat emails.txt`; do zmprov  -l ga $i userPassword | grep userPassword: | awk '{ print $2}' > userpass/$i.shadow; done
for i in `cat emails.txt`; do zmprov ga $i  | grep -i Name: > userdata/$i.txt ; done
zmprov gaaa > admins.txt
postconf mynetworks > postconf.txt

echo -n "Please Enter Destination Server IP (New Server) : "
rsync -avp -e /tmp/zmigrate  root@$NewServerIP:/tmp/
