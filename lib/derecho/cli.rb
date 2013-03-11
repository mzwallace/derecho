$:.unshift(File.join(File.dirname(__FILE__), "../..", "lib"))
require 'derecho'
require 'derecho/cli/lb'
require 'derecho/cli/srv'
require 'derecho/cli/config'

module Derecho

  module CLI

    class Main < Thor

      desc 'config', 'Manage config settings'
      subcommand 'config', Derecho::CLI::Config

      desc 'lb', 'Manage cloud load balancers'
      subcommand 'lb', Derecho::CLI::Lb

      desc 'srv', 'Manage cloud servers'
      subcommand 'srv', Derecho::CLI::Srv

    end

  end

end