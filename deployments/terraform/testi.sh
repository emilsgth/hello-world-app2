#!/bin/bash -e 

DATAFILE="$PWD/$1"
#
# FuchiCorp common script to set up Google terraform environment variables
# these all variables should be created on your config file before you run script.
# <ENVIRONMENT> <BUCKET> <DEPLOYMENT> <PROJECT> <CREDENTIALS>


PROJECT=$(sed -nr 's/^google_project_id\s*=\s*"([^"]*)".*$/\1/p'            "$DATAFILE")
BUCKET=$(sed -nr 's/^google_bucket_name\s*=\s*"([^"]*)".*$/\1/p'            "$DATAFILE")
ENVIRONMENT=$(sed -nr 's/^deployment_environment\s*=\s*"([^"]*)".*$/\1/p'   "$DATAFILE")
DEPLOYMENT=$(sed -nr 's/^deployment_name\s*=\s*"([^"]*)".*$/\1/p'           "$DATAFILE")
CREDENTIALS=$(sed -nr 's/^credentials\s*=\s*"([^"]*)".*$/\1/p'              "$DATAFILE")

if [ ! -f "$DATAFILE" ]; then
  echo "setenv: Configuration file not found: $DATAFILE"
  return 1
fi

if [ -z "$PROJECT" ]
then
    echo "Inside <$DATAFILE> the <google_project_id> not found trying to find from <hello.tfvars>"
    PROJECT=$(sed -nr 's/^google_project_id\s*=\s*"([^"]*)".*$/\1/p'  "$PWD/hello.tfvars")
    echo "Using FuchiCorp Google Project ID for deployment. <google_project_id> : <$PROJECT>"
fi

if [ -z "$BUCKET" ]
then
  echo "Inside <$DATAFILE> the <google_bucket_name> not found trying to find from <hello.tfvars>"
  BUCKET=$(sed -nr 's/^google_bucket_name\s*=\s*"([^"]*)".*$/\1/p'   "$PWD/hello.tfvars")
  echo "Using FuchiCorp Google Bucket name for deployment. <google_bucket_name>: <$BUCKET>"
fi

if [ -z "$ENVIRONMENT" ]
then
    echo "setenv: 'deployment_environment' variable not set in configuration file."
    return 1
fi

if [ -z "$BUCKET" ]
then
  echo "setenv: 'google_bucket_name' variable not set in configuration file."
  return 1
fi

if [ -z "$PROJECT" ]
then
    echo "setenv: 'google_project_id' variable not set in configuration file."
    return 1
fi

if [ -z "$CREDENTIALS" ]
then
    echo "setenv: 'credentials' file not set in configuration file."
    return 1
fi

if [ -z "$DEPLOYMENT" ]
then
    echo "setenv: 'deployment_name' variable not set in configuration file."
    return 1
fi

cat << EOF > "$PWD/backend.tf"
terraform {
  backend "gcs" {
    bucket  = "${BUCKET}"
    prefix  = "${ENVIRONMENT}/${DEPLOYMENT}"
    project = "${PROJECT}"
  }
}
EOF
cat "$PWD/backend.tf"

GOOGLE_APPLICATION_CREDENTIALS="${PWD}/${CREDENTIALS}"
export GOOGLE_APPLICATION_CREDENTIALS
export DATAFILE
/bin/rm -rf "$PWD/.terraform" 2>/dev/null
#/bin/rm -rf "$PWD/hello.tfvars" 2>/dev/null
echo "setenv: Initializing terraform"
terraform init #> /dev/null