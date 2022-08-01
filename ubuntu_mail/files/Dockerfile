FROM ubuntu:latest
RUN mkdir /build && mkdir /build/postfix && mkdir /build/opendkim && mkdir /etc/opendkim \
&& ln -snf /usr/share/zoneinfo/Europe/Moscow /etc/localtime && echo Europe/Moscow > /etc/timezone
COPY starter.sh ./build
RUN apt-get -y update && apt-get install -y wget gcc build-essential libdb-dev libssl-dev tzdata libmysqlclient-dev m4 libbsd-dev libmilter-dev nano opendkim \
&& groupadd postfix && groupadd postdrop && useradd postfix -g postfix -s /usr/sbin/nologin && useradd postdrop -g postdrop -s /usr/sbin/nologin \
&& chmod +x /build/starter.sh \
&& cd /build && wget --directory-prefix=/build/ https://de.postfix.org/ftpmirror/official/postfix-3.7.2.tar.gz \
&& tar -xf /build/postfix-3.7.2.tar.gz -C /build/postfix \
&& cd /build/postfix/postfix-3.7.2/ && make && make install -non-interactive \
&& bash postfix-install -non-interactive \
       install_root=/ \
       config_directory=/etc/postfix \
       daemon_directory=/usr/libexec/postfix \
       command_directory=/usr/sbin \
       data_directory=/var/lib/postfix \
       queue_directory=/var/spool/postfix \
       sendmail_path=/usr/sbin/sendmail \
       newaliases_path=/usr/bin/newaliases \
       mailq_path=/usr/bin/mailq \
       mail_owner=postfix \
       setgid_group=postdrop \
       manpage_directory=/usr/local/man \
       readme_directory=no
ENTRYPOINT ["/build/starter.sh"]

