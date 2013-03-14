class Derecho
  module Rackspace
    class Server
      
      @@api_endpoint = '.servers.api.rackspacecloud.com/v2'
      
      attr_accessor :service
      
      def initialize
        @config = Derecho::Config.new
        @config.read
        @settings = @config['accounts']['rackspace']
        @service = Fog::Compute::RackspaceV2.new(
          :rackspace_username => @settings['username'],
          :rackspace_api_key => @settings['api_key'],
          :rackspace_endpoint => "https://#{@settings['region']}#{@@api_endpoint}"
        )
      end
      
      def get_all
        @service.servers.all
      end
      
      def get(server_id)
        @service.servers.get(server_id)
      end
      
    end
  end
end
