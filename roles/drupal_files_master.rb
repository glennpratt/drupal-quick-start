name "drupal_files_master"
description "Database master for the Drupal application."
run_list(
  "recipe[nfs::server]"
)