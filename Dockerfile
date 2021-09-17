FROM ubuntu:latest

RUN apt update && apt install gnupg gnupg1 gnupg2 wget nano -y && \
    echo deb http://debian.koha-community.org/koha stable main | tee /etc/apt/sources.list.d/koha.list

RUN wget -O- https://debian.koha-community.org/koha/gpg.asc | apt-key add - && apt update

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=CST6CDT
RUN apt-get install -y tzdata 

RUN apt-get install -y koha-common
RUN a2enmod rewrite && a2enmod cgi && service apache2 restart

COPY postInstall.sh /etc/koha/postInstall.sh
RUN chmod +x /etc/koha/postInstall.sh

WORKDIR /etc/koha
VOLUME /etc/koha /etc/apache2 /var/log/koha