zmprov ms $hostname zimbraMtaHeaderChecks 'pcre:/opt/zimbra/conf/postfix_header_checks regexp:/opt/zimbra/conf/custom_header_checks'
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
zmprov mcf +zimbraSSLExcludeCipherSuites TLS_ECDH_anon_WITH_AES_128_CBC_SHA
zmprov mcf +zimbraSSLExcludeCipherSuites  TLS_ECDH_anon_WITH_AES_256_CBC_SHA
zmprov mcf +zimbraSSLExcludeCipherSuites         TLS_DH_anon_WITH_AES_256_CBC_SHA
zmprov mcf +zimbraSSLExcludeCipherSuites         TLS_DH_anon_WITH_AES_256_CBC_SHA256
zmprov mcf +zimbraSSLExcludeCipherSuites         TLS_DH_anon_WITH_AES_256_GCM_SHA384
zmprov mcf +zimbraSSLExcludeCipherSuites         TLS_DH_anon_WITH_CAMELLIA_128_CBC_SHA
zmprov mcf +zimbraSSLExcludeCipherSuites         TLS_DH_anon_WITH_CAMELLIA_128_CBC_SHA256
zmprov mcf +zimbraSSLExcludeCipherSuites         TLS_DH_anon_WITH_CAMELLIA_256_CBC_SHA
zmprov mcf +zimbraSSLExcludeCipherSuites         TLS_DH_anon_WITH_CAMELLIA_256_CBC_SHA256
zmprov mcf +zimbraSSLExcludeCipherSuites SSL_RSA_WITH_DES_CBC_SHA
zmprov mcf +zimbraSSLExcludeCipherSuites SSL_DHE_RSA_WITH_DES_CBC_SHA
zmprov mcf +zimbraSSLExcludeCipherSuites SSL_DHE_DSS_WITH_DES_CBC_SHA
zmprov mcf +zimbraSSLExcludeCipherSuites SSL_RSA_EXPORT_WITH_RC4_40_MD5
zmprov mcf +zimbraSSLExcludeCipherSuites SSL_RSA_EXPORT_WITH_DES40_CBC_SHA
zmprov mcf +zimbraSSLExcludeCipherSuites SSL_DHE_RSA_EXPORT_WITH_DES40_CBC_SHA
zmprov mcf +zimbraSSLExcludeCipherSuites SSL_DHE_DSS_EXPORT_WITH_DES40_CBC_SHA
zmprov mcf +zimbraSSLExcludeCipherSuites '.*_(3DES|RC4)_.*'
zmprov mcf +zimbraSSLExcludeCipherSuites TLS_RSA_WITH_AES_128_CBC_SHA
zmprov mcf zimbraMtaSmtpdTlsExcludeCiphers aNULL,eNULL,LOW,3DES,MD5,EXP,PSK,DSS,RC4,SEED,ECDSA,DES,EXPORT
zmprov mcf zimbraMtaSmtpdTlsCiphers medium
zmprov mcf zimbraMtaSmtpdTlsMandatoryCiphers  medium
zmprov mcf zimbraMtaSmtpdTlsProtocols '>=TLSv1.2'
zmcontrol restart


zmmtactl restart
zmcontrol start
