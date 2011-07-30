#
# Cookbook Name:: haproxy
# Recipe:: app_lb
#
# Copyright 2011, Opscode, Inc.
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

include_recipe 'varnish::default'

pool_members = search("node", "role:#{node['varnish']['app_server_role']} AND chef_environment:#{node.chef_environment}") || []

# load balancer is in the pool
if node.run_list.roles.include?(node['varnish']['app_server_role'])
  pool_members << node
end

template "/etc/varnish/default.vcl" do
  source "app_lb.vcl.erb"
  owner "root"
  group "root"
  mode 0644
  variables( :pool_members => pool_members.uniq,
             :backend_port => node["varnish"]["backend_port"],
             :director_type => 'random'
           )
  notifies :restart, "service[varnish]", :immediately
end
