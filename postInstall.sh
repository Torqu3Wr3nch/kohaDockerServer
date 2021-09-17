#!/bin/bash

CONTAINER_ALREADY_STARTED="CONTAINER_ALREADY_STARTED_PLACEHOLDER"
if [ ! -e $CONTAINER_ALREADY_STARTED ]; then
    touch $CONTAINER_ALREADY_STARTED
    echo "-- First container startup --"
    sed -i 's/INTRASUFFIX="-intra"/INTRASUFFIX=""/' /etc/koha/koha-sites.conf
    sed -i 's/INTRAPORT="80"/INTRAPORT="8081"/' /etc/koha/koha-sites.conf
    sed -i 's/OPACPORT="80"/OPACPORT="8080"/' /etc/koha/koha-sites.conf
    echo "Listen 8080" >> /etc/apache2/ports.conf
    echo "Listen 8081" >> /etc/apache2/ports.conf
    echo "library:koha_library:password:koha_library" >> /etc/koha/passwd
    koha-create --request-db library --passwdfile /etc/koha/passwd --dbhost db
    koha-create --populate-db library
    koha-enable library
    chown -R library-koha /var/log/koha/library
    tail -f /dev/null
else
    echo "-- Not first container startup --"
    apache2 restart
    tail -f /dev/null
fi