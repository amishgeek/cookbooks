#Provider

action :create do
  
  if new_resource.aliases == ["default"]
    new_resourece.aliases = [ "#{new_resource.name}", "*.#{new_resource.name}"]
  end
  
  if new_resource.docroot == "default"
    new_resource.docroot = "#{node[:nginx][:web_root]}/#{new_resource.name}"
  end
    
  template "#{node[:nginx][:dir]}/sites-available/#{new_resource.name}.conf" do
    source new_resource.conf_template
    owner "root"
    group "root"
    mode 0644
    cookbook new_resource.cookbook
    variables(
      :site_name => new_resource.name,
      :site_aliases => new_resource.aliases,
      :site_docroot => new_resource.docroot,
      :site_extras => new_resource.conf_extras
    )
    if ::File.exists?("#{node[:nginx][:dir]}/sites-enabled/#{new_resource.name}.conf")
      notifies :restart, resources(:service => "nginx"), :delayed
    end
  end
  
  directory "#{new_resource.docroot}" do
    owner new_resource.user
    group new_resource.group
    mode 0775
    action :create
  end

end

action :enable do

  execute "nxensite #{new_resource.name}" do
    command "/usr/sbin/nxensite #{new_resource.name}.conf"
    notifies :restart, resources(:service => "nginx")
    not_if do 
      ::File.symlink?("#{node[:nginx][:dir]}/sites-enabled/#{new_resource.name}.conf") or
        ::File.symlink?("#{node[:nginx][:dir]}/sites-enabled/000-#{new_resource.name}.conf")
    end
    only_if do ::File.exists?("#{node[:nginx][:dir]}/sites-available/#{new_resource.name}.conf") end
  end

end

action :disable do

  execute "nxdissite #{new_resource.name}" do
    command "/usr/sbin/nxdissite #{new_resource.name}"
    notifies :restart, resources(:service => "nginx")
    only_if do ::File.symlink?("#{node[:nginx][:dir]}/sites-enabled/#{new_resource.name}") end
  end

end

action :delete do
  # Delete Stuff Here
end
