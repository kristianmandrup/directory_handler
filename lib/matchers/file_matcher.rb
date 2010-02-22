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
      return false if !match_file?(name) 
      return true if !matchings || matchings.empty?
      matchings.each do |matching|
        return true if IO.read(name) =~ /#{Regexp.escape(matching)}/
      end    

      false
    end        
    
    def match_file?(name) 
      all_files = FileList["**/*"]
      all_files.each do |file|
        return true if file =~ /^#{Regexp.escape(name)}$/       
      end 
      false      
    end
  end
end