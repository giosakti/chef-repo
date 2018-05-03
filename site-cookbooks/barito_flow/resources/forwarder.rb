app_name = node['app_name']
binary_name = node['binary_name']
environment_file = "/etc/default/#{app_name}.conf"
barito_conf = node['barito']['forwarder']
go_script_location ="/opt/barito_flow/#{app_name}.sh"


default_action :deploy

action :deploy do
  template go_script_location do
    source "go_script.sh.erb"
    mode   "0755"
    variables(
        app_name:                app_name,
        binary_name:             binary_name,
        init_command_arguement:  'f',
        environment_file:        environment_file
    )
  end

  template environment_file do
    source 'barito_flow_forwarder.conf.erb'
    owner app_name
    group app_name
    variables(
        barito_forwarder_kafka_brokers:        barito_conf['kafka_brokers'],
        barito_forwarder_consumer_group_id:    barito_conf['consumer_group_id'],
        barito_forwarder_consumer_topic:       barito_conf['consumer_topic'],
        barito_forwarder_elasticsearch_url:    barito_conf['elasticsearch_url'],
    )

    notifies :restart, "service[#{app_name}]", :delayed
  end

  service app_name do
    action :restart
    supports :status => true, :start => true, :stop => true, :restart => true
    provider Chef::Provider::Service::Systemd
  end
end