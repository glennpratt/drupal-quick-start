name "varnish_load_balancer"
description "Varnish load balancer"
run_list(
  "recipe[varnish::app_lb]"
)
default_attributes(
  :varnish => {
    :listen_port => "80",
    :backend_address => "127.0.0.1",
    :backend_port => "8080",
    :app_server_role => "drupal"
  }
)
