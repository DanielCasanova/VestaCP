# Ubuntu 18.04
FROM ubuntu:18.04
# Enviroment variables
ENV TERM=xterm
# Run updates
RUN apt-get update \
    && apt-get -yf upgrade \
    && apt-get -yf dist-upgrade \
    && apt-get -yf autoremove \
    && apt-get clean 
# Install require packages
RUN apt-get -yf install wget \
    && apt-get -yf install lsb-release \
    && apt-get -yf install gnupg \
    && apt-get -yf install vsftpd \
    && apt-get clean all
# Copy VSFTPD config
COPY configs/vsftpd.sh /etc/init.d/vsftpd
# vsftpd setup
RUN chmod 755 /etc/init.d/vsftpd
# Install vesta
RUN wget http://vestacp.com/pub/vst-install.sh -P /tmp/ \
    && chmod 755 /tmp/vst-install.sh \
    && cd /tmp \
    && sed -i -e "s/software\=\"nginx /software\=\"/g" /tmp/vst-install.sh \
# fix mariadb instead of mysql
    && sed -i -e "s/mysql\-/mariadb\-/g" /tmp/vst-install.sh \
# fix postgres-9.6 instead of 9.5
    && sed -i -e "s/postgresql postgresql-contrib /postgresql\-9\.6 postgresql\-contrib\-9\.6 postgresql\-client\-9\.6 /g" /tmp/vst-install.sh \
# begin install vesta
	&& bash /tmp/vst-install.sh --nginx yes --apache yes --phpfpm no --named yes --remi yes --vsftpd yes --proftpd no --iptables yes --fail2ban yes --quota no --exim yes --dovecot yes --spamassassin yes --clamav yes --softaculous yes --mysql yes --postgresql yes --password qwerty -y no --force
