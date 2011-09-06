#Resource

actions :create, :enable, :disable, :delete

if node[:nginx] and node[:nginx][:user]
  user = node[:nginx][:user]
else
  user = "www-data"
end

if node[:nginx] and node[:nginx][:group]
  group = node[:nginx][:group]
else
  group = "www-data"
end

attribute :name,          :kind_of => String, :name_attribute => true
attribute :aliases,       :kind_of => Array, :default => []
attribute :docroot,       :kind_of => String
attribute :user,          :kind_of => String, :default => user
attribute :group,         :kind_of => String, :default => group
attribute :cookbook,      :kind_of => String, :default => "nginx"
attribute :conf_template, :kind_of => String, :default => "vhost.conf.erb"
attribute :conf_extras,   :kind_of => Array, :default => []