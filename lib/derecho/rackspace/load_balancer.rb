class Derecho
  module Rackspace
    class Load_Balancer
      
      @@api_endpoint = '.loadbalancers.api.rackspacecloud.com/v1.0/'
      
      attr_accessor :service
      
      def initialize
        @config = Derecho::Config.new
        @config.read
        @settings = @config['accounts']['rackspace']
        @service = Fog::Rackspace::LoadBalancers.new({
          :rackspace_username    => @settings['username'],
          :rackspace_api_key     => @settings['api_key'],
          :rackspace_lb_endpoint => "https://#{@settings['region']}#{@@api_endpoint}"
        })
      end
      
      def create(name, server_id, protocol = 'HTTP', port = 80, virtual_ip_type = 'PUBLIC')
        server_ip = Derecho::Rackspace::Server.new.get(server_id).private_ip_address
        
        lb = @service.load_balancers.create(
          :name     => name,
          :protocol => protocol,
          :port     => port,
          :virtual_ips => [{:type => virtual_ip_type}],
          :nodes => [{:address => server_ip, :condition => 'ENABLED', :port => port}]  
        )
      end
      
      def get_all
        @service.load_balancers.all
      end
      
      def get(lb_id)
        @service.load_balancers.get(lb_id)
      end
      
      def get_nodes(lb_id)
        nodes = @service.nodes.new
        nodes.load_balancer = get(lb_id)
        nodes.all
      end
      
      def get_node(lb_id, node_id)
        nodes = @service.nodes.new
        nodes.load_balancer = get(lb_id)
        
        # possible exception to catch
        nodes.get(node_id)
      end
      
      def add_node(lb_id, node_id, address, port = 80, condition = 'ENABLED')
        # ignore the request if it's already attached
        unless get_nodes(lb_id).any? {|n| n.id == node_id }
          node = @service.node.new
          node.load_balancer = get(lb_id)
          node.address = address
          node.port = port
          node.condition = condition
          node.save
        end
      end
      
      def remove_node(lb_id, node_id)
        get_node(lb_id, node_id).destroy 
      end
    end
  end
end