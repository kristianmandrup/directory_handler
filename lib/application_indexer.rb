require 'rubygems'
require 'matchers/matchers'
require 'handlers/handlers'
require 'yaml'    
require 'find'

module AppIndx
  class Main
    attr_accessor :app_handlers
    attr_reader :app_matcher, :app_handler
    
    def initialize
      @app_matcher ||= ApplicationMatcher.new    
      @app_handler ||= ApplicationHandler.new
    end

    # loads configuration file of application matchers
    # build an internal object graph from this file
    # object graph can later be traversed and signatures generated in relevant directories
    def load_config(filename)
      yml = YAML.load_file(filename)
      yml.each do |key, value| 
        next if key == 'Templates'

        if key == 'PackageDirs'
          # PackageDirs.register value
        elsif key == 'AppDirs'   
          # ApplicationDirMatcher.register value
        else
          app_matcher.register value
        end    
      end
    end    
    
    def index(root_path) 
      app_handler.matchers = app_matcher.application_matchers
                 
      Find.find(root_path) do |path|
        if FileTest.directory?(path)
          if File.basename(path)[0] == ?.
            Find.prune 
          else
            app_handler.handle(path)        
            next
          end
        else
          # file
        end
      end             
    end
  end
end

filename = 'config/matcher_config.yml'
root_path = File.join(ENV['HOME'], 'playground')
app_indexer = AppIndx::Main.new
app_indexer.load_config filename
app_indexer.index root_path

