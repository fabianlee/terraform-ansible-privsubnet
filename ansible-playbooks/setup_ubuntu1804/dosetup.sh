#!/bin/bash

# pub/private keypair
if [ ! -f sammy.pub ]; then
  ssh-keygen -t rsa -b 4096 -f sammy -C sammy -N "" -q
fi

ansible-playbook playbook.yml -i ../../privsubnet/ansible_inventory -l all
