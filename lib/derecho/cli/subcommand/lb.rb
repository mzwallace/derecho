class Derecho
  class CLI < Derecho::Thor
    module Subcommand
      class Lb < Derecho::Thor

        desc 'list', 'List all cloud load balancers'
        def list
          Derecho::CLI::Subcommand.config_check
          lb = Derecho::Rackspace::Load_Balancer.new
          lbs = lb.all
          lbs.each_with_index do |lb, index|
            say Derecho::CLI::View.compile 'lb-list-detailed', lb
            say '' unless index == lbs.size - 1
          end
        end
    
        desc 'create [lb-name] [first-server-id]', 'Create a load balancer and attach a server to it'
        option :protocol,        :alias => '-r', :default => 'HTTP', :desc => 'e.g. HTTP, HTTPS'
        option :port,            :alias => '-p', :default => 80,     :desc => 'e.g. 80, 443'
        option :virtual_ip_type, :alias => '-t', :default => 'PUBLIC', :desc => 'e.g. PUBLIC, SERVICENET'
        def create name = nil, server_id = nil, protocol = 'HTTP', port = 80, virtual_ip_type = 'PUBLIC'
          Derecho::CLI::Subcommand.config_check
          
          if name.nil?
            name = ask 'What do you want to name your load balancer?'
            say ''
          end
          
          if server_id.nil?
            srvs = Derecho::Rackspace::Server.new.all
            say 'Available servers:'
            srvs.each_with_index do |srv, index|
              say Derecho::CLI::View.compile 'srv-list-oneline', srv, :number => index + 1
            end
            say ''
            num = ask('Choose a server number:').to_i
            index = num - 1
            say '' 
            if yes? "Attach server #{srvs[index].name} to load balancer #{name}?"
              say ''
              server_id = srvs[index].id
            else
              say ''
              say 'Operation canceled.'
              exit
            end
          end 
            
          lb = Derecho::Rackspace::Load_Balancer.new
          
          if lb.server_exists? server_id
            fog_lb = lb.create name, server_id, protocol, port, virtual_ip_type
          
            say 'Building Load Balancer:'
            say "Name:     #{name}"
            say "ID:       #{fog_lb.id}"
            say "Protocol: #{protocol}" 
            say "Port:     #{port}"
            say "IP Type:  #{virtual_ip_type}"
            say ''
            fog_lb.wait_for(1800, 5) do 
              puts "Status: #{state}"
              puts 'Operation complete.' if ready?
              ready?
            end
          else 
            say "#{server_id} is not a valid server id."
          end
        end
        
        desc 'delete [lb-id]', 'Delete a load balancer'
        def delete lb_id = nil
          Derecho::CLI::Subcommand.config_check
          
          if lb_id.nil?
            lbs = Derecho::Rackspace::Load_Balancer.new.all
            say 'Available load balancers:'
            lbs.each_with_index do |lb, index|
              say Derecho::CLI::View.compile 'lb-list-oneline', lb, :number => index + 1
            end
            say ''
            num = ask('Choose a load balancer number:').to_i
            index = num - 1
            say '' 
            lb = lbs[index]
            if yes? "Delete load balancer #{lb.name}?"
              say ''
              lb_id = lb.id
            else
              say ''
              say 'Operation canceled.'
              exit
            end
          end 
          
          lb = Derecho::Rackspace::Load_Balancer.new
          
          if lb.exists? lb_id
            fog_lb = lb.delete lb_id
          
            say "Waiting for load balancer to shut down: #{fog_lb.name} #{lb_id}"
            say ''
            fog_lb.wait_for(1800, 5) do 
              puts "Status: #{state}"
              puts 'Operation complete.' if state === 'DELETED'
              state === 'DELETED'
            end
          else
            say "#{lb_id} is not a valid load balancer id."
          end
        end
        
        desc 'attach [lb-id] [server-id]', 'Attach a server to a load balancer'
        def attach lb_id, server_id
          Derecho::CLI::Subcommand.config_check
          lb = Derecho::Rackspace::Load_Balancer.new
          lb.attach_node lb_id, server_id
        end
        
        desc 'detach [lb-id] [server-id]', 'Detach a server from a load balancer'
        def detach lb_id, server_id
          Derecho::CLI::Subcommand.config_check
          lb = Derecho::Rackspace::Load_Balancer.new
          lb.detach_node lb_id, server_id
        end
        
      end
    end
  end
end