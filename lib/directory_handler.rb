require 'rubygems'
require 'matchers/matchers'
require 'yaml'    
require 'find'

module DirectoryHandler
  class Main
    attr_accessor :app_handlers
    
    def initialize
      @app_matcher = ApplicationMatcher.new
    end
       
    def load_config(filename)
      yml = YAML.load_file(filename)
      yml.each do |key, value| 
        next if key == 'Templates'

        if key == 'PackageDirs'
          # PackageDirs.register value
        elsif key == 'AppDirs'   
          # ApplicationDirMatcher.register value
        else
          @app_matcher.register value
        end    
      end
    end
    
    def run(root_path)            
      Find.find(root_path) do |path|
        if FileTest.directory?(path)
          if File.basename(path)[0] == ?.
            Find.prune 
          else
            dir_handler.handle(path)        
            next
          end
        else
          # file
        end
      end             
    end
  end
end

filename = 'config/config.yml'
root_path = File.join(ENV['HOME'], 'playground')
dir_handler = DirectoryHandler::Main.new
dir_handler.load_config filename
dir_handler.run root_path

