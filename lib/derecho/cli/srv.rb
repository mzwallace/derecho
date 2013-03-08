module Derecho

  module CLI

    class Srv < Thor

      default_task :list

      def initialize(args=[], options={}, config={})
        super

        @config = Derecho::CLI::Config.new
        @config.load
      end

      desc 'list', 'List all cloud servers'
      def list
        rackspace = @config.get('rackspace')

        cs = Fog::Compute::RackspaceV2.new(
          :rackspace_username => rackspace['username'],
          :rackspace_api_key => rackspace['api_key'],
          :rackspace_endpoint => "https://#{rackspace['region']}.servers.api.rackspacecloud.com/v2"
        )

        cs.list_servers.body['servers'].each do |cs|
          puts "Name #{cs['name']} #{cs['id']}"
          puts "Flavor #{cs['flavor']['id']}"
          puts "Image #{cs['image']['id']}"
          puts "IP(s) #{cs['addresses']['public'][1]['addr']} (public) #{cs['addresses']['private'][0]['addr']} (private)"
          puts "Status #{cs['status']}" if cs['status'] == "ACTIVE"
          puts "Status #{cs['status']} #{cs['progress']}%" if cs['status'] != "ACTIVE"
          puts ""
        end
      end

    end

  end

end