class Derecho
  module Rackspace
    class Server
      
      def initialize options = {}
        config = Derecho::Config.new.read
        settings = config['accounts']['rackspace']
        
        @service = Fog::Compute::RackspaceV2.new(
          :rackspace_username => settings['username'],
          :rackspace_api_key => settings['api_key'],
          :rackspace_endpoint => "https://#{settings['region']}.servers.api.rackspacecloud.com/v2"
        )
      end
      
      def all
        @service.servers.all
      end
      
      def get server_id
        @service.servers.get(server_id)
      end
      
      class << self
        
        def exists? server_id
          srv = self.new.get server_id
          !srv.nil?
        end
      
      end
      
    end
  end
end
