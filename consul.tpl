#!/bin/bash

apt-get update  && \
apt-get install -y unzip curl jq

#CHECKPOINT_URL="https://checkpoint-api.hashicorp.com/v1/check"
#if [ -z "$CONSUL_DEMO_VERSION" ]; then
#    CONSUL_DEMO_VERSION=$(curl -s "$CHECKPOINT_URL"/consul | jq .current_version | tr -d '"')
#fi

cd /tmp/
curl -s https://releases.hashicorp.com/consul/1.0.6/consul_1.0.6_linux_amd64.zip -o consul.zip

unzip consul.zip
sudo chmod +x consul
sudo mv consul /usr/bin/consul
sudo mkdir /etc/consul.d
sudo chmod a+w /etc/consul.d

IPADDRESS=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)

consul agent -server -bootstrap-expect=1 \
    -data-dir=/tmp/consul -node=agent-one -bind=$IPADDRESS \
    -enable-script-checks=true -config-dir=/etc/consul.d
