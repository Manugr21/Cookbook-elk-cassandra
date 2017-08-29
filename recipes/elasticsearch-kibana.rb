private_ip = node["opsworks"]["instance"]["private_ip"]


package 'jdk-8u144-linux-x64.rpm' do
  source "/tmp/jdk-8u144-linux-x64.rpm"
  action :nothing
end

remote_file "/tmp/jdk-8u144-linux-x64.rpm" do
  source 'https://s3.us-east-2.amazonaws.com/itzdata-manu/jdk-8u144-linux-x64.rpm'
  action :create
  notifies :install, "package[jdk-8u144-linux-x64.rpm]", :immediately
end

package 'elasticsearch-5.5.1.rpm' do
  source "/tmp/elasticsearch-5.5.1.rpm"
  action :nothing
end

remote_file '/tmp/elasticsearch-5.5.1.rpm' do
  source 'https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.5.1.rpm'
  action :create
  notifies :install, "package[elasticsearch-5.5.1.rpm]", :immediately
end

template '/etc/elasticsearch/elasticsearch.yml' do
  source 'elasticsearch.yml'
  variables( :private_ip => private_ip )
  owner 'root'
  group 'root'
  mode '0755'
end

template '/etc/elasticsearch/jvm.options' do
  source 'jvm.options'
  owner 'root'
  group 'root'
  mode '0755'
end

service "elasticsearch" do
  action :start
end

package 'kibana-5.5.1-x86_64.rpm' do
  source "/tmp/kibana-5.5.1-x86_64.rpm"
  action :nothing
end

remote_file '/tmp/kibana-5.5.1-x86_64.rpm' do
  source 'https://artifacts.elastic.co/downloads/kibana/kibana-5.5.1-x86_64.rpm'
  action :create
  notifies :install, "package[kibana-5.5.1-x86_64.rpm]", :immediately
end

template '/etc/kibana/kibana.yml' do
  source 'kibana.yml'
  variables( :private_ip => private_ip )
  owner 'root'
  group 'root'
  mode '0755'
end

service "kibana" do
  action :start
end
