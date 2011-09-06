#
# Cookbook Name:: nginx-php
# Recipe:: default
#
# Copyright 2011, Aaron Abramson
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


Chef::Log.info "Starting nginx::default"

include_recipe "apt"


apt_repository "nginx" do
  uri "http://ppa.launchpad.net/nginx/stable/ubuntu"
  distribution "lucid"
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "C300EE8C"
  action :add
  notifies :run, "execute[apt-get update]", :immediately
end

package "nginx" do
  case node[:platform]
  when "debian","ubuntu"
    package_name "nginx"
  end
  action :install
end

directory node[:nginx][:log_dir] do
  mode 0755
  owner node[:nginx][:user]
  action :create
end

directory node[:nginx][:web_root] do
  mode 0775
  owner node[:nginx][:user]
  group node[:nginx][:group]
  action :create
end

directory "#{node[:nginx][:dir]}/extras" do
  mode 0775
  owner node[:nginx][:user]
  group node[:nginx][:group]
  action :create
end

directory "#{node[:nginx][:web_root]}/default" do
  mode 0755
  owner node[:nginx][:user]
  group node[:nginx][:group]
  action :create
end

template "#{node[:nginx][:web_root]}/default/index.html" do
  source "index.html.erb"
  mode 0755
  owner node[:nginx][:user]
  group node[:nginx][:group]
end


%w{nxensite nxdissite}.each do |nxscript|
  template "/usr/sbin/#{nxscript}" do
    source "#{nxscript}.erb"
    mode 0755
    owner "root"
    group "root"
  end
end

template "nginx.conf" do
  path "#{node[:nginx][:dir]}/nginx.conf"
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

template "fastcgi_params" do
  path "#{node[:nginx][:dir]}/fastcgi_params"
  source "fastcgi_params.erb"
  owner "root"
  group "root"
  mode 0644
end

template "#{node[:nginx][:dir]}/sites-available/default" do
  source "default-site.erb"
  owner "root"
  group "root"
  mode 0644
end

service "nginx" do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

include_recipe "php-fpm"

