class Derecho
  class CLI < Derecho::Thor
    module Subcommand
      class Srv < Derecho::Thor
      
        desc 'list', 'List all cloud servers'
        def list
          Derecho::CLI::Subcommand.config_check
          srv = Derecho::Rackspace::Server.new
          srvs = srv.all
          srvs.each_with_index do |cs, index|
            say Derecho::CLI::View.compile 'srv-list-detailed', cs
            say '' unless index == srvs.size - 1
          end
        end

      end
    end
  end
end