class Derecho
  module Rackspace
    
    class Load_Balancer
      
      @@api_endpoint = '.loadbalancers.api.rackspacecloud.com/v1.0/'
      
      def initialize
        @config = Derecho::Config.new
        @config.read
        @settings = @config['accounts']['rackspace']
      end
      
      def get_load_balancers
        lb = Fog::Rackspace::LoadBalancers.new(
          :rackspace_username => @settings['username'],
          :rackspace_api_key => @settings['api_key'],
          :rackspace_lb_endpoint => "https://#{@settings['region']}#{@@api_endpoint}"
        )
        
        lb.list_load_balancers.body['loadBalancers']
      end
      
    end
    
  end
end