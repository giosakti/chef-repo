# # encoding: utf-8

# Inspec test for recipe consul_cookbook::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

unless os.windows?
  describe group('consul') do
    it { should exist }
  end

  describe user('consul')  do
    it { should exist }
  end
end

describe package('unzip rsync') do
  it { should be_installed }
end

describe directory('/opt') do
  its('mode') { should cmp '0755' }
end

describe directory('/opt/bin') do
  its('mode') { should cmp '0755' }
end

describe file('/opt/bin/consul') do
  its('mode') { should cmp '0755' }
end

describe directory('/var/opt/consul') do
  its('mode') { should cmp '0755' }
end

describe directory('/opt/consul/etc') do
  its('mode') { should cmp '0755' }
end

describe file('/opt/consul/etc/consul.json') do
  its('mode') { should cmp '0640' }
end

describe systemd_service('consul') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

