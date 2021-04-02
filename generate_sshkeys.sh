#!/bin/bash

sshprivate="./ansible/inventory/ssh_keys/id_rsa"
sshpublic="./ansible/inventory/ssh_keys/id_rsa.pub"

if [ -f $sshprivate -a -f $sshpublic ]; then
    echo "SSH keys already generated"
else
  ssh-keygen -b 2048 -t rsa -f ./ansible/inventory/ssh_keys/id_rsa -q -N ""
fi

