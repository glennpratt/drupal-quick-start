package 'python-software-properties'

execute 'nginx-stable-ppa' do
  command 'add-apt-repository ppa:nginx/php5'
end

execute 'apt-get update' do
  command 'apt-get update'
end

pkgs = value_for_platform(
  [ "centos", "redhat", "fedora" ] => {
    "default" => %w{ php53 php53-devel php53-cli php-pear php5-fpm}
  },
  [ "debian", "ubuntu" ] => {
    "default" => %w{ php5-fpm php5 php5-dev php5-cli php-pear}
  },
  "default" => %w{ php5-fpm php5 php5-dev php5-cli php-pear}
)

pkgs.each do |pkg|
  package pkg do
    action :upgrade
  end
end
