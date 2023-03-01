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
ansible_ssh_common_args: '-o ProxyCommand="ssh -i /home/runner/.ssh/id_rsa -W %h:%p -q ec2-user@{bastion}"'

[bastion:vars]
ansible_user = ec2-user
ansible_port = 22