name "commerce_kickstart"
description "Drupal commerce build."
run_list(
  "recipe[mysql::client]",
  "recipe[nfs]",
  "recipe[drush]",
  "recipe[drush::make]",
  "recipe[drupal::minimal]",
  "recipe[application]",
  "recipe[drupal::status]"
)
