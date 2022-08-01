#!/usr/bin/env bash

[ -e "/etc/opendkim/$(hostname)".private ] || opendkim-genkey -D /etc/opendkim/ -d $(hostname -d) -s $(hostname)
echo $(hostname -f | sed s/\\./._domainkey./) $(hostname -d):$(hostname):$(ls /etc/opendkim/*.private) | tee -a /etc/opendkim/keytable
echo $(hostname -d) $(hostname -f | sed s/\\./._domainkey./) | tee -a /etc/opendkim/signingtable
rm -f /etc/opendkim.conf && rm -f /etc/postfix/main.cf
tee -a /etc/opendkim.conf  <<EOF
Canonicalization        relaxed/relaxed
KeyTable                /etc/opendkim/keytable
SigningTable            /etc/opendkim/signingtable
X-Header                yes
PidFile                 /run/opendkim/opendkim.pid
UserID                  opendkim
Socket                  inet:8891@localhost
EOF
tee -a /etc/postfix/main.cf <<EOF
compatibility_level = 3.7
queue_directory = /var/spool/postfix
command_directory = /usr/sbin
daemon_directory = /usr/libexec/postfix
data_directory = /var/lib/postfix
mail_owner = postfix
myhostname = mail.test.local
mydomain = test.local
inet_interfaces = all
mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain
unknown_local_recipient_reject_code = 550
mynetworks_style = subnet
mynetworks = 0.0.0.0/0
relayhost = $mydomain
debug_peer_level = 2
debugger_command =
         PATH=/bin:/usr/bin:/usr/local/bin:/usr/X11R6/bin
         ddd $daemon_directory/$process_name $process_id & sleep 5
sendmail_path = /usr/sbin/sendmail
newaliases_path = /usr/bin/newaliases
mailq_path = /usr/bin/mailq
setgid_group = postdrop
sample_directory = /etc/postfix
inet_protocols = ipv4
shlib_directory = no
meta_directory = /etc/postfix
smtpd_milters = inet:localhost:8891
non_smtpd_milters = $smtpd_milters
milter_default_action = accept
EOF
/etc/init.d/opendkim start
/usr/sbin/postfix start
sleep infinity
