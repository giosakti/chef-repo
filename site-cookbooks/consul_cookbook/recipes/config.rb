#
# Cookbook:: consul_cookbook
# Recipe:: config 
#
# Copyright:: 2018, The Authors, All Rights Reserved.

# Create consul data && config directories
%w[data_dir config_dir].each do |dir|
  directory node[cookbook_name][dir] do
    user node[cookbook_name]['user']
    group node[cookbook_name]['group']
    mode '0755'
    recursive true
  end
end

# Get servers list (from search), used in main config
servers = node.run_state.dig(cookbook_name, 'hosts')
return if servers.nil? # No one, we wait

# Deploy consul configuration (services, health checks)
node[cookbook_name]['config'].each do |filename, config|
  if filename == node[cookbook_name]['main_config']
    config = config.to_hash
    if servers.include?(node['fqdn'])
      config['server'] = true
      config['bootstrap_expect'] = servers.size
    end
    config['retry_join'] = servers
  end

  file "#{node[cookbook_name]['config_dir']}/#{filename}" do
    content Chef::JSONCompat.to_json_pretty(config)
    owner node[cookbook_name]['user']
    group node[cookbook_name]['group']
    mode '0640'
  end
end

