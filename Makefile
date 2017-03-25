.PHONY: macos provision vagrant release destroy

SHELL := /bin/bash

DO_API_KEY := $(shell echo "$$(cat ~/.bashrc-tokens | sed -n '1p')")
CURR_HASH := $(shell echo "$$(git rev-list --pretty=%h --max-count=1 HEAD | grep -v ^commit)")
VERSION="0.1.0"

api_key:
	@echo $(DO_API_KEY)

macos:
	@echo "Provisioning macOS box"
	./macOS_provision.sh

vagrant:
	vagrant up

digitalocean:
	./install_do.sh
	$(DO_API_KEY) vagrant up --provider=digital_ocean

provision:
	vagrant provision

release:
	git tag -a $(VERSION) -m "Release version: $(VERSION)"
	git push origin $(VERSION)

destroy:
	vagrant destroy

