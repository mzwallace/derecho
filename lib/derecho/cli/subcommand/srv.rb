class Derecho
  class CLI < Derecho::Thor
    module Subcommand
      class Srv < Derecho::Thor
      
        desc 'list', 'List all cloud servers'
        def list
          Derecho::CLI::Subcommand.config_check
          cs = Derecho::Rackspace::Server.new
          cs.get_all.each do |cs|
            say Derecho::CLI::View.compile cs, 'srv'
          end
        end

      end
    end
  end
end