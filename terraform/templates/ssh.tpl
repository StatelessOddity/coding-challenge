Host ${stack_network_prefix}.*
  ProxyCommand           ssh -A -W %h:%p ec2-user@${bastion}

Host *
  ControlMaster          auto
  ControlPath            ~/.ssh/mux-%r@%h:%p
  ControlPersist         15m
  IdentityFile             ~/.ssh/id_rsa