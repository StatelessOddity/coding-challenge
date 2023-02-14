[fullnode]
%{ for ip in fullnode_ips ~}
${ip}
%{ endfor ~}

[data_aggregator]
%{ for ip in data_aggregator_ips ~}
${ip}
%{ endfor ~}

[gateway_api]
%{ for ip in gateway_api_ips ~}
${ip}
%{ endfor ~}