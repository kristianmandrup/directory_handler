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

        signature_dir = '.signatures'                
        FileUtils.mkdir(signature_dir) if !File.directory?(signature_dir)
        FileUtils.cd(signature_dir) do
          matching_apps_found.each do |matching_app|          
            file_name = File.join(path, signature_dir, matching_app.signature_name)
            file = File.new(file_name, 'w')
            file.puts matching_app.signature_content
          end
        end
      else
        # puts "no mathing apps found"
      end
    end
  end
end      
    

