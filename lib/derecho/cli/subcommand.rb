class Derecho
  class CLI < Derecho::Thor
    module Subcommand
      
      module_function

      def config_check
        Config.new.check
      end
      
      def prompt_for_server
        shell = Thor::Shell::Basic.new
        srvs = Rackspace::Server.new.all
        
        shell.say 'Available servers:'
        srvs.each_with_index do |srv, index|
          shell.say View.compile 'srv-list-oneline', srv, :number => index + 1
        end
        
        shell.say ''
        num = shell.ask('Choose a server number:').to_i
        index = num - 1
        shell.say '' 
        srvs[index]
      end
      
      def prompt_for_lb
        shell = Thor::Shell::Basic.new
        lbs = Rackspace::Load_Balancer.new.all
        
        shell.say 'Available load balancers:'
        lbs.each_with_index do |lb, index|
          shell.say View.compile 'lb-list-oneline', lb, :number => index + 1
        end
        
        shell.say ''
        num = shell.ask('Choose a load balancer number:').to_i
        index = num - 1
        shell.say '' 
        lbs[index]
      end
      
    end
  end
end

Dir.glob("#{File.dirname(__FILE__)}/subcommand/*", &method(:require))