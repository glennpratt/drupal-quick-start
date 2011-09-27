name "drupal_database_master"
description "Database master for the Drupal application."
run_list(
  "recipe[database::master]"
)
default_attributes(
  :mysql => {
    :tunable => {
      :innodb_flush_log_at_trx_commit => "2",
    }
  }
)