echo "all wireguard servers"
ansible wireguard -m ping
ansible webpub -m ping
ansible webpriv -m ping
ansible dbpriv -m ping
