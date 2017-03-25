#! /bin/bash

KEY="/Users/michael/.ssh/michaelfisher"

if [[ ! -a ${KEY} ]];then
  echo "Before provisioning, install ssh private key $KEY"
  exit 1
fi

# get pip and install ansible

/usr/bin/curl https://bootstrap.pypa.io/get-pip.py > /tmp/get-pip.py
sudo /usr/bin/python /tmp/get-pip.py
# install ansible and only run playbook if that succeeds
sudo pip install ansible && ansible-playbook provision_vm.yml
