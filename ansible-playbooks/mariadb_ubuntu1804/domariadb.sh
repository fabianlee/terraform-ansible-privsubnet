ansible-playbook playbook.yml -i ../../privsubnet/ansible_inventory -l dbpriv -e '{ "mysql_bind_address":"0.0.0.0","mysql_allow_remote_cidr": ["172.18.%"] }'
