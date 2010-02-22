require 'matchers/file_matcher'
require 'matchers/package_matcher'
require 'model/application'

module AppIndx
  class ApplicationMatcher
    attr_accessor :application_matchers
          
    def self.remove_wrap(txt, prefix)
      txt.gsub(/#{prefix}/, '').gsub(/\[|\]/, '')
    end
    
    def register(config)   
      @application_matchers ||= []
      @application_matchers << Application.new(config)
    end
    
    def initialize      
    end

    def parse(config)
    end
    
    def match(dir)
    end
    
    def handle(path)
      application_matchers.each do |matcher|
        matcher.handle path
      end
    end
  end   
  
end