app_name = node['app_name']
binary_name = node['binary_name']
go_script_location ="/opt/barito_flow/#{app_name}.sh"

default_action :deploy

action :deploy do
  app_home_dir = "/opt/#{app_name}"

  group app_name

  user app_name do
    shell "/bin/bash"
    group app_name
    home app_home_dir
    manage_home true
  end

  directory "/var/log/#{app_name}" do
    mode '0755'
    owner app_name
    group app_name
    action :create
  end

  remote_file "/opt/barito_flow/#{binary_name}" do
    source "https://github.com/BaritoLog/barito-flow/releases/download/v0.1.1/#{binary_name}"
    mode '0755'
    owner app_name
    group app_name
    action :create
  end

  template "/etc/systemd/system/#{app_name}.service" do
    source 'systemd.erb'
    mode   "0644"
    variables(
        app_name:           app_name,
        environment_file:   "/etc/default/#{app_name}.conf",
        go_script_location: go_script_location
    )
    notifies :run, "execute[systemctl daemon-reload]",:immediately
    # notifies :restart, "service[#{app_name}]", :delayed
  end

  execute "systemctl daemon-reload" do
    action :nothing
  end
end