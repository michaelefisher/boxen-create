#! /bin/bash

HOSTS=$1
USER="michael"
KEY="/Users/$USER/.ssh/michaelfisher"

if [[ ! -a ${KEY} ]];then
  echo "Before provisioning, install ssh private key $KEY"
  exit 1
fi

echo "copying ssh key to server"
ssh-copy-id -i $KEY $USER@$HOSTS

# get pip and install ansible

/usr/bin/curl https://bootstrap.pypa.io/get-pip.py > /tmp/get-pip.py
sudo /usr/bin/python /tmp/get-pip.py
# install ansible and only run playbook if that succeeds
sudo pip install ansible

if [[ `uname` == 'Darwin' ]]; then
  ansible-playbook -i hosts -l localhost provision_vm.yml -c local;
else
  ansible-playbook -i hosts -l `hostname -s` provision_vm.yml;
fi
