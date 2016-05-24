#
# Cookbook Name:: opsinterview
# Recipe:: default
#
# Copyright (C) 2016 Rally Health, Inc.
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'apt'

package ['nginx', 'ruby', 'htop'] do
  action :upgrade
end

service 'nginx' do
  action :stop
end

cookbook_file '/etc/nginx/sites-available/default' do
  source 'default'
  owner 'root'
  group 'root'
  mode '0644'
end

cookbook_file '/usr/share/nginx/html/index.html' do
  source 'index.html'
  owner 'root'
  group 'root'
  mode '0644'
end

cookbook_file '/usr/share/nginx/html/rally.png' do
  source 'rally.png'
  owner 'root'
  group 'root'
  mode '0644'
end

cookbook_file '/usr/share/nginx/html/rally.css' do
  source 'rally.css'
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
  supports :manage_home => true
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
  not_if { File.exists?('/swapfile') }
  code <<-eof
    dd if=/dev/zero of=/swapfile bs=1M count=4096 &&
    chmod 600 /swapfile &&
    mkswap /swapfile
  eof
end

mount '/dev/null' do  # swap file entry for fstab
  action :enable  # cannot mount; only add to fstab
  device '/swapfile'
  fstype 'swap'
end

script 'activate swap' do
  interpreter 'bash'
  code 'swapon -a'
end

directory '/var/log/rally-health' do
  owner 'root'
  group 'root'
  mode 0755
  action :create
end

script 'create logfiles' do
  interpreter 'bash'
  code <<-eof
    dd if=/dev/zero of=/var/log/rally-health/2016-01-01.log bs=1M count=1000 &&
    dd if=/dev/zero of=/var/log/rally-health/2016-01-02.log bs=1M count=1000
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
      echo "4.15.73.226 - - [01/Jan/2016:18:54:01 +0000] \"GET / HTTP/1.1\" $(( ( RANDOM % 5 )  + 1 ))00 $RANDOM \"-\" \"MyUserAgent/537.36\"";
    done > /home/ubuntu/access.log
  eof
end
