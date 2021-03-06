#
# Cookbook:: consul_cookbook
# Recipe:: search 
#
# Copyright:: 2018, The Authors, All Rights Reserved.

# Use ClusterSearch
::Chef::Recipe.send(:include, ClusterSearch)

# Looking for consul nodes
consul_cluster = cluster_search(node[cookbook_name])
return if consul_cluster.nil?

node.run_state[cookbook_name] = {}
node.run_state[cookbook_name]['hosts'] = consul_cluster['hosts']

