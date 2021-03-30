#!/usr/bin/env bash

which -s brew
if [[ $? == 0 ]]; then
  formulas_installed=$(brew list -1)
  formulas_requested=$(cat brew.txt | sort)
else
  echo 'Homebrew not installed. Please install Homebrew at https://brew.sh.\n'
fi

if [[ `diff <(echo "$formulas_installed") <(echo "$formulas_requested")` ]]; then
  echo "${formulas_requested}" | sed -e :a -e '$!N; s/\n/\", \"/; ta' | sed 's/^/\[\"/' | sed 's/$/\"\]/' > roles/common/templates/brew_formulas.txt
fi

which -s brew
if [[ $? == 0 ]]; then
  formulas_installed=$(brew list --cask -1)
  formulas_requested=$(cat brew_cask.txt | sort)
else
  echo 'Homebrew not installed. Please install Homebrew at https://brew.sh.\n'
fi

if [[ `diff <(echo "$formulas_installed") <(echo "$formulas_requested")` ]]; then
  echo "${formulas_requested}" | sed -e :a -e '$!N; s/\n/\", \"/; ta' | sed 's/^/\[\"/' | sed 's/$/\"\]/' > roles/common/templates/brew_cask.txt
fi

