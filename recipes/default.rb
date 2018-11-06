#
# Cookbook Name:: sand
# Recipe:: default
#
# Copyright 2018, Soulou
#
# License MIT
#

require 'resolv'

dirname = "sand-#{node['sand']['version']}-linux-#{node['sand']['arch']}"
download_url = "#{node['sand']['download_url']}/#{node['sand']['version']}"
dir_dest_path = "#{Chef::Config[:file_cache_path]}/#{dirname}"

{
  'sand-agent_linux_amd64' => 'sand-agent',
  'sand-agent-cli_linux_amd64' => 'sand-cli',
}.each do |bin_name, dest_bin_name|
  remote_file dir_dest_path do
    source "#{download_url}/#{bin_name}"
  end

  bash "Install #{bin_name} #{node['sand']['version'] }" do
    code <<-EOH
      cp #{dir_dest_path}/#{bin_name} #{node['sand']['install_path']}/#{dest_bin_name}
    EOH
    subscribes :run, "remote_file[#{dir_dest_path}]"
    action :nothing
  end
end

binary_path = ::File.join(node['sand']['install_path'], 'sand-agent')

env = node['sand']['env'].select do |k, v|
  !v.nil? && v && v != ""
end.map do |k, v|
  "#{k.upcase}=#{v}"
end

manager = Chef::Provider::Service::Upstart
if node['init_package'] == 'systemd'
  manager = Chef::Provider::Service::Systemd

  systemd_unit 'sand-agent.service' do
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
  subscribes :restart, "remote_file[#{dir_dest_path}]"
  action [:enable, :start]
end

