app_name = node['app_name']
binary_name = node['binary_name']
environment_file = "/etc/default/#{app_name}.conf"
barito_conf = node['barito']
go_script_location ="/opt/barito_flow/#{app_name}.sh"


default_action :deploy

action :deploy do
  template go_script_location do
    source "go_script.sh.erb"
    mode   "0755"
    variables(
        app_name:                app_name,
        binary_name:             binary_name,
        init_command_arguement:  'r',
        environment_file:        environment_file
    )
  end

  template environment_file do
    source 'barito_flow.conf.erb'
    owner app_name
    group app_name
    variables(
        barito_receiver_address:              barito_conf['receiver']['address'],
        barito_receiver_kafka_brokers:        barito_conf['receiver']['kafka_brokers'],
        barito_receiver_max_retry:            barito_conf['receiver']['max_retry'],
        barito_receiver_application_secret:   barito_conf['receiver']['application_secret'],
    )

    notifies :restart, "service[#{app_name}]", :delayed
  end

  service app_name do
    action :restart
    supports :status => true, :start => true, :stop => true, :restart => true
    provider Chef::Provider::Service::Systemd
  end
end