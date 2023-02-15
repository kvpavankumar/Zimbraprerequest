zmprov ms <mta fqdn > zimbraMtaHeaderChecks 'pcre:/opt/zimbra/conf/postfix_header_checks regexp:/opt/zimbra/conf/custom_header_checks'
zmprov ms mail.mailer4.actcorp.in  zimbraMtaHeaderChecks 'pcre:/opt/zimbra/conf/postfix_header_checks regexp:/opt/zimbra/conf/custom_header_checks'
zmprov mcf zimbraMtaBlockedExtensionWarnRecipient FALSE
zmprov mcf zimbraMtaSmtpdTlsCiphers high
zmprov mcf -zimbraReverseProxySSLProtocols TLSv1.1
zmprov mcf -zimbraReverseProxySSLProtocols TLSv1.0
zmprov mcf zimbraMtaSmtpTlsProtocols '!SSLv2,!SSLv3,TLSv1.2'
zmprov mcf zimbraMtaSmtpdTlsProtocols '!SSLv2,!SSLv3,TLSv1.2'
zmprov mcf zimbraMtaSmtpTlsMandatoryProtocols '!SSLv2,!SSLv3,TLSv1.2'
zmprov mcf zimbraMtaSmtpdTlsMandatoryProtocols '!SSLv2,!SSLv3,TLSv1.2'
zmlocalconfig -e zimbra_zmjava_options="-Xmx256m -Dhttps.protocols=TLSv1.2 -Djdk.tls.client.protocols=TLSv1.2 -Djava.net.preferIPv4Stack=true"
zmlocalconfig -e mailboxd_java_options='-server -Dhttps.protocols=TLSv1,TLSv1.1,TLSv1.2 -Djdk.tls.client.protocols=TLSv1,TLSv1.1,TLSv1.2 -Djava.awt.headless=true -Dsun.net.inetaddr.ttl=${networkaddress_cache_ttl} -Dorg.apache.jasper.compiler.disablejsr199=true -XX:+UseG1GC -XX:SoftRefLRUPolicyMSPerMB=1 -XX:+UnlockExperimentalVMOptions -XX:G1NewSizePercent=15 -XX:G1MaxNewSizePercent=45 -XX:-OmitStackTraceInFastThrow -verbose:gc -Xlog:gc*=info,safepoint=info:file=/opt/zimbra/log/gc.log:time:filecount=20,filesize=10m -Djava.security.egd=file:/dev/./urandom --add-opens java.base/java.lang=ALL-UNNAMED -Djava.net.preferIPv4Stack=true'
zmmtactl restart
zmcontrol start
