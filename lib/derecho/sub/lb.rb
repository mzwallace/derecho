class Derecho
  module Sub
    class Lb < Derecho::Thor

      desc 'list', 'List all cloud load balancers'
      def list
        Derecho::Sub.config_check
        lb = Derecho::Rackspace::Load_Balancer.new
        lb.get_load_balancers.each do |lb|
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