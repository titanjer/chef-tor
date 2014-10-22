#
# Cookbook Name:: tor
# Recipe:: default
#
# Copyright 2012, Cramer Development, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package 'privoxy'

package value_for_platform(
  ['centos', 'redhat'] => { 'default' => 'tor-core' },
  ['debian', 'ubuntu'] => { 'default' => 'tor' }
)

# Create group privoxy if it doesn't exist
group "privoxy" do
  action :create
end

template '/etc/privoxy/config' do
  source 'privoxy_config.erb'
  owner 'privoxy'
  group 'privoxy'
  mode '0600'
  variables node[:privoxy].merge(:forward_socks5 => node[:tor][:listen])
  notifies :restart, 'service[privoxy]'
end

template "/etc/tor/torrc" do
  source "torrc.erb"
  mode '0600'
  variables node[:tor]
  notifies :restart, "service[tor]"
end

service 'privoxy' do
  supports [:restart, :reload, :status]
  action [:enable, :start]
end

service 'tor' do
  supports [:restart, :reload, :status]
  action [:enable, :start]
end
