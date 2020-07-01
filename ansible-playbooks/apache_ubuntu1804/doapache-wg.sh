ansible-playbook playbook.yml -i ../../privsubnet/ansible_inventory -l wg -e "http_host=wg custom_message='hello world from public IP 18.222.168.105 and private IP 172.18.2.100'"
