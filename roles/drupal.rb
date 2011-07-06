name "drupal"
description "Drupal front end application server."
run_list(
  "recipe[mysql::client]",
  "recipe[nfs]",
  "recipe[drush]",
  "recipe[drush::make]",
  "recipe[drupal::minimal]",
  "recipe[application]",
  "recipe[drupal::status]"
)
