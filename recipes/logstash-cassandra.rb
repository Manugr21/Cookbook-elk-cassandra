private_ip = node["opsworks"]["layers"]["elasticsearch-kibana"]["instances"]["elasticsearch-kibana1"]["private_ip"]

package 'jdk-8u144-linux-x64.rpm' do
  source "/tmp/jdk-8u144-linux-x64.rpm"
  action :nothing
end

remote_file "/tmp/jdk-8u144-linux-x64.rpm" do
  source 'https://s3.us-east-2.amazonaws.com/itzdata-manu/jdk-8u144-linux-x64.rpm'
  action :create
  notifies :install, "package[jdk-8u144-linux-x64.rpm]", :immediately
end

execute 'add rpm key' do
  command 'rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch'
  action :run
end

template '/etc/yum.repos.d/logstash.repo' do
  source 'repo-logstash.repo'
  owner 'root'
  group 'root'
  mode '0755'
end

yum_package 'logstash' do
  action :install
end

template '/etc/logstash/conf.d/01_config.conf' do
  source 'logstash/01_config.conf'
  variables( :private_ip => private_ip )
  owner 'root'
  group 'root'
  mode '0755'
end

template '/etc/logstash/jvm.options' do
  source 'logstash/jvm.options'
  owner 'root'
  group 'root'
  mode '0755'
end

#service 'logstash' do
#  action :enable
#end

template '/etc/yum.repos.d/datastax.repo' do
  source 'repo-cassandra.repo'
  owner 'root'
  group 'root'
  mode '0755'
end

yum_package 'dsc20' do
  action :install
end

execute 'cassandra-start' do
  command 'cassandra'
end

service 'logstash' do
  action [:enable, :start]
  provider Chef::Provider::Service::Upstart
end
