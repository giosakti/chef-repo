#
# Cookbook:: consul_cookbook
# Attribute:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
#
#

cookbook_name = 'consul_cookbook'

# Cluster configuration with cluster-search
# The nodes found will be the servers
# It is used to populate the server and retry_join options in the config file
# Role used by the search to find other nodes of the cluster
default[cookbook_name]['role'] = cookbook_name
# Hosts of the cluster, deactivate search if not empty
default[cookbook_name]['hosts'] = []
# Expected size of the cluster. Ignored if hosts is not empty
default[cookbook_name]['size'] = 1

# User and group of consul process
default[cookbook_name]['user'] = 'consul'
default[cookbook_name]['group'] = 'consul'

# consul version
default[cookbook_name]['version'] = '1.0.7'
version = node[cookbook_name]['version']
# package sha256 checksum
default[cookbook_name]['checksum'] =
  '6c2c8f6f5f91dcff845f1b2ce8a29bd230c11397c448ce85aae6dacd68aa4c14'

# Where to get the zip file
binary = "consul_#{version}_linux_amd64.zip"
default[cookbook_name]['mirror'] =
  "https://releases.hashicorp.com/consul/#{version}/#{binary}"

# Where to put installation dir
default[cookbook_name]['prefix_root'] = '/opt'
# Where to link installation dir
default[cookbook_name]['prefix_home'] = '/opt'
# Where to link binaries
default[cookbook_name]['prefix_bin'] = '/opt/bin'

# Data directory
default[cookbook_name]['data_dir'] = '/var/opt/consul'

# Configuration directory
default[cookbook_name]['config_dir'] =
  "#{node[cookbook_name]['prefix_home']}/consul/etc"

# Consul configuration files
default[cookbook_name]['main_config'] = 'consul.json'

# Format : name of the file => configuration it contains
default[cookbook_name]['config'] = {
  node[cookbook_name]['main_config'] => { # Main configuration
    'data_dir' => node[cookbook_name]['data_dir'],
    # 'server' => true if included in the search or hosts
    # 'retry_join' => will be filled from search
  }
}

# Consul daemon options, used to create the ExecStart option in service
# You should modify the configuration file instead of the CLI options
default[cookbook_name]['cli_opts'] = {
  'config-dir' => node[cookbook_name]['config_dir']
}

# Systemd service unit, include config
default[cookbook_name]['systemd_unit'] = {
  'Unit' => {
    'Description' => 'consul agent',
    'After' => 'network.target'
  },
  'Service' => {
    'Type' => 'simple',
    'User' => node[cookbook_name]['user'],
    'Group' => node[cookbook_name]['group'],
    'Restart' => 'on-failure',
    'ExecStart' => 'TO_BE_COMPLETED'
  },
  'Install' => {
    'WantedBy' => 'multi-user.target'
  }
}

# Configure retries for the package resources, default = global default (0)
# (mostly used for test purpose)
default[cookbook_name]['package_retries'] = nil

