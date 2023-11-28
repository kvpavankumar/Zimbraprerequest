su - zimbra -c 'echo "/^Subject:/ WARN" > /opt/zimbra/conf/custom_header_checks'
su - zimbra -c 'zmprov mcf zimbraMtaBlockedExtensionWarnRecipient FALSE'
su - zimbra -c 'zmamavisdctl restart'
su - zimbra -c 'zmprov mcf zimbraMtaHeaderChecks "pcre:/opt/zimbra/conf/postfix_header_checks,  pcre:/opt/zimbra/conf/custom_header_checks"'
su - zimbra -c 'postconf -ev disable_vrfy_command=yes'
su - zimbra -c 'zmmtactl restart'
su - zimbra -c 'zmprov mcf zimbraMtaSmtpdTlsCiphers high'
su - zimbra -c 'zmprov mcf -zimbraReverseProxySSLProtocols TLSv1.1'
su - zimbra -c 'zmprov mcf -zimbraReverseProxySSLProtocols TLSv1.0'
su - zimbra -c 'zmprov mcf zimbraMtaSmtpTlsProtocols "!SSLv2,!SSLv3,TLSv1.2"'
su - zimbra -c 'zmprov mcf zimbraMtaSmtpdTlsProtocols "!SSLv2,!SSLv3,TLSv1.2"'
su - zimbra -c 'zmprov mcf zimbraMtaSmtpTlsMandatoryProtocols "!SSLv2,!SSLv3,TLSv1.2"'
su - zimbra -c 'zmprov mcf zimbraMtaSmtpdTlsMandatoryProtocols "!SSLv2,!SSLv3,TLSv1.2"'
su - zimbra -c 'zmprov mcf zimbraMtaSmtpdTlsProtocols ">=TLSv1.2"'
su - zimbra -c 'zmprov mcf +zimbraSSLExcludeCipherSuites TLS_ECDH_anon_WITH_AES_128_CBC_SHA'
su - zimbra -c 'zmprov mcf +zimbraSSLExcludeCipherSuites  TLS_ECDH_anon_WITH_AES_256_CBC_SHA'
su - zimbra -c 'zmprov mcf +zimbraSSLExcludeCipherSuites         TLS_DH_anon_WITH_AES_256_CBC_SHA'
su - zimbra -c 'zmprov mcf +zimbraSSLExcludeCipherSuites         TLS_DH_anon_WITH_AES_256_CBC_SHA256'
su - zimbra -c 'zmprov mcf +zimbraSSLExcludeCipherSuites         TLS_DH_anon_WITH_AES_256_GCM_SHA384'
su - zimbra -c 'zmprov mcf +zimbraSSLExcludeCipherSuites         TLS_DH_anon_WITH_CAMELLIA_128_CBC_SHA'
su - zimbra -c 'zmprov mcf +zimbraSSLExcludeCipherSuites         TLS_DH_anon_WITH_CAMELLIA_128_CBC_SHA256'
su - zimbra -c 'zmprov mcf +zimbraSSLExcludeCipherSuites         TLS_DH_anon_WITH_CAMELLIA_256_CBC_SHA'
su - zimbra -c 'zmprov mcf +zimbraSSLExcludeCipherSuites         TLS_DH_anon_WITH_CAMELLIA_256_CBC_SHA256'
su - zimbra -c 'zmprov mcf +zimbraSSLExcludeCipherSuites SSL_RSA_WITH_DES_CBC_SHA'
su - zimbra -c 'zmprov mcf +zimbraSSLExcludeCipherSuites SSL_DHE_RSA_WITH_DES_CBC_SHA'
su - zimbra -c 'zmprov mcf +zimbraSSLExcludeCipherSuites SSL_DHE_DSS_WITH_DES_CBC_SHA'
su - zimbra -c 'zmprov mcf +zimbraSSLExcludeCipherSuites SSL_RSA_EXPORT_WITH_RC4_40_MD5'
su - zimbra -c 'zmprov mcf +zimbraSSLExcludeCipherSuites SSL_RSA_EXPORT_WITH_DES40_CBC_SHA'
su - zimbra -c 'zmprov mcf +zimbraSSLExcludeCipherSuites SSL_DHE_RSA_EXPORT_WITH_DES40_CBC_SHA'
su - zimbra -c 'zmprov mcf +zimbraSSLExcludeCipherSuites SSL_DHE_DSS_EXPORT_WITH_DES40_CBC_SHA'
su - zimbra -c 'zmprov mcf +zimbraSSLExcludeCipherSuites ".*_(3DES|RC4)_.*"'
su - zimbra -c 'zmprov modifyServer $(hostname) zimbraMtaTlsAuthOnly FALSE'
su - zimbra -c 'zmprov mcf +zimbraSSLExcludeCipherSuites TLS_RSA_WITH_AES_128_CBC_SHA'
su - zimbra -c 'zmprov mcf zimbraMtaSmtpdTlsExcludeCiphers aNULL,eNULL,LOW,3DES,MD5,EXP,PSK,DSS,RC4,SEED,ECDSA,DES,EXPORT'
su - zimbra -c 'zmprov mcf zimbraMtaSmtpdTlsCiphers medium'
su - zimbra -c 'zmprov mcf zimbraMtaSmtpdTlsMandatoryCiphers  medium'
su - zimbra -c 'zmcontrol restart'
su - zimbra -c 'zmlocalconfig -e zimbra_zmjava_options="-Xmx256m -Dhttps.protocols=TLSv1.2 -Djdk.tls.client.protocols=TLSv1.2 -Djava.net.preferIPv4Stack=true"'
su - zimbra -c 'zmcontrol restart'
su - zimbra -c 'zmlocalconfig -e mailboxd_java_options="-server -Dhttps.protocols=TLSv1.2,TLSv1.3 -Djdk.tls.client.protocols=TLSv1.2,TLSv1.3 -Djava.awt.headless=true -Dsun.net.inetaddr.ttl=${networkaddress_cache_ttl} -Dorg.apache.jasper.compiler.disablejsr199=true -XX:+UseG1GC -XX:SoftRefLRUPolicyMSPerMB=1 -XX:+UnlockExperimentalVMOptions -XX:G1NewSizePercent=15 -XX:G1MaxNewSizePercent=45 -XX:-OmitStackTraceInFastThrow -verbose:gc -Xlog:gc*=info,safepoint=info:file=/opt/zimbra/log/gc.log:time:filecount=20,filesize=10m -Djava.net.preferIPv4Stack=true -Djava.security.egd=file:/dev/./urandom --add-opens java.base/java.lang=ALL-UNNAMED"'
IPADDRESS=$(ifconfig | grep 'inet' |  awk '{print $2}' | grep -v '127.0.0.1')
su - zimbra -c "zmprov ms $(hostname) zimbraMtaMyNetworks '127.0.0.0/8 $IPADDRESS/32'"
su - zimbra -c 'zmcontrol restart'

