$:.unshift "#{File.dirname(__FILE__)}/../../lib"
require 'derecho'
require 'derecho/sub/lb'
require 'derecho/sub/srv'
require 'derecho/sub/config'

class Derecho
  class CLI
      
    def initialize(args=[], options={}, config={})
      super
      Derecho::Sub::Config.new.check
    end

    desc 'config', 'Manage config settings'
    subcommand 'config', Derecho::Sub::Config

    desc 'lb', 'Manage cloud load balancers'
    subcommand 'lb', Derecho::Sub::Lb

    desc 'srv', 'Manage cloud servers'
    subcommand 'srv', Derecho::Sub::Srv
      
    map %w(-v --version) => :version
    desc 'version', 'Show version number'
    def version
      puts "v#{Derecho::VERSION}"
    end
      
    desc "help [command]", "List all available options"
    def help(task = nil, subcommand = false)
      task ? self.class.task_help(shell, task) : self.class.help(shell, subcommand)
    end 
      
  end
end