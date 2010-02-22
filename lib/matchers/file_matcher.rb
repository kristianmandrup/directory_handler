require 'rubygems'
require 'rake'

module AppIndx
  class FileMatcher
    attr_accessor :name, :matchings 

    def initialize(name, config = nil)
      @name ||= name
      return if !config
      @matchings ||= []
      if config.respond_to? :each
        config.each{|obj| @matchings << obj}      
      else                 
        @matchings << ApplicationMatcher.remove_wrap(config, 'matches')
      end
    end
    
    def match?(path)
      files = FileList["#{name}"]
      return false if files.empty?
      file = files[0]
      return true if !matchings || matchings.empty?
      matchings.each do |matching|
        return true if IO.read(file) =~ matching
      end
      false
    end        
  end
end