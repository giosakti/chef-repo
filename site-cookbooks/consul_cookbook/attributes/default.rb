#
# Cookbook:: consul_cookbook
# Attribute:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
#
#

cookbook_name = 'consul_cookbook'

# User and group of consul process
default[cookbook_name]['user'] = 'consul'
default[cookbook_name]['group'] = 'consul'

