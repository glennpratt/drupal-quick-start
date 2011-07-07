# Author:: Chris Christensen <chris@allplayers.com>
# Cookbook Name::  drush_make
# Recipe:: default
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

git "/usr/share/drush_make" do
  repository "http://git.drupal.org/project/drush_make.git"
  reference "6.x-2.2"
  depth 5
  action :sync
end

link "/usr/share/drush/commands/drush_make" do
  to "/usr/share/drush_make"
  not_if { ::FileTest.directory?("/usr/share/drush/commands") }
  not_if "test -L /usr/share/drush/commands/drush_make"
end
