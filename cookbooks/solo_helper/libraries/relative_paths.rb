#
# Author:: Glenn Pratt (<glenn@allplayers.com>)
# Copyright:: Copyright (c) 2011 AllPlayers.com, Inc.
# License:: Apache License, Version 2.0
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

class Chef
  module Mixin
    module RelativePaths
      
      # Reduces paths to their most relative versions, mainly to discourage
      # root relative symlinks, which don't work well when a filesystem is
      # mounted remotely or at a different path.
      def most_relative_path(source, target)
        source = source.split(::File::Separator) unless source.kind_of?(Array)
        target = target.split(::File::Separator) unless target.kind_of?(Array)

        base_dir = []
        (source & target).each_index do |i|
          break if target[i] != source[i]
          base_dir << target[i]
        end

        source = source - base_dir
        target = target - base_dir

        [File.join(source), File.join(target), File.join(base_dir)]
      end
    end
  end
end

class Chef
  class Provider
    class Deploy
      def relative_symlink(src, dest, options = {})
        src, dest, base = most_relative_path(src, dest)
        Chef::Log.info("Linking #{dest} to #{src} from base #{base}")
        FileUtils.cd(base) do
          FileUtils.ln_sf(src, dest, options)
        end
      end

      def link_current_release_to_production
        FileUtils.rm_f(@new_resource.current_path)
        begin
          relative_symlink(release_path, @new_resource.current_path)
        rescue => e
          raise Chef::Exceptions::FileNotFound.new("Cannot symlink current release to production: #{e.message}")
        end
        Chef::Log.info "#{@new_resource} linked release #{release_path} into production at #{@new_resource.current_path}"
        enforce_ownership
      end

      def run_symlinks_before_migrate
        links_info = @new_resource.symlink_before_migrate.map { |src, dst| "#{src} => #{dst}" }.join(", ")
        @new_resource.symlink_before_migrate.each do |src, dest|
          begin
            relative_symlink(@new_resource.shared_path + "/#{src}", release_path + "/#{dest}")
          rescue => e
            raise Chef::Exceptions::FileNotFound.new("Cannot symlink #{@new_resource.shared_path}/#{src} to #{release_path}/#{dest} before migrate: #{e.message}")
          end
        end
        Chef::Log.info "#{@new_resource} made pre-migration symlinks"
      end

      def link_tempfiles_to_current_release
        dirs_info = @new_resource.create_dirs_before_symlink.join(",")
        @new_resource.create_dirs_before_symlink.each do |dir|
          begin
            FileUtils.mkdir_p(release_path + "/#{dir}")
          rescue => e
            raise Chef::Exceptions::FileNotFound.new("Cannot create directory #{dir}: #{e.message}")
          end
        end
        Chef::Log.info("#{@new_resource} created directories before symlinking #{dirs_info}")

        links_info = @new_resource.symlinks.map { |src, dst| "#{src} => #{dst}" }.join(", ")
        @new_resource.symlinks.each do |src, dest|
          begin
            relative_symlink(@new_resource.shared_path + "/#{src}",  release_path + "/#{dest}")
          rescue => e
            raise Chef::Exceptions::FileNotFound.new("Cannot symlink shared data #{@new_resource.shared_path}/#{src} to #{release_path}/#{dest}: #{e.message}")
          end
        end
        Chef::Log.info("#{@new_resource} linked shared paths into current release: #{links_info}")
        run_symlinks_before_migrate
        enforce_ownership
      end
    end
  end
end
