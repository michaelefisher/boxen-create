#! /usr/bin/env bash

ANSIBLE_VAULT_PASSWORD_FILE='/Users/michael/boxen-create/ansible_password'

if [[ -f $ANSIBLE_VAULT_PASSWORD_FILE ]]; then
    pipenv run ansible-playbook -i hosts main.yml --tags "${TAGS}" "$1" "$2" --ask-become-pass "$3"
else
	echo "There should exist a password file: ansible_password"
fi
