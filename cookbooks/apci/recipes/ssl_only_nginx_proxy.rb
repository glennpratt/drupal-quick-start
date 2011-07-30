#
# Cookbook Name:: drupal
# Recipe:: app_mod_php_apache2
#
# Glenn Pratt
#
# Based off application::mod_php_apache2
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

directory '/usr/local/ssl' do
  owner 'root'
  group 'root'
  mode 0644
end 

directory '/usr/local/ssl/certificates' do
  owner 'root'
  group 'root'
  mode 0644
end 

cookbook_file '/usr/local/ssl/certificates/wildcard.qs.local.pem' do
  owner 'root'
  group 'root'
  mode 0600
end

cookbook_file '/usr/local/ssl/certificates/wildcard.qs.local.key' do
  owner 'root'
  group 'root'
  mode 0600
end

nginx_app 'proxy' do
  docroot path
  template 'ssl_only_nginx_proxy.conf.erb'
  log_dir node['nginx']['log_dir']
end

service "nginx" do action :restart; end

nginx_site "default" do
  enable false
end