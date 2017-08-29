lista = ""
temp = ""

node["opsworks"]["layers"]["cassandra-logstash"]["instances"].each do |instance, value|
  lista = temp + value["private_ip"]
  temp += value["private_ip"] + ','
end

template '/etc/cassandra/conf/cassandra.yaml' do
  source 'cassandra.yaml'
  variables({
    :lista => lista,
    :private_ip => node["opsworks"]["instance"]["private_ip"],
     })
  owner 'root'
  group 'root'
  mode '0755'
end

execute 'cassandra-start' do
  command 'cassandra'
end
