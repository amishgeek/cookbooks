#
# Cookbook Name:: nginx
# Definition:: nginx_site
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

define :nginx_site_def, :enable => true do
  #include_recipe "nginx-php"
  
  if params[:enable]
    execute "nxensite #{params[:name]}" do
      command "/usr/sbin/nxensite #{params[:name]}"
      notifies :restart, resources(:service => "nginx")
      not_if do 
        ::File.symlink?("#{node[:nginx][:dir]}/sites-enabled/#{params[:name]}") or
          ::File.symlink?("#{node[:nginx][:dir]}/sites-enabled/000-#{params[:name]}")
      end
      only_if do ::File.exists?("#{node[:nginx][:dir]}/sites-available/#{params[:name]}") end
    end
  else
    execute "nxdissite #{params[:name]}" do
      command "/usr/sbin/nxdissite #{params[:name]}"
      notifies :restart, resources(:service => "nginx")
      only_if do ::File.symlink?("#{node[:nginx][:dir]}/sites-enabled/#{params[:name]}") end
    end
  end
end
