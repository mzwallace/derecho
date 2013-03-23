require 'tilt'

class Derecho
  class CLI
    module View
    
      module_function
      
      def compile(name, object, options = {})
        path = "#{File.dirname(__FILE__)}/view/#{name}.erb"
        Tilt.new(path).render object, options if File.exists? path
      end
      
    end
  end
end