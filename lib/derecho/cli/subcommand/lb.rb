class Derecho
  class CLI < Derecho::Thor
    module Subcommand
      class Lb < Derecho::Thor

        desc 'list', 'List all cloud load balancers'
        def list
          Derecho::CLI::Subcommand.config_check
          lb = Derecho::Rackspace::Load_Balancer.new
          lbs = lb.get_all
          lbs.each_with_index do |lb, index|
            say Derecho::CLI::View.compile 'lb', lb
            say '' unless index == lbs.size - 1
          end
        end
    
        desc 'create [lb-name] [first-server-id]', 'Create a load balancer and attach a server to it'
        option :protocol,  :aliases => '-r', :default => 'HTTP', :desc => 'e.g. HTTP, HTTPS'
        option :port,      :aliases => '-p', :default => 80,     :desc => 'e.g. 80, 443'
        option :virtual_ip_type, :alias => '-t', :default => 'PUBLIC', :desc => 'e.g. PUBLIC, SERVICENET'
        def create name, server_ip, protocol = 'HTTP', port = 80, virtual_ip_type = 'PUBLIC'
          Derecho::CLI::Subcommand.config_check
          lb = Derecho::Rackspace::Load_Balancer.new
          lb = lb.create name, server_ip, protocol, port, virtual_ip_type
          
          say 'Creating Load Balancer'
          lb.wait_for(600, 5) do 
            print '.'
            say 'complete' if ready?
            ready?
          end
        end
        
        desc 'delete [lb-id]', 'Delete a load balancer'
        def delete lb_id
          Derecho::CLI::Subcommand.config_check
          lb = Derecho::Rackspace::Load_Balancer.new
          lb = lb.delete lb_id
          
          say 'Deleting Load Balancer'
          lb.wait_for(600, 5) do 
            print '.' 
            say 'complete' if ready?
            ready?
          end
          
        end
      end
    end
  end
end