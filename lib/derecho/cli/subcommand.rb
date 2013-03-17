class Derecho
  class CLI < Derecho::Thor
    module Subcommand
    
      module_function
    
      def config_check
        Derecho::CLI::Subcommand::Config.new.check
      end
  
    end
  end
end

Dir.glob("#{File.dirname(__FILE__)}/subcommand/*", &method(:require))