class Derecho
  module Rackspace
    class Load_Balancer
   
      def initialize
        config = Config.new.read
        settings = config['accounts']['rackspace']
        
        puts $:
        
        @service = Fog::Rackspace::LoadBalancers.new({
          :rackspace_username    => settings['username'],
          :rackspace_api_key     => settings['api_key'],
          :rackspace_lb_endpoint => "https://#{settings['region']}.loadbalancers.api.rackspacecloud.com/v1.0/"
        })
        
        @lb = @service.load_balancers
      end
    
      def create name, srv_id, protocol = 'HTTP', port = 80, virtual_ip_type = 'PUBLIC'
        srv_ip = Rackspace::Server.new.get(srv_id).private_ip_address
        
        @lb.create(
          :name     => name,
          :protocol => protocol,
          :port     => port,
          :virtual_ips => [{:type => virtual_ip_type}],
          :nodes => [{:address => srv_ip, :condition => 'ENABLED', :port => port}]  
        )
      end
      
      def get lb_id
        @lb.get lb_id
      end
      
      def all
        @lb.all
      end
      
      def delete lb_id
        lb = @lb.get lb_id
        lb.destroy unless lb.nil?
        lb
      end
      
      class << self
        
        def exists? lb_id
          lb = self.new.get lb_id
          !lb.nil?
        end
        
        def srv_exists? srv_id
          Rackspace::Server.exists? srv_id
        end
        
      end
      
      def is_server_attached? lb_id, srv_id
        if exists? lb_id and srv_exists? srv_id  
          srv = Rackspace::Server.new.get server_id
        
          get_nodes(lb_id).any? do |node| 
            node.address == srv.private_ip_address
          end
        end
      end

      def attach_server lb_id, server_id, port = nil, condition = 'ENABLED'
        unless is_server_attached? lb_id, server_id
          lb = get lb_id
          srv = Rackspace::Server.new.get server_id
          
          lb.nodes.create(
            :address => srv.private_ip_address,
            :port => port || lb.port,
            :condition => condition
          ).save
          
          lb
        else
          raise "#{srv.name} is already attached to #{lb.name}"
        end
      end

      # working with nodes
      
      def get_nodes lb_id
        lb = get lb_id
        lb.nodes.all
      end
      
      def get_node lb_id, node_id
        lb = get lb_id
        lb.nodes.get node_id
      end
      
      def node_exists? lb_id, node_id
        node = get_node lb_id, node_id
        !node.nil?
      end
      
      def detach_node lb_id, node_id
        if is_node_attached? lb_id, node_id
          lb = get lb_id
          nodes = get_nodes lb_id
        
          if nodes.count > 1 and node_exists? lb_id, node_id
            node = get_node lb_id, node_id
            node.destroy
          end
          
          lb
        end
      end
      
    end
  end
end