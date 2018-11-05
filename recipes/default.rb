#
# Cookbook Name:: sand
# Recipe:: default
#
# Copyright 2018, Soulou
#
# License MIT
#

require 'resolv'

dirname = "sand-" +
           node['sand']['version'] + "-linux-" +
           node['sand']['arch']
archive = "#{dirname}.tar.gz"

download_url =
  node['sand']['download_url'] + "/" +
  node['sand']['version'] + "/" + archive

archive_dest_path = "#{Chef::Config[:file_cache_path]}/#{archive}"
dir_dest_path = "#{Chef::Config[:file_cache_path]}/#{dirname}"

remote_file archive_dest_path do
  source download_url
end

bash "extract sand #{node['sand']['version'] }" do
  code <<-EOH
    tar -C #{Chef::Config[:file_cache_path]} -xvf #{archive_dest_path}
    cp #{dir_dest_path}/sand-agent #{node['sand']['install_path']}
    cp #{dir_dest_path}/sand-agent-cli #{node['sand']['install_path']}
  EOH
  subscribes :run, "remote_file[#{archive_dest_path}]"
  action :nothing
end

binary_path = File.join(node['sand']['install_path'], "sand-agent")

env = node['sand']['env'].select{|k, v|
  !v.nil? && v && v != ""
}.map{|k, v|
  "#{k.upcase}=#{v}"
}

manager = Chef::Provider::Service::Upstart
if node['init_package'] == "systemd"
  manager = Chef::Provider::Service::Systemd

  systemd_unit "sand-agent.service" do
    action :create
    systemd_content = {
      "Unit" => {
        "Description" => "sand-agent - SAND Network Daemon",
        "After" => "network.target"
      },
      "Service" => {
        "ExecStart" => "#{binary_path}",
        "Restart" => "always",
        "RestartSec" => "30s",
        "Environment" => env,
      },
    }
    content systemd_content
  end
else
  template "/etc/init/sand-agent.conf" do
    source 'sand-agent.init.conf.erb'
    mode 0660
    variables({
      target: binary_path,
      env: env,
    })
    notifies :stop, "service[sand-agent]", :delayed
    notifies :start, "service[sand-agent]", :delayed
  end
end

service 'sand-agent' do
  provider manager
  subscribes :restart, "remote_file[#{archive_dest_path}]"
  action [:enable, :start]
end

