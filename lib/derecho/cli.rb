$:.unshift(File.join(File.dirname(__FILE__), "../..", "lib"))
require 'derecho'
require 'derecho/cli/lb'
require 'derecho/cli/srv'
require 'derecho/cli/config'

module Derecho

  module CLI

    class Main < Thor
      
      def initialize(args=[], options={}, config={})
        super
        Derecho::CLI::Config.new.check
      end

      desc 'config', 'Manage config settings'
      subcommand 'config', Derecho::CLI::Config

      desc 'lb', 'Manage cloud load balancers'
      subcommand 'lb', Derecho::CLI::Lb

      desc 'srv', 'Manage cloud servers'
      subcommand 'srv', Derecho::CLI::Srv
      
      map %w(-v --version) => :version
      desc 'version', 'Show version number'
      def version
        puts "v#{Derecho::VERSION}"
      end
      
      desc "help", "List all available options"
      def help(task = nil, subcommand = false)
        task ? self.class.task_help(shell, task) : self.class.help(shell, subcommand)
      end 
      
      class << self
        protected
          def subcommand_help(cmd)
            desc "help", "List all available options"
            class_eval <<-RUBY
              def help(task = nil, subcommand = true); super; end
            RUBY
          end
      end
      
    end

  end

end