class Derecho
  module Rackspace
    class Server
      
      @@api_endpoint = '.servers.api.rackspacecloud.com/v2'
      
      def initialize
        @config = Derecho::Config.new
        @config.read
        @settings = @config['accounts']['rackspace']
      end
      
      def get_servers
        cs = Fog::Compute::RackspaceV2.new(
          :rackspace_username => @settings['username'],
          :rackspace_api_key => @settings['api_key'],
          :rackspace_endpoint => "https://#{@settings['region']}#{@@api_endpoint}"
        )

        cs.list_servers.body['servers']
      end
      
    end
  end
end