sudo curl https://raw.githubusercontent.com/kvpavankumar/Zimbrapostfixlogs/master/50-default.conf > /etc/rsyslog.d/50-default.conf
sudo curl https://raw.githubusercontent.com/kvpavankumar/Zimbrapostfixlogs/master/rsyslog> /etc/logrotate.d/rsyslog 
sudo curl https://raw.githubusercontent.com/kvpavankumar/Zimbrapostfixlogs/master/rsyslog.conf>/etc/rsyslog.conf
sudo systemctl restart syslog.service
sudo curl https://raw.githubusercontent.com/kvpavankumar/Zimbrapostfixlogs/master/zimbra_pflogsumm.pl >/opt/zimbra/bin/zimbra_pflogsumm.pl
chmod 777  /opt/zimbra/bin/zimbra_pflogsumm.pl
curl -k https://10.100.112.139/bouncedatadb.sh > /root/bouncedatadb.sh
curl -k https://10.100.112.139/bulkdatapavan.sh > /root/bulkdatapavan.sh
curl -k https://10.100.112.139/postcheck.sh > /root/postcheck.sh
curl -k https://10.100.112.139/serverinfo.sh > /opt/zimbra/serverinfo.sh
chmod 777 /opt/zimbra/serverinfo.sh
su - zimbra -c "(crontab -l ; echo '00 07 * * * /opt/zimbra/serverinfo.sh') | crontab -"
(crontab -l ; echo "*/5 * * * * /root/bouncedatadb.sh") | crontab -
(crontab -l ; echo "00 07 * * * 15 01 * * * /root/bulkdatapavan.sh") | crontab -

