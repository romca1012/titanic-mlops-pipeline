#!/bin/bash

echo "==== Cleaning Terraform state ===="
cd "$(dirname "$0")/../infra"

rm -rf .terraform
rm -f terraform.tfstate
rm -f terraform.tfstate.backup

echo "==== Clean complete ===="
