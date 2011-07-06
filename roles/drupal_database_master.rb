name "drupal_database_master"
description "Database master for the Drupal application."
run_list(
  "recipe[database::master]"
)