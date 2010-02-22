module AppIndx
  class Application
    attr_accessor :extensions, :files, :signature, :package, :extends_app, :type
  
    def initialize(config)
      parse(config)
    end

    def signature_name
      signature
    end

    def signature_content
      'TODO'
    end

    # determine if directory matches this type of application
    def handle(path)   
      return self if match_files? path        
      # return true if match_package? path
      return nil
    end

    def match_files?(path)
      return false if !files || files.empty?
      files.each do |file_matcher| 
        return false if !file_matcher.match? path
      end
      return true
    end

    def match_package?(path)
      true
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
        parse_dir value
      when 'SIGNATURE'             
        @signature ||= value
      when 'TYPE'          
        @type ||= value            
      when 'EXTEND'  
        @extends_app ||= Application.new(value)            
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
        elsif value.include?('matches')
          @files << FileMatcher.new(name, value)          
        else         
          puts "parse_dir_hash:"
          puts config 
          # @files << config
        end
      end       
    end

    def to_s
      "Extensions: #{@extensions.inspect}" 
    end
  end
end