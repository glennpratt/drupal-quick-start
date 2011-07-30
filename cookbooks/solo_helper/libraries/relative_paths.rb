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
      
      # Creates a given path, including all directories that lead up to it.
      # Like mkdir_p, but without the leaking.
      #
      # === Parameters
      # file_path<String, Array>:: A string that represents the path to create, 
      #   or an Array with the path-parts.
      #
      # === Returns
      # The created file_path.
      def most_relative_path(source, target)
        unless file_path.kind_of?(String) || file_path.kind_of?(Array)
          raise ArgumentError, "file_path must be a string or an array!" 
        end

        source = source.split(::File::Separator)
        target = target.split(::File::Separator)
        target.each_index do |i|
          
        end
        base_dir = source & target
        source = source - base_dir
        target = target - base_dir

        if file_path.kind_of?(String)
          file_path = File.expand_path(file_path).split(File::SEPARATOR)
          file_path.shift if file_path[0] = ''
          unless file_path[0].match("^#{File::SEPARATOR}")
            file_path[0] = "#{File::SEPARATOR}#{file_path[0]}"
          end
        end
                
        file_path.each_index do |i|
          create_path = File.join(file_path[0, i + 1])
          unless File.directory?(create_path)
            Chef::Log.debug("Creating directory #{create_path}")
            Dir.mkdir(create_path)
          end 
        end
        File.expand_path(File.join(file_path))
      end
  
    end
  end
end
