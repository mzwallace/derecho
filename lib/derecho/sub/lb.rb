class Derecho
  module Sub
    class Lb < Derecho::Thor

      desc 'list', 'List all cloud load balancers'
      def list
        Derecho::Sub.config_check
        lb = Derecho::Rackspace::Load_Balancer.new
        puts ''
        lb.get_load_balancers.each do |lb|
          puts Derecho::View.compile lb, 'lb'
          puts ''
        end
      end
      
    end
  end
end