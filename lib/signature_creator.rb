module AppIndx
  class Application
    
    # creates a signature file for an application
    def create_signature(application)
      File.open(File.join(application.path, application.signature_name) do |file|
        file.puts application.signature_content
      end      
    end
  end
end

