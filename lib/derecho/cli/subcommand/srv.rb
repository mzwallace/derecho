class Derecho
  class CLI < Derecho::Thor
    module Subcommand
      class Srv < Derecho::Thor
      
        desc 'list', 'List all cloud servers'
        def list
          Derecho::CLI::Subcommand.config_check
          cs = Derecho::Rackspace::Server.new
          css = cs.get_all
          css.each_with_index do |cs, index|
            say Derecho::CLI::View.compile 'srv', cs
            say '' unless index == css.size - 1
          end
        end

      end
    end
  end
end