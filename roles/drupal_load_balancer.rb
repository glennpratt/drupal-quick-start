name "drupal_load_balancer"
description "drupal load balancer"
run_list(
  "recipe[haproxy::app_lb]"
)
override_attributes(
  "haproxy" => {
    "app_server_role" => "drupal"
  }
)
