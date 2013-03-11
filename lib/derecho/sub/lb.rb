class Derecho
  module Sub
    class Lb < Thor

      desc 'list', 'List all cloud load balancers'
      def list
        @config = Derecho::Config.new
        @config.read
        rackspace = @config['accounts']['rackspace']

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