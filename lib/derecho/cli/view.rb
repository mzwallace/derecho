require 'tilt'

class Derecho
  class CLI
    module View
      
      #class Context
      #  def initialize(hash)
      #    hash.each_pair do |key, value|
      #      instance_variable_set('@' + key.to_s.gsub('-', '_').gsub(':', '_'), value)
      #    end
      #  end
      #
      #  def get_binding
      #    binding
      #  end
      #end
    
      module_function
    
      def compile(view_name, object)
        path = "#{File.dirname(__FILE__)}/view/#{view_name}.erb"
      
        if File.exists? path
          Tilt.new(path).render object  
        else
          ''
        end
      end
      
    end
  end
end