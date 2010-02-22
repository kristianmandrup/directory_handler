module AppIndx
  class PackageMatcher 
    attr_accessor :includes, :excludes
  
    def initialize(config)
      config.each do |obj| 
        if obj.include?('include')
          @includes = ApplicationMatcher.remove_wrap(obj, 'include')
        elsif obj.include?('exclude')
          @excludes = ApplicationMatcher.remove_wrap(obj, 'exclude')
        end
      end      
    end  
  
    def to_s
      "include: #{includes}\nexclude: #{excludes}"              
    end
  end    
end