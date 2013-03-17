class Derecho
  module Sub
    
    module_function
    
    def config_check
      Derecho::Sub::Config.new.check
    end
  
  end
end

Dir.glob("#{File.dirname(__FILE__)}/../../lib/derecho/sub/*", &method(:require))