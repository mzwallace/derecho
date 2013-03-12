class Derecho
  module Sub
    class Srv < Derecho::Thor
      
      desc 'list', 'List all cloud servers'
      def list
        Derecho::Sub.config_check
        cs = Derecho::Rackspace::Server.new
        puts ''
        cs.get_servers.each do |cs|
          puts Derecho::View.compile cs, 'srv'
          puts ''
        end
      end

    end
  end
end