#!/usr/bin/env bash

DATAFILE="$PWD/$1"

BUCKET=$(sed -nr 's/^google_bucket_name\s*=\s*"([^"]*)".*$/\1/p'             "$DATAFILE")
PROJECT=$(sed -nr 's/^google_project_id\s*=\s*"([^"]*)".*$/\1/p'             "$DATAFILE")
ENVIRONMENT=$(sed -nr 's/^deployment_environment\s*=\s*"([^"]*)".*$/\1/p'    "$DATAFILE")
DEPLOYMENT=$(sed -nr 's/^deployment_name\s*=\s*"([^"]*)".*$/\1/p'            "$DATAFILE")
CREDENTIALS=$(sed -nr 's/^credentials\s*=\s*"([^"]*)".*$/\1/p'               "$DATAFILE") 


if [ ! -f "$DATAFILE" ]; then
    echo "setenv: Configuration file not found: $DATAFILE"
    return 1
fi

if [ -z "$ENVIRONMENT" ]
then
    echo "setenv: 'environment' variable not set in configuration file."
    return 1
fi

if [ -z "$BUCKET" ]
then
  echo "Inside <$DATAFILE> the <google_bucket_name> not found trying to find from <deployment_configuration.tfvars>"
  BUCKET=$(sed -nr 's/^google_bucket_name\s*=\s*"([^"]*)".*$/\1/p'   "$PWD/deployment_configuration.tfvars")
  echo "Using FuchiCorp Google Bucket name for deployment. <google_bucket_name>: <$BUCKET>"
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

if [ -z "$PROJECT" ]
then
  echo "Inside <$DATAFILE> the <google_project_id> not found trying to find from <deployment_configuration.tfvars>"
  BUCKET=$(sed -nr 's/^google_project_id\s*=\s*"([^"]*)".*$/\1/p'   "$PWD/deployment_configuration.tfvars")
  echo "Using Project name for deployment. <google_project_id>: <$PROJECT>"
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

GOOGLE_APPLICATION_CREDENTIALS="${DIR}/${CREDENTIALS}"
export GOOGLE_APPLICATION_CREDENTIALS
export DATAFILE
/bin/rm -rf "$$PWD/.terraform" 2>/dev/null
##/bin/rm -rf "$PWD/hello-world.tfvars" 2>/dev/null
echo "setenv: Initializing terraform"
terraform init #> /dev/null