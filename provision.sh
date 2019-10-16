#! /bin/bash

# ./provision.sh localhost michaelfisher michael

HOSTS=$1
USER=$3
KEYNAME=$2
KEY="/Users/$USER/.ssh/$KEYNAME"

if [[ ! -a ${KEY} ]];then
  echo "Before provisioning, install ssh private key $KEY"
  exit 1
fi

# install brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# get pip and install ansible

/usr/bin/curl https://bootstrap.pypa.io/get-pip.py > /tmp/get-pip.py
sudo /usr/bin/python /tmp/get-pip.py
# install ansible and only run playbook if that succeeds
sudo pip install ansible

if [[ -z ${HOSTS} ]]; then
	printf "HOSTS...\n"
  ansible-playbook -i hosts -l localhost provision.yml -c local;
elif [[ $HOSTS ]]; then
	ansible-playbook -i hosts -l $HOSTS provision.yml;
else
  ansible-playbook -i hosts -l `hostname -s` provision.yml;
fi
