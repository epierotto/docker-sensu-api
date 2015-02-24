FROM ubuntu:trusty
MAINTAINER Exequiel Pierotto <epierotto@abast.es>

# Install sensu
RUN \
	apt-get update &&\
        apt-get install wget -y && \
	wget -qO - http://repos.sensuapp.org/apt/pubkey.gpg | apt-key add - && \
	echo "deb     http://repos.sensuapp.org/apt sensu main" > /etc/apt/sources.list.d/sensu.list && \
	apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y sensu && \
	sed -i 's/files dns/dns files/g' /etc/nsswitch.conf

# Add the sensu-server config files
COPY files/api.json /etc/sensu/api.json

# SSL sensu-server settings
COPY files/ssl/cert.pem /etc/sensu/ssl/cert.pem
COPY files/ssl/key.pem /etc/sensu/ssl/key.pem

RUN chgrp -R sensu /etc/sensu

# Sync with a local directory or a data volume container
#VOLUME /etc/sensu

EXPOSE 4567

CMD /opt/sensu/bin/sensu-api -c /etc/sensu/api.json -d /etc/sensu/conf.d
