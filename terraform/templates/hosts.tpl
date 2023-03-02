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

[bastion:vars]
ansible_ssh_user=ec2-user

[stack:vars]
ansible_ssh_user=ubuntu
ansible_ssh_private_key_file=/home/runner/.ssh/id_rsa
ansible_ssh_common_args= -o ProxyCommand="ssh -q ec2-user@{bastion} -i /home/runner/.ssh/id_rsa -W %h:%p"