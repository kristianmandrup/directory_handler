require 'rubygems'
require 'active_support'
require 'test/unit'

module Blip
  class Klass
  end
end

module AppHandler
  class Basic
    def initialize
    end
    
    def matches(dir)
      FileList["#{dir}/**/*"]        
    end
  
    def handle(dir)    
      handle_app(dir) if matches(dir) #  to location
    end
    
  end
end

x = AppHandler.module_eval("Basic")
x.new

# p "Klass".constantize

def initialize() 
  register(AppHandler.constants)    
end

def handle(dir)
  Dir.chdir dir
  puts "Handle: #{dir}"
  app_handlers.each{|app_handler| app_handler.handle dir} 
end

# def register(app_handlers)
#   @app_handlers ||= []
#   app_handlers.each do |app_handler_class|        
#     klazz = AppHandler.module_eval app_handler_class
#     @app_handlers << klazz.new if klazz
#   end
# end 
