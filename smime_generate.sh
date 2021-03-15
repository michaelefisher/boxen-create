#! /usr/bin/env bash

version=1.0.0

function set_verbose() {
  set +x;
}

function create_csr() {
  curr_dir=pwd;
  if [[ $curr_dir != "${HOME}/boxen-create/private" ]]; then
    cd $HOME/boxen-create/private;
  fi
  timestamp="$(date +%s)"
  generated_key="key-${timestamp}"

  echo -n "$key_file"

  # If not passing in a key, generate one
  if [[ -z $key_file ]]; then
    key_file=$generated_key;
  fi

  echo -e "Writing private key to..."$key_file""
    /usr/local/opt/openssl@1.1/bin/openssl req -nodes -newkey rsa:2048 -keyout $key_file -out $key_file.csr

  cd $curr_dir;
}

function generate_pkcs() {
  /usr/local/opt/openssl@1.1/bin/openssl pkcs12 -export -clcerts -inkey $key_file -in $crt -out $key_file.p12 -name "Michael E Fisher"
}

while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do case $1 in
  -v | --verbose )
    shift; set_verbose;
    ;;
  -V | --version )
    echo $version
    exit
    ;;
  -k | --key )
    shift; key_file=$1
    ;;
  -c | --csr)
    create_csr;
    exit;
    ;;
  -p | --p12)
    csr=$1; generate_pkcs;
    exit;
    ;;

esac; shift; done
if [[ "$1" == '--' ]]; then shift; fi

