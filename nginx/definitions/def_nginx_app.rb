#
# Cookbook Name:: nginx-php
# Definition:: nginx_app
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


define :nginx_app_def, :template => "nginx_app.conf.erb" do
  
  application_name = params[:name]

  
  template "#{node[:nginx][:dir]}/sites-available/#{application_name}.conf" do
    source params[:template]
    owner "root"
    group "root"
    mode 0644
    if params[:cookbook]
      cookbook params[:cookbook]
    end
    variables(
      :application_name => application_name,
      :params => params
    )
    if ::File.exists?("#{node[:nginx][:dir]}/sites-enabled/#{application_name}.conf")
      notifies :restart, resources(:service => "nginx"), :delayed
    end
  end
  
  directory "#{params[:docroot]}" do
    owner params[:owner]
    group "#{node[:nginx][:group]}"
    mode 0775
    action :create
  end
  
  nginx_site_def "#{params[:name]}.conf" do
    enable enable_setting
  end
end