class Derecho
  module Sub
    class Lb < Derecho::Thor

      desc 'list', 'List all cloud load balancers'
      def list
        Derecho::Sub.config_check
        lb = Derecho::Rackspace::Load_Balancer.new
        lb.get_all.each do |lb|
          say Derecho::View.compile lb, 'lb'
        end
      end
      
      desc 'create', 'Create a load balancer'
      #option :name,      :aliases => '-n', :required => true,  :desc => 'The load balancer\'s name'
      #option :server_id, :aliases => '-s', :required => true,  :desc => 'The first node\'s server ID #'
      option :protocol,  :aliases => '-r', :default => 'HTTP', :desc => 'e.g. HTTP, HTTPS'
      option :port,      :aliases => '-p', :default => 80,     :desc => 'e.g. 80, 443'
      option :virtual_ip_type, :alias => '-t', :default => 'PUBLIC', :desc => 'e.g. PUBLIC, SERVICENET'
      def create(name, server_ip, protocol = 'HTTP', port = 80, virtual_ip_type = 'PUBLIC')
        Derecho::Sub.config_check
        lb = Derecho::Rackspace::Load_Balancer.new
        lb.create(name, server_ip, protocol, port, virtual_ip_type)
      end
      
    end
  end
end