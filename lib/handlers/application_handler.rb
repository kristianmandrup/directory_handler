module AppIndx
  class ApplicationHandler
    attr_accessor :matchers
    
    def handle(path)            
      FileUtils.cd(path)
      # let each registered app matcher try and handle the path  
      matching_apps_found ||= []
      matchers.each do |matcher|        
        matching_apps_found << matcher.handle(path)
      end 
      if !matching_apps_found.compact!.empty?    
        matching_app_signatures = matching_apps_found.map{|a| a.signature_name}.join(',')                   
        matching_apps_found.each do |app|                                    
          ext_app = app.extends_app 
          if ext_app
            matching_apps_found.reject!{|a| a.signature_name == ext_app.signature_name} 
          end
        end
        matching_app_signatures = matching_apps_found.map{|a| a.signature_name}.join(',')                           
        puts "MATCHING APPS: #{path}, #{matching_app_signatures}"                 
      end
    end
  end
end      
    

