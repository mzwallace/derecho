class Derecho
  module Rackspace
    class Load_Balancer
      
      @@api_endpoint = '.loadbalancers.api.rackspacecloud.com/v1.0/'
      
      #attr_accessor :service
      
      def initialize
        config = Derecho::Config.new
        config.read
        settings = config['accounts']['rackspace']
        
        #puts settings
        #exit
        
        @service = Fog::Rackspace::LoadBalancers.new({
          :rackspace_username    => settings['username'],
          :rackspace_api_key     => settings['api_key'],
          :rackspace_lb_endpoint => "https://#{settings['region']}#{@@api_endpoint}"
        })
      end
      
      def create name, server_id, protocol = 'HTTP', port = 80, virtual_ip_type = 'PUBLIC'
        server_ip = Derecho::Rackspace::Server.new.get(server_id).private_ip_address
        
        lb = @service.load_balancers.create(
          :name     => name,
          :protocol => protocol,
          :port     => port,
          :virtual_ips => [{:type => virtual_ip_type}],
          :nodes => [{:address => server_ip, :condition => 'ENABLED', :port => port}]  
        )
      end
      
      def delete lb_id
        lb = get lb_id
        lb.destroy
        lb
      end
      
      def get_all
        @service.load_balancers.all
      end
      
      def get lb_id
        @service.load_balancers.get lb_id
      end
      
      def get_nodes lb_id
        lb = get lb_id
        lb.nodes.all
      end
      
      def get_node lb_id, server_id
        lb = get lb_id 
        lb.nodes.select { |node| puts node }
      end
      
      def exists? lb_id
        lb = get lb_id
        !lb.nil?
      end
      
      def server_exists? server_id
        server = Derecho::Rackspace::Server.new.get server_id
        !server.nil?
      end
      
      def is_attached? lb_id, server_id
        if server_exists? server_id
          server = Derecho::Rackspace::Server.new.get server_id
          get_nodes(lb_id).any? do |node| 
            node.address == server.private_ip_address
          end
        else
          false
        end
      end
      
      def attach_node lb_id, server_id, port = nil, condition = 'ENABLED'
        if server_exists? server_id
          # ignore the request if it's already attached
          unless is_attached? lb_id, server_id
            #node = @service.node.new
            #node.load_balancer = get lb_id 
            #node.address = address
            #node.port = port || node.load_balancer.port
            #node.condition = condition
            #node.save
          else
            # replace with raise
            puts 'Server already attached!'
          end
        else
          # replace with raise
          puts 'Server does not exist!'
        end
      end
      
      def detach_node lb_id, server_id
        server = Derecho::Rackspace::Server.new.get server_id
        node = get_node lb_id, node_id
        
        if node and node.destroy
          # replace with raise
          puts 'Server removed from load balancer'
        else 
          # replace with raise
          puts 'Server was not found on the specified load balancer'
        end
      end
    end
  end
end