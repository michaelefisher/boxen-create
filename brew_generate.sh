#!/usr/bin/env bash

which -s brew
if [[ $? == 0 ]]; then
  brew list --formula -1 | sed -e :a -e '$!N; s/\n/\", \"/; ta' | sed 's/^/\[\"/' | sed 's/$/\"\]/' > roles/common/templates/brew_formulas.txt
fi

which -s brew
if [[ $? == 0 ]]; then
  brew list --cask -1 | sed -e :a -e '$!N; s/\n/\", \"/; ta' | sed 's/^/\[\"/' | sed 's/$/\"\]/' > roles/common/templates/brew_cask.txt
fi
