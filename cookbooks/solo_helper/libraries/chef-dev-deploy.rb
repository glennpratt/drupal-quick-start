# Make the deploy symlink as relative as possible, so that it works over a
# shared mount (ie NFS).
if Chef::Config[:solo]
  class Chef
    class Provider
      class Deploy
        # Set the ownership on the file, assuming it is not set correctly already.
        def link_current_release_to_production
          FileUtils.rm_f(@new_resource.current_path)
          rel_path = release_path.split(::File::Separator)
          cur_path = @new_resource.current_path.split(::File::Separator)
          base_dir = rel_path & cur_path
          rel_path = rel_path - base_dir
          cur_path = cur_path - base_dir
          begin
            FileUtils.cd(::File.join(base_dir)) do |dir|
              FileUtils.ln_sf(::File.join(rel_path), ::File.join(cur_path))
            end
          rescue => e
            raise Chef::Exceptions::FileNotFound.new("Cannot symlink current release to production: #{e.message}")
          end
          Chef::Log.info "#{@new_resource} linked release #{release_path} into production at #{@new_resource.current_path}"
          enforce_ownership
        end
        def link_current_release_to_production
          FileUtils.rm_f(@new_resource.current_path)
          begin
            FileUtils.ln_sf(release_path, @new_resource.current_path)
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
              FileUtils.ln_sf(@new_resource.shared_path + "/#{src}", release_path + "/#{dest}")
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
              FileUtils.ln_sf(@new_resource.shared_path + "/#{src}",  release_path + "/#{dest}")
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
end
