module AppIndx
  class ApplicationHandler
    attr_accessor :matchers
    
    def handle(path)       
      # let each registered app matcher try and handle the path
      matchers.each do |matcher|
        if matcher.handle path
          puts "MATCHING APP: #{path} SIGNATURE: #{matcher.signature_name}" 
        end                  
      end
    end
  end
end      
    

