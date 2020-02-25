#! /usr/bin/env bash

ANSIBLE_VAULT_PASSWORD_FILE='./ansible_password'

if [[ -f $ANSIBLE_VAULT_PASSWORD_FILE ]]; then
    pipenv run ansible-playbook -i hosts provision.yml --tags "${TAGS}" "$1" "$2" 2>&1> /dev/null
else
	echo "There should exist a password file: ansible_password"
fi
