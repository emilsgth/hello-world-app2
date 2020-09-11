#!/usr/bin/env bash
# condition in [] will check variable GIT_TOKEN is empty or no, if "empty" return 1 
if [ -z "$GIT_TOKEN" ]
then
  echo """
  Script needs github token to get private repos.
  Github <GIT_TOKEN> not found.
    run command  < export GIT_TOKEN='your_token'>
   """
  #return 1
# if we have variable GIT_TOKEN, condition in [] will check is it valid token or no.
elif  [ "$(curl -s -H "Authorization: token $GIT_TOKEN" 'https://api.github.com' -I | awk '{print $2}' | head -1)" != "200"  ]
then 
   echo "GIT_TOKEN is not valid"
elif  [ "$(curl -s -H "Authorization: token $GIT_TOKEN" 'https://api.github.com' -I | awk '{print $2}' | head -1)" == "200"  ]
then
    wget --quiet "--header=Authorization: token $GIT_TOKEN" "https://raw.githubusercontent.com/fuchicorp/common_scripts/master/set-environments/terraform/google-set-env.sh" \
  -O set-env >/dev/null
source 'set-env' "$@"
rm -rf "set-env"
fi