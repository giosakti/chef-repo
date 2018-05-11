#
# Cookbook:: consul_cookbook
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

include_recipe "#{cookbook_name}::search"
include_recipe "#{cookbook_name}::user"
include_recipe "#{cookbook_name}::install"
include_recipe "#{cookbook_name}::config"

