#! /usr/bin/env bash

version=1.0.0

function set_verbose() {
  set +x;
}

function create_csr() {
  curr_dir=`pwd`;
  if [[ $curr_dir != "${HOME}/boxen-create/private" ]]; then
    cd $HOME/boxen-create/private;
  fi
  timestamp="$(date +%s)"
  generated_key="private_smime_key_${timestamp}.pem"

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
  echo -e "Writing out p12 file to..."${key_file}.p12""
  key_file_real=$(realpath -s $key_file)
  crt_real=$(realpath -s $crt)
  /usr/local/opt/openssl@1.1/bin/openssl pkcs12 -export -clcerts -inkey $key_file_real -in $crt_real -out $key_file.p12 -name "Michael E Fisher"
  if [[ $? == 0 ]]; then
    echo -e "p12 file written successfully."
  else
    echo -e "Writing failed."
  fi
}

while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do case $1 in
  -v | --verbose )
    shift; set_verbose;
    ;;
  -V | --version )
    echo $version
    exit
    ;;
  -t | --cert )
    shift; crt=$1
    ;;
  -k | --key )
    shift; key_file=$1
    ;;
  -c | --csr)
    create_csr;
    exit;
    ;;
  -p | --p12)
    generate_pkcs;
    exit;
    ;;

esac; shift; done
if [[ "$1" == '--' ]]; then shift; fi

