#!/bin/bash
if [ $# -lt 1 ]; then
  echo "usage: region=us-east1|us-east2|us-west-1|us-west2"
  echo "example: us-east-1"
  exit 1
fi
region="$1"
echo "region: $region"

set -x
terraform destroy -var-file=$region.tfvars -state=$region.tfstate -auto-approve

