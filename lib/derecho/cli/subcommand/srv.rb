class Derecho
  class CLI < Derecho::Thor
    module Subcommand
      class Srv < Derecho::Thor
      
        desc 'list', 'List all servers'
        option :detailed, :aliases => '-d', :type => :boolean
        def list
          Derecho::CLI::Subcommand.config_check
          srv = Derecho::Rackspace::Server.new
          srvs = srv.all
          srvs.each_with_index do |cs, index|
            say Derecho::CLI::View.compile options[:detailed] ? 'srv-list-detailed' : 'srv-list-oneline', cs
            say '' if options[:detailed] and index < srvs.size - 1
          end
        end

      end
    end
  end
end