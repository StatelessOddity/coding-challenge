[bastion]
${bastion}

[stack]
${fullnodes}
${data_aggregators}
${gateway_api}

[fullnodes]
${fullnodes}

[data_aggregators]
${data_aggregators}

[gateway_apis]
${gateway_api}

[stack:vars]
ansible_port = 22
ansible_user = ubuntu
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o ProxyCommand="ssh -o \'ForwardAgent yes\' ec2-user@${bastion_ip} -p 22 \'ssh-add /home/ec2-user/.ssh/id_rsa && nc %h %p\'"'

[bastion:vars]
ansible_port = 22
ansible_user = ec2-linux