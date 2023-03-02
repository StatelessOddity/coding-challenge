Host 10.0.*
  ProxyCommand           ssh -A -W %h:%p ec2-user@${bastion}

Host *
  ControlMaster          auto
  ControlPath            /home/runner/.sshmux-%r@%h:%p
  ControlPersist         15m
  IdentityFile             /home/runner/.ssh/id_rsa