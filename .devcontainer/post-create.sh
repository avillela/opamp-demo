#!/bin/bash

### -------------------
### Uncomment ll command in bashrc
### -------------------

sed -i -e "s/#alias ll='ls -l'/alias ll='ls -al'/g" ~/.bashrc
. $HOME/.bashrc


### -------------------
### Install kubectl
### -------------------

KUBECTL_VERSION=$(curl -fsSL https://dl.k8s.io/release/stable.txt)
ARCH=$(uname -m | sed 's/aarch64/arm64/;s/x86_64/amd64/')
curl -fsSL "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl" -o /tmp/kubectl
sudo install -o root -g root -m 0755 /tmp/kubectl /usr/local/bin/kubectl
rm /tmp/kubectl


### -------------------
### Install the OTel Collector binary
### -------------------

./install-otel-components.sh