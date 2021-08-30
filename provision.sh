#! /usr/bin/env bash

set -o pipefail
set -e
set +x

CURR_DIR=$(pwd -P);
ANSIBLE_VAULT_PASSWORD_FILE="$CURR_DIR/.ansible_password";

help="Ansible provisioning wrapper\n\nUsage:\n\n./provision.sh --tags \$1 --limit \$2\n\nYou can add multiple comma-separated tags and limits.\n\nExample:\n\n./provision.sh --tags files --limit kermit-the-frog";
version=1.2.0

function brew_generate() {
 if [[ -z $tags || $tags == "homebrew"* ]]; then
    echo "Generating brew list for Ansible..."
    bash -c ". brew_generate.sh"
    echo "Done!"
  fi
}

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
  -b | --brew )
    brew_generate
    exit
    ;;
  -s | --security )
    skip_tags="false"
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
   brew_generate;
   echo "Running: $roles for tags=$tags, limit=$limit $POSITIONAL"
  if [[ -n $skip_tags ]]; then
    echo "Running with security tag, installing trusted root CA certificates..."
    pipenv run ansible-playbook ${roles}.yml -i hosts.yml --tags=$tags --limit=$limit $POSITIONAL
  elif [[ -n $tags ]]; then
    pipenv run ansible-playbook ${roles}.yml -i hosts.yml --tags=$tags --skip-tags="security" --limit=$limit $POSITIONAL
  else
    pipenv run ansible-playbook ${roles}.yml -i hosts.yml --limit=$limit $POSITIONAL
  fi
else
  echo "There should exist a password file: .ansible_password"
fi


