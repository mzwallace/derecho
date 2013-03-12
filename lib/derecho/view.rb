class Derecho
  module View
    
    class Context
      def initialize(hash)
        hash.each_pair do |key, value|
          instance_variable_set('@' + key.to_s.gsub('-', '_').gsub(':', '_'), value)
        end
      end

      def get_binding
        binding
      end
    end
    
    module_function
    
    def compile(hash, view)
      path = "#{Dir.pwd}/lib/derecho/views/#{view}.erb"
      
      if File.exists?(path)
        template = ERB.new(File.read(path), nil, '%<>')
        template.result Context.new(hash).get_binding
      else
        ''
      end
    end
  
  end
end