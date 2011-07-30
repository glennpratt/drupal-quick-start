package 'python-software-properties'

execute 'nginx-stable-ppa' do
  command 'add-apt-repository ppa:nginx/stable'
end

execute 'apt-get update' do
  command 'apt-get update'
end

package 'nginx' do
  action :upgrade
end
