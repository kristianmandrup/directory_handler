module DirectoryHandler
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
  end   
  
  class Application
    attr_accessor :extensions, :files, :signature, :package, :extend, :type
    
    def initialize(config)
      parse(config)
    end

    def parse(config)
      config.each do |obj, value| 
        case obj
        when Hash            
            obj.each do |key, value|             
              parse_hash(key, value)
            end
        else 
            puts "Should be hash here!"
        end
      end   
    end

    def parse_hash(key, value)
      case key 
      when 'EXTENSIONS'
        @extensions ||= value.split(',')
      when 'DIR'
        @files ||= parse_dir(value)
      when 'SIGNATURE'             
        @signature ||= value
      when 'TYPE'          
        @type ||= value            
      when 'EXTEND'
        @extend ||= value            
      else 
        puts "Unknown app key: #{key}"
      end                
    end

    def parse_dir(dir) 
      @files ||= [] 
      dir.each do |obj, value| 
        case obj
        when Hash            
          obj.each do |key, value|             
            case key
            when 'Package'
              @package = PackageMatcher.new value
            when Hash
              parse_dir_hash(obj) 
            end                                          
          end
        else 
          @files << FileMatcher.new(obj)
        end
      end   
    end

    def parse_dir_hash(config)
      config.each do |obj, value|       
        @files ||= []
        if value.include?('FILE')
          @files << FileMatcher.new(name, value)
        else
          @files << config
        end
      end
    end

    def to_s
      "Extensions: #{@extensions.inspect}" 
    end
  end

  class FileMatcher
    attr_accessor :name, :matchings 
    
    def initialize(name, config = nil)
      @name ||= name
      return if !config
      @matchings ||= []
      config.each do |obj|       
        @matchings << obj
      end
    end
    
  end
     
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