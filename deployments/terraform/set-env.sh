#!/usr/bin/env bash
if [ -z "$GIT_TOKEN" ]
then
  echo """
  Script needs github token to get private repos.
  Github <GIT_TOKEN> not found."""
  return 1 
fi
wget --quiet "--header=Authorization: token $GIT_TOKEN" "https://raw.githubusercontent.com/fuchicorp/common_scripts/master/set-environments/terraform/google-set-env.sh" \
  -O set-env >/dev/null
source 'set-env' "$@"
rm -rf "set-env"