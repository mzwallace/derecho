class Derecho
  class CLI < Derecho::Thor
    module Subcommand
      class Lb < Derecho::Thor

        desc 'list', 'List all load balancers'
        option :detailed, :aliases => '-d', :type => :boolean
        def list
          Subcommand.config_check
          lb = Rackspace::Load_Balancer.new
          lbs = lb.all
          lbs.each_with_index do |lb, index|
            say CLI::View.compile options[:detailed] ? 'lb-list-detailed' : 'lb-list-oneline', lb
            say '' if options[:detailed] and index < lbs.size - 1
          end
        end
    
        desc 'create [lb-name] [first-server-id]', 'Create a load balancer and attach a server to it'
        option :protocol,        :aliases => '-r', :default => 'HTTP', :desc => 'e.g. HTTP, HTTPS'
        option :port,            :aliases => '-p', :default => 80,     :desc => 'e.g. 80, 443'
        option :virtual_ip_type, :aliases => '-t', :default => 'PUBLIC', :desc => 'e.g. PUBLIC, SERVICENET'
        def create name = nil, server_id = nil, protocol = 'HTTP', port = 80, virtual_ip_type = 'PUBLIC'
          Subcommand.config_check
          
          if name.nil?
            name = ask 'What do you want to name your load balancer?'
            say ''
          end
          
          if server_id.nil?
            fog_srv = Subcommand.prompt_for_server 
            server_id = fog_srv.id
          end
          
          lb = Rackspace::Load_Balancer.new
          
          if Rackspace::Server.exists? server_id
            fog_srv ||= Rackspace::Server.new.get server_id
            
            if yes? "Create load balancer #{name} with attached server #{fog_srv.name}?"
              fog_lb = lb.create name, server_id, protocol, port, virtual_ip_type

              say ''
              say 'Building load balancer:'
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
              say ''
              say 'Operation canceled.'
              exit
            end            
          else 
            say "#{server_id} is not a valid server id."
          end
        end
        
        desc 'delete [lb-id]', 'Delete a load balancer'
        def delete lb_id = nil
          Subcommand.config_check
          
          if lb_id.nil?
            fog_lb = Subcommand.prompt_for_lb 
            lb_id = fog_lb.id
          end
          
          lb = Rackspace::Load_Balancer.new
          
          if lb.exists? lb_id
            fog_lb ||= lb.get lb_id
            
            if yes? "Delete load balancer #{fog_lb.name}?"
              fog_lb = lb.delete lb_id
            
              say ''
              say 'Waiting for load balancer to shut down:'
              say "Name: #{fog_lb.name}"
              say "ID:   #{lb_id}"
              say ''
              
              fog_lb.wait_for(1800, 5) do 
                puts "Status: #{state}"
                puts 'Operation complete.' if state === 'DELETED'
                state === 'DELETED'
              end
            else
              say ''
              say 'Operation canceled.'
              exit
            end
          else
            say "#{lb_id} is not a valid load balancer id."
          end
        end
        
        desc 'nodes [lb-id]', 'List a load balancer\'s nodes'
        option :detailed, :aliases => '-d', :type => :boolean
        def nodes lb_id = nil
          Subcommand.config_check
          
          if lb_id.nil?
            fog_lb = Subcommand.prompt_for_lb if lb_id.nil?
            lb_id = fog_lb.id
          end
          
          nodes = Rackspace::Load_Balancer.new.get_nodes lb_id
          
          nodes.each_with_index do |node, index|
            say View.compile options[:detailed] ? 'node-list-detailed' : 'node-list-oneline', node
            say '' if options[:detailed] and index < nodes.size - 1
          end
        end
        
        desc 'attach [lb-id] [server-id]', 'Attach a server to a load balancer'
        def attach lb_id = nil, srv_id = nil
          Subcommand.config_check
          
          if lb_id.nil?
            fog_lb = Subcommand.prompt_for_lb if lb_id.nil?
            lb_id = fog_lb.id
          end
          
          if srv_id.nil?
            fog_srv = Subcommand.prompt_for_server 
            srv_id = fog_srv.id
          end
          
          lb = Rackspace::Load_Balancer.new
          
          if lb.exists? lb_id
            if Rackspace::Server.exists? srv_id
              fog_srv ||= Rackspace::Server.new.get srv_id
              fog_lb ||= lb.get lb_id
              
              if !lb.is_attached? lb_id, srv_id
                if yes? "Attach server #{fog_srv.name} to load balancer #{fog_lb.name}?"
                  fog_lb = lb.attach lb_id, srv_id
                  
                  say ''
                  say "Attaching server #{fog_srv.name} to load balancer #{fog_lb.name}:"
                  say ''
                
                  fog_lb.wait_for(1800, 5) do 
                    puts "Status: #{state}"
                    puts 'Operation complete.' if state === 'ACTIVE'
                    state === 'ACTIVE'
                  end
                else
                  say ''
                  say 'Operation canceled.'
                  exit
                end
              else
                say "#{fog_srv.name} is already attached to #{fog_lb.name}."
              end
            else
              say "#{srv_id} is not a valid server id."
            end
          else
            say "#{lb_id} is not a valid load balancer id."
          end
        end
        
        desc 'detach [lb-id] [node-id]', 'Detach a node from a load balancer'
        def detach lb_id = nil, node_id = nil
          Subcommand.config_check
          lb = Rackspace::Load_Balancer.new
          
          if lb_id.nil?
            fog_lb = Subcommand.prompt_for_lb if lb_id.nil?
            lb_id = fog_lb.id
          end
          
          if node_id.nil?
            nodes = lb.get_nodes lb_id
          
            say 'Available nodes:'
            nodes.each_with_index do |node, index|
              say View.compile 'node-list-oneline', node, :number => index + 1
            end
            
            say ''
            num = ask('Choose a node number:').to_i
            index = num - 1
            say '' 
            fog_node = nodes[index]
            node_id = fog_node.id
          end
          
          if lb.exists? lb_id
            if lb.node_exists? lb_id, node_id
              fog_lb ||= lb.get lb_id
              fog_node ||= lb.get_node lb_id, node_id
              
              if yes? "Detach node #{fog_node.address} from load balancer #{fog_lb.name}?"
                fog_lb = lb.detach lb_id, node_id
                
                say ''
                say "Detaching node #{fog_node.address} from load balancer #{fog_lb.name}:"
                say ''
                
                fog_lb.wait_for(1800, 5) do 
                  puts "Status: #{state}"
                  puts 'Operation complete.' if state === 'ACTIVE'
                  state === 'ACTIVE'
                end
              else
                say ''
                say 'Operation canceled.'
                exit
              end
            else
              say "#{node_id} is not a valid node id."
            end
          else
            say "#{lb_id} is not a valid load balancer id."
          end
        end
        
      end
    end
  end
end