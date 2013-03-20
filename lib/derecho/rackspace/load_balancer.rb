class Derecho
  module Rackspace
    class Load_Balancer
      
      def initialize
        config = Derecho::Config.new.read
        settings = config['accounts']['rackspace']
        
        @service = Fog::Rackspace::LoadBalancers.new({
          :rackspace_username    => settings['username'],
          :rackspace_api_key     => settings['api_key'],
          :rackspace_lb_endpoint => "https://#{settings['region']}.loadbalancers.api.rackspacecloud.com/v1.0/"
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
      
      def all
        @service.load_balancers.all
      end
      
      def get lb_id
        @service.load_balancers.get lb_id
      end
      
      def get_nodes lb_id
        lb = get lb_id
        lb.nodes.all
      end
      
      def get_node lb_id, node_id
        nodes = get_nodes lb_id 
        nodes.select { |node| node.id == node_id }
      end
      
      def exists? lb_id
        lb = get lb_id
        !lb.nil?
      end
      
      def node_exists? node_id
        node = get_node node_id
        !node.nil?
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
      
      def attach lb_id, server_id, port = nil, condition = 'ENABLED'
        # check that both lb and srv are valid
        if exists? lb_id and server_exists? server_id
          # ignore the request if it's already attached
          unless is_attached? lb_id, server_id
            lb = get lb_id
            server = Derecho::Rackspace::Server.new.get server_id
            
            node = @service.nodes.new :service => @service, :load_balancer => lb
            node.address = server.private_ip_address
            node.port = port || lb.port
            node.condition = condition
            node.save
            
            lb
          end
        end
      end
      
      def detach lb_id, node_id
        if exists? lb_id
          lb = get lb_id
          nodes = get_nodes lb_id
        
          if nodes.count > 1 and node_exists? node_id
            node = get_node lb_id, node_id
            node.destroy
          end
          
          lb
        end
      end
      
    end
  end
end