# Force upgrade the Chef version, most Vagrant boxes are old.
gem_package "chef" do
  action :install
  version "0.10.4.rc.3"
  options(:prerelease => true)
  notifies :run, "ruby_block[chef-upgraded]", :immediately
end

# If Chef needed an upgrade, kill this provision cycle and start over.
ruby_block "chef-upgraded" do
  block do
    raise "Chef upgraded, please restart Chef provisioning."
  end
  action :nothing
end
