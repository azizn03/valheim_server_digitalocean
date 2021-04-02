#!/bin/bash

hostfile=/terraform/ansible/inventory/hosts

cd /terraform/terraform && ./terraform plan -out=infra.out

cd /terraform/terraform && ./terraform apply "infra.out" <<< "yes"

ip=$(cd /terraform/terraform && ./terraform output -json ip | jq -r)

sed  "/\[centosbox\]/!b;n;c$ip" "$hostfile" > hostfile

mv hostfile $hostfile

