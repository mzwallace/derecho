class Derecho
  module Sub
    
    module_function
    
    def config_check
      Derecho::Sub::Config.new.check
    end
  
  end
end

Dir.glob("#{Dir.pwd}/lib/derecho/sub/*", &method(:require))