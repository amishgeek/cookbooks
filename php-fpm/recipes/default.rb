#
# Cookbook Name:: php-fpm
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

#bash "php-fpm" do
#  user "root"
#  code <<-EOH
#  add-apt-repository ppa:brianmercer/php
#  add-apt-repository ppa:nginx/php5
#  apt-get update
#  EOH
#end

apt_repository "php5" do
  uri "http://ppa.launchpad.net/nginx/php5/ubuntu"
  distribution "lucid"
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "C300EE8C"
  action :add
  notifies :run, "execute[apt-get update]", :immediately
end


package "php5-fpm" do
  case node[:platform]
  when "debian","ubuntu"
    package_name "php5-fpm"
  end
  action :install
end

package "php5-mysql"
package "php5-curl"
package "php5-cli"

directory "/usr/lib/php5/extensions" do
  mode 0755
  owner "root"
  group "root"
  action :create
end

template "/etc/php5/fpm/php.ini" do
  source "fpm.php.ini.erb"
  mode 0644
  owner "root"
  group "root"
end

template "#{node[:nginx][:web_root]}/default/phpinfo.php" do
  source "phpinfo.php.erb"
  mode 0755
  owner node[:nginx][:user]
  group node[:nginx][:group]
end

service "php5-fpm" do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end