#! /usr/bin/env bash

set -o pipefail
set -e
set +x

ANSIBLE_VAULT_PASSWORD_FILE='/Users/michael/boxen-create/ansible_password'

help="Ansible provisioning wrapper\n\nUsage:\n\n./provision.sh --tags \$1 --limit \$2\n\nYou can add multiple comma-separated tags and limits.\n\nExample:\n\n./provision.sh --tags files --limit kermit-the-frog"
version=1.0.0

[[ -z "$1" ]] && echo "Must include either tags or limit flags." && exit;
POSITIONAL=()
while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do case $1 in
  -V | --version )
    echo $version
    exit
    ;;
  -t | --tags )
    shift; tags=$1
    ;;
  -r | --roles )
    shift; roles=$1
    ;;
  -l | --limit )
    shift; limit=$1
    ;;
  -h | --help )
    shift; echo -e $help
    exit
    ;;
  *) # Allow for -v (and other native ansible-playbook flags)
    POSITIONAL+=("$1")
    ;;
esac; shift; done
if [[ "$1" == '--' ]]; then shift; fi
set -- "${POSITIONAL[@]}"

if [[ -f $ANSIBLE_VAULT_PASSWORD_FILE ]]; then
  if [[ $roles == "main" ]]; then
    echo "Generating brew list for Ansible..."
    bash -c ". brew_generate.sh"
  fi
  echo "Running: $roles for tags=$tags, limit=$limit $POSITIONAL"
  if [[ ! -z $tags ]]; then
    pipenv run ansible-playbook ${roles}.yml -i hosts.yml --tags=$tags --limit=$limit $POSITIONAL
  else
    pipenv run ansible-playbook ${roles}.yml -i hosts.yml --limit=$limit $POSITIONAL
  fi
else
  echo "There should exist a password file: ansible_password"
fi
