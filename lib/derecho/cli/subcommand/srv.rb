class Derecho
  module Sub
    class Srv < Derecho::Thor
      
      desc 'list', 'List all cloud servers'
      def list
        Derecho::Sub.config_check
        cs = Derecho::Rackspace::Server.new
        cs.get_all.each do |cs|
          say Derecho::View.compile cs, 'srv'
        end
      end

    end
  end
end