#! /usr/bin/env bash

set -o pipefail

help="Usage: ./deploy_keys.sh -C \"name@domain.tld\" -i\n\n-C --comment\t\tComment and hostname\n-i --ssh-copy\t\tCopy to sssh server in comment\n"
version=1.0.0

[[ -z "$1" ]] && echo "Must include comment" && exit;
POSITIONAL=()
while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do case $1 in
  -V | --version )
    echo $version
    exit
    ;;
  -C | --comment )
    shift;
    comment=$1
    ;;
  -h | --help )
    shift; echo -e $help
    exit
    ;;
  -i | --ssh-copy )
    shift;
    copy_id=1;
    shift;
    ;;
  *)
    POSITIONAL+=("$1")
    ;;
esac; shift; done
if [[ "$1" == '--' ]]; then shift; fi
set -- "${POSITIONAL[@]}"

if [[ ! -z $comment && -d "$HOME/.ssh" ]]; then
  echo $comment
  echo $copy_id
  if [[ ! -f $HOME/.ssh/$comment ]]; then
    echo "Running...\nssh-keygen -m PEM -t rsa -b 4096 -f $HOME/.ssh/$comment -N "" -q -C ${comment}"
    ssh-keygen -m PEM -t rsa -b 4096 -f $HOME/.ssh/$comment -N "" -q -C $HOME/.ssh/$comment
    if [[ copy_id -eq 1 ]]; then
      echo "ssh-copy-id -i ${HOME/.ssh/$comment} ${comment}"
      ssh-copy-id -f -i $HOME/.ssh/$comment $comment
    fi
  else
    echo "SSH key already exists with that name."
  fi
fi
