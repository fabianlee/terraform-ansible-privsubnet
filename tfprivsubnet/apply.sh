#!/bin/bash

if [ $# -lt 1 ]; then
  echo "usage: region=us-east1|us-east2|us-west-1|us-west2"
  echo "example: us-east-1"
  exit 1
fi
region="$1"
echo "region: $region"

# pub/private keypair
if [ ! -f $region.pub ]; then
  ssh-keygen -t rsa -b 4096 -f $region -C $region -N "" -q
fi

# variables file
if [ ! -f $region.tfvars ]; then
  echo "ERROR create a $region.tfvars file so your variables are defined"
  exit 1
fi

set -x
#terraform plan  -var-file=$region.tfvars -state=$region.tfstate
#read -p "Apply?" answer
terraform apply -var-file=$region.tfvars -state=$region.tfstate -auto-approve

