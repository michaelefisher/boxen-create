#! /usr/bin/env bash

set -o pipefail
set -e

ANSIBLE_VAULT_PASSWORD_FILE='/Users/michael/boxen-create/ansible_password'

help="Ansible provisioning wrapper\n\nUsage:\n\n./provision.sh --tags \$1 --limit \$2\n\nYou can add multiple comma-separated tags and limits.\n\nExample:\n\n./provision.sh --tags files --limit kermit-the-frog"
version=1.0.0

[[ -z "$1" ]] && echo "Must include either tags or limit flags." && exit;

while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do case $1 in
  -V | --version )
    echo $version
    exit
    ;;
  -t | --tags )
    shift; tags=$1
    ;;
  -l | --limit )
    shift; limit=$1
    ;;
  -h | --help )
    shift; echo -e $help
    exit
    ;;
esac; shift; done
if [[ "$1" == '--' ]]; then shift; fi


if [[ -f $ANSIBLE_VAULT_PASSWORD_FILE ]]; then
  echo "Running: main.yml for tags=$tags, limit=$limit"
  pipenv run ansible-playbook roles/common/main.yml -i hosts.yml --tags=$tags --limit=$limit
else
  echo "There should exist a password file: ansible_password"
fi
