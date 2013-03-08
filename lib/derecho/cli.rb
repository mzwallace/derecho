$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
require 'derecho'
require 'derecho/cli/lb'
require 'derecho/cli/srv'
require 'derecho/cli/config'

module Derecho

  module CLI

    class Main < Thor

      desc 'config [TASK] [ARGS]', 'Manage config settings'
      subcommand 'config', Derecho::CLI::Config

      desc 'lb [TASK] [ARGS]', 'Manage cloud load balancers'
      subcommand 'lb', Derecho::CLI::Lb

      desc 'srv [TASK] [ARGS]', 'Manage cloud servers'
      subcommand 'srv', Derecho::CLI::Srv

    end

  end

end