
function findKey() {
  key="$1"
  file="$2"
  sed '/^\#/d' $file | sed '/^$/d' | grep $key | sed -e 's/ //g' | while read line; do
    thekey=$(echo $line | cut -d "=" -f 1)
    theval=$(echo $line | cut -d "=" -f 2)
    eval ${thekey}=\${theval}
    echo $theval
  done
}

function loadAllProperties() {
  file="$1"
  sed '/^\#/d' $file | sed '/^$/d' | sed -e 's/ //g' | while read line; do
    thekey=$(echo $line | cut -d "=" -f 1)
    theval=$(echo $line | cut -d "=" -f 2)
    # using eval on user input is not safe
    # could be used to execute malicious script
    eval ${thekey}=\${theval}
    echo "available variable $thekey=$theval"
  done
}

loadAllProperties "allvals.properties"

# run base playbooks
cd ansible-playbooks/setup_ubuntu1804
./dosetup.sh
cd ../..

cd ansible-playbooks/apache_ubuntu1804
ansible-playbook playbook.yml -i ../../privsubnet/ansible_inventory -l wg -e "http_host=wg custom_message='hello world from public IP ${wg_public} and private IP ${wg_private}'"

ansible-playbook playbook.yml -i ../../privsubnet/ansible_inventory -l wg -e "http_host=webpub custom_message='hello world from public IP ${webpub_public} and private IP ${webpub_private}'"

ansible-playbook playbook.yml -i ../../privsubnet/ansible_inventory -l wg -e "http_host=webpub custom_message='hello world from public IP ${webpub_public} and private IP ${webpub_private}'"

