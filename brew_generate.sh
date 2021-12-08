#!/usr/bin/env bash

set -o pipefail

freeze() {
  which -s brew
  if [[ $? == 0 ]]; then
  sort -u <(brew list --full-name --formula -1) > brew_requirements.txt
  echo -e "Freezing formula requirements...\n"
  cat brew_requirements.txt

  sort -u <(brew list --full-name --cask -1) > brew_cask_requirements.txt
  echo -e "Freezing cask requirements...\n"
  cat brew_cask_requirements.txt

  else
    echo 'Homebrew not installed. Please install Homebrew at https://brew.sh.\n'
  fi

 }

generate() {
  # Generate diff for brew formulas
  comm -3 brew_requirements.txt <(brew list --full-name --formula -1 | sort -u) | sed 's/^\t//' > /tmp/brew_uninstall.txt
  cat /tmp/brew_uninstall.txt

  # Generate diff for brew cask
  comm -3 brew_cask_requirements.txt <(brew list --full-name --cask -1 | sort -u) | sed 's/^\t//' > /tmp/brew_cask_uninstall.txt
  cat /tmp/brew_cask_uninstall.txt
}

$1

