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
    
        desc 'create [lb-name] [first-server-id]', 'Create a load balancer'
        option :protocol,  :aliases => '-r', :default => 'HTTP', :desc => 'e.g. HTTP, HTTPS'
        option :port,      :aliases => '-p', :default => 80,     :desc => 'e.g. 80, 443'
        option :virtual_ip_type, :alias => '-t', :default => 'PUBLIC', :desc => 'e.g. PUBLIC, SERVICENET'
        def create(name, server_ip, protocol = 'HTTP', port = 80, virtual_ip_type = 'PUBLIC')
          Derecho::CLI::Subcommand.config_check
          lb = Derecho::Rackspace::Load_Balancer.new
          lb.create(name, server_ip, protocol, port, virtual_ip_type)
        end
    
      end
    end
  end
end