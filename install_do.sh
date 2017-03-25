#! /bin/bash

# installing vagrant plugin
vagrant plugin install vagrant-digitalocean

# adding digital ocean box
BOX_EXIST=$(vagrant box list | grep "digital_ocean")
if [[ ! $BOX_EXIST == digital_ocean* ]]; then
	vagrant box add digital_ocean https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box
fi
