name "user"
description "User stuff."
run_list(
  "recipe[zsh]",
  "recipe[users::sysadmins]",
  "recipe[sudo]"
)
override_attributes(
  :authorization => {
    :sudo => {
      :users => ["ubuntu"],
      :passwordless => true
    }
  }
)
