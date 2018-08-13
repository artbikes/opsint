#
# Cookbook Name:: opsinterview
# Recipe:: default
#

include_recipe 'apt'

package %w(nginx ruby htop) do
  action :upgrade
end

service 'nginx' do
  action :stop
end

file '/etc/nginx/sites-available/default' do
  action :delete
  only_if {File.exist? '/etc/nginx/sites-available/default'}
end

link '/etc/nginx/sites-enabled/default' do
  action :delete
end

cookbook_file '/etc/nginx/sites-available/web-app.conf' do
  source 'web-app.conf'
  owner 'root'
  group 'root'
  mode '0644'
end

link '/etc/nginx/sites-enabled/web-app.conf' do
  to '/etc/nginx/sites-available/web-app.conf'
end

cookbook_file '/usr/share/nginx/html/index.html' do
  source 'index.html'
  owner 'root'
  group 'root'
  mode '0644'
end

cookbook_file '/usr/share/nginx/html/success.png' do
  source 'success.png'
  owner 'root'
  group 'root'
  mode '0644'
end

cookbook_file '/usr/share/nginx/html/success.css' do
  source 'success.css'
  owner 'root'
  group 'root'
  mode '0644'
end

cookbook_file '/etc/ssh/sshd_config' do
  source 'sshd_config'
  owner 'root'
  group 'root'
  mode '0644'
end

service 'ssh' do
  action :restart
end

user 'ubuntu' do
  home '/home/ubuntu'
  manage_home true
  action :create
  password '$1$meyYeU7E$/m4EGobQQ59RM5BEYEkN30'
end

directory '/home/ubuntu' do
  owner 'ubuntu'
  group 'ubuntu'
  mode '0755'
  action :create
end

cookbook_file '/home/ubuntu/is_load_high.py' do
  source 'is_load_high.py'
  owner 'ubuntu'
  group 'ubuntu'
  mode '0644'
  action :create
end

cookbook_file '/home/ubuntu/is_load_high.rb' do
  source 'is_load_high.rb'
  owner 'ubuntu'
  group 'ubuntu'
  mode '0644'
  action :create
end

script 'create swapfile' do
  interpreter 'bash'
  not_if { ::File.exist?('/swapfile') }
  code <<-eof
    fallocate -l 4G /swapfile &&
    chmod 600 /swapfile &&
    mkswap /swapfile
  eof
end

mount '/dev/null' do  # swap file entry for fstab
  action :enable      # cannot mount; only add to fstab
  device '/swapfile'
  fstype 'swap'
end

script 'activate swap' do
  interpreter 'bash'
  code 'swapon -a'
end

directory '/var/log/api' do
  owner 'root'
  group 'root'
  mode 0755
  action :create
end

today = "/var/log/api/api-#{Time.at(Time.now.to_i).strftime("%Y-%m-%d")}.log"
yesterday = "/var/log/api/api-#{Time.at(Time.now.to_i - 86400).strftime("%Y-%m-%d")}.log"
script 'create logfiles' do
  interpreter 'bash'
  not_if { File.exist?(yesterday) }
  code <<-eof
    dd if=/dev/zero of=#{today} bs=1M count=1000 &&
    dd if=/dev/zero of=#{yesterday} bs=1M count=1000
  eof
end

cookbook_file "/usr/local/bin/api" do
  source "api"
  owner "root"
  group "root"
  mode  0700
end

cookbook_file "/etc/init/api.conf" do
  source "api.conf"
  owner "root"
  group "root"
  mode 0644
end

service "api" do
  provider Chef::Provider::Service::Upstart
  enabled true
  running true
  supports :restart => true, :reload => true, :status => true
  action [:enable, :start]
end

script 'api requests' do
  interpreter 'bash'
  code <<-eof
    for i in `seq 1 1000`
    do 
        wget -q http://localhost:8000/
    done
  eof
end

script 'immutable logfile' do
  interpreter 'bash'
  code <<-eof
    chattr +i /var/log/api/api-$(date --date="1 days ago" +%F).log
  eof
end

file '/home/ubuntu/access.log' do
  owner 'ubuntu'
  group 'ubuntu'
  mode 0644
end

script 'create access logs' do
  interpreter 'bash'
  code <<-eof
    for ((n=0;n<1000;n++));
    do num=$RANDOM;
      echo  -n '4.15.73.226 - - [01/Jan/2016:18:54:01 +0000] "GET / HTTP/1.1"'
      echo -n " $(( ( num % 5 )  + 1 ))00 $num"
      echo ' "-" "MyUserAgent/537.36"'
    done > /home/ubuntu/access.log
  eof
end

script 'Inject answers into syslog' do
  interpreter 'bash'
  code <<-eof
    cd /home/ubuntu
    sudo logger BINGOMIPS: ` awk '{sum += $10} END {print sum}' access.log`
    sudo logger BONGOMIPS: ` awk '/ 200 /{sum += $10} END {print sum}' access.log`
  eof
end
