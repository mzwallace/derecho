module Derecho

  module CLI

    class Lb < Thor

      default_task :list

      def initialize(args=[], options={}, config={})
        super

        @config = Derecho::CLI::Config.new
        @config.load
      end

      desc 'list', 'List all cloud load balancers'
      def list
        rackspace = @config.get('rackspace')

        lb = Fog::Rackspace::LoadBalancers.new(
          :rackspace_api_key => rackspace['api_key'],
          :rackspace_username => rackspace['username'],
          :rackspace_lb_endpoint => "https://#{rackspace['region']}.loadbalancers.api.rackspacecloud.com/v1.0/"
        )

        lb.list_load_balancers.body['loadBalancers'].each do |lb|
          puts "Name    #{lb['name']} #{lb['id']}"
          puts "Port    #{lb['port']}"
          puts 'IP(s)   ' + lb['virtualIps'].map { |ip| ip['address'] }.join(',')
          puts "Status  #{lb['status']}"
          puts "Node(s) #{lb['nodeCount']}"
          puts ''
        end
      end

    end

  end

end