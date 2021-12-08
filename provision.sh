#! /usr/bin/env bash

set -o pipefail
set -e

CURR_DIR=$(pwd -P);
ANSIBLE_VAULT_PASSWORD_FILE="$CURR_DIR/.ansible_password";
SCRIPT_DIRECTORY="$HOME/boxen-create";

help="Ansible provisioning wrapper\n\nUsage:\n\n./provision.sh --tags \$1 --limit \$2\n\nYou can add multiple comma-separated tags and limits.\n\nExample:\n\n./provision.sh --tags files --limit kermit-the-frog";
version=2.1.0

function brew_generate() {
 if [[ -z $tags || $tags == "homebrew"* ]]; then
    echo -e "Generating change list for homebrew formulas\n"
    (cd $SCRIPT_DIRECTORY && bash -c ". brew_generate.sh generate")
    # Format brew formula requirements
    tr '\n' ',' < brew_requirements.txt | sed 's/,$//g' > roles/common/templates/brew_requirements.txt
    tr '\n' ',' < /tmp/brew_uninstall.txt | sed 's/,$//g' > roles/common/templates/brew_uninstall.txt

    # Format brew formula requirements
    echo -e "Generating change list for homebrew casks\n"
    tr '\n' ',' < brew_cask_requirements.txt | sed 's/,$//g' > roles/common/templates/brew_cask_requirements.txt
    tr '\n' ',' < /tmp/brew_cask_uninstall.txt | sed 's/,$//g' > roles/common/templates/brew_cask_uninstall.txt
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
  --setup )
    setup=true
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
  --dry-run )
    dry_run=true
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

if [[ $setup == true ]]; then
  echo -e "Copying to '\$PATH'"
  cp $SCRIPT_DIRECTORY/provision.sh /usr/local/bin/provisioner;
  copy="$!"
  if [[ $copy -eq 0 ]]; then
    echo -e "Installed as provisioner";
    exit 0;
  fi
fi

if [[ -f $ANSIBLE_VAULT_PASSWORD_FILE ]]; then
   brew_generate;
   echo "Running: $roles for tags=$tags, limit=$limit $POSITIONAL"
  if [[ -n $skip_tags ]]; then
    echo "Running with security tag, installing trusted root CA certificates..."
    command="cd $SCRIPT_DIRECTORY && pipenv run ansible-playbook ${roles}.yml -i \
      hosts.yml --tags=$tags --limit=$limit $POSITIONAL"
    [[ $dry_run == true ]] && echo $command || (eval $command)
  elif [[ -n $tags ]]; then
    command="cd $SCRIPT_DIRECTORY && pipenv run ansible-playbook ${roles}.yml -i \
      hosts.yml --tags=$tags --skip-tags="security" --limit=$limit $POSITIONAL"
    [[ $dry_run == true ]] && echo $command || (eval $command)
  else
    command="cd $SCRIPT_DIRECTORY && pipenv run ansible-playbook ${roles}.yml -i \
      hosts.yml --limit=$limit $POSITIONAL"
    [[ $dry_run == true ]] && echo $command || (eval $command)
  fi
  [[ "$?" -eq 0 ]] && rm roles/common/templates/brew_uninstall.txt
else
  echo "There should exist a password file: .ansible_password"
fi


