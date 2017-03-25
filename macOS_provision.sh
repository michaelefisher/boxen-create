#! /bin/bash

KEY="/Users/michael/.ssh/michaelfisher.pem"

if [[ ! -a ${KEY} ]];then
  echo "Before provisioning, install ssh private key $KEY"
  exit 1
fi

# get pip and install ansible

curl https://bootstrap.pypa.io/get-pip.py > /tmp/get-pip.py
sudo python /tmp/get-pip.py
# install ansible and only run playbook if that succeeds
sudo pip install ansible && ansible-playbook provision_vm.yml
