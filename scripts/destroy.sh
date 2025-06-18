#!/bin/bash

echo "==== Destroying infrastructure ===="
cd "$(dirname "$0")/../infra"

terraform destroy -auto-approve

echo "==== Destroy complete ===="
