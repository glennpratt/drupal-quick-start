#TODO - Stop all www-data services.
#TODO - Only restart if needed.
#TODO - php5-fpm didn't respond to service command.
execute "service php5-fpm stop" do
  command "service php5-fpm stop"
end

service "nginx" do
  action :stop
end


#TODO - Lookup user from /srv permissions.
execute "usermod" do
  command "usermod -u 502 www-data"
  action :run
end

#TODO - Lookup group from /srv permissions.
execute "adduser" do
  command "adduser www-data dialout"
  action :run
end

execute "service php5-fpm start" do
  command "service php5-fpm start"
end

service "nginx" do
  action :start
end
