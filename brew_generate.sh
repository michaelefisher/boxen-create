#!/usr/bin/env bash

which -s brew
if [[ $? == 0 && $(brew list --formula) ]]; then
  formulas=$(brew list --formula -1)
elif [[ $? == 0 ]]; then
  formulas=$(cat brew_formulas.txt)
else
  echo 'Homebrew not installed. Please install Homebrew at https://brew.sh.\n'
fi

echo "${formulas}" | sed -e :a -e '$!N; s/\n/\", \"/; ta' | sed 's/^/\[\"/' | sed 's/$/\"\]/' > roles/common/templates/brew_formulas.txt

which -s brew
if [[ $? == 0 && $(brew list --cask) ]]; then
  formulas=$(brew list --cask -1)
elif [[ $? == 0 ]]; then
  formulas=$(cat brew_cask.txt)
else
  echo 'Homebrew not installed. Please install Homebrew at https://brew.sh.\n'
fi

echo "${formulas}" | sed -e :a -e '$!N; s/\n/\", \"/; ta' | sed 's/^/\[\"/' | sed 's/$/\"\]/' > roles/common/templates/brew_cask.txt

