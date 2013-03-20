$:.unshift "#{File.dirname(__FILE__)}/../../lib"
require 'derecho'
require 'derecho/thor'
require 'derecho/cli/subcommand'
require 'derecho/cli/view'

class Derecho
  class CLI < Derecho::Thor
    
    def initialize *args
      super
      # adds space at the beginning of every output the cli makes
      say ''
      # adds space at the end of every output the cli makes
      ObjectSpace.define_finalizer self, proc { puts '' }
    end
        
    desc 'config', 'Manage config settings'
    subcommand 'config', Derecho::CLI::Subcommand::Config

    desc 'lb', 'Manage load balancers'
    subcommand 'lb', Derecho::CLI::Subcommand::Lb

    desc 'srv', 'Manage servers'
    subcommand 'srv', Derecho::CLI::Subcommand::Srv
      
    desc 'init', 'Create a .derecho file in this directory'
    def init
      if File.exists? File.expand_path Derecho::Config.new.path
        say 'You have already initialized Derecho in this directory.'
        say ''
        Derecho::CLI::Subcommand::Config.new.show
      else
        Derecho::CLI::Subcommand::Config.new.setup
      end
    end
    
    map %w(-v --version) => :version
    desc 'version', 'Show version number'
    def version
      say "v#{Derecho::VERSION}"
    end
    
  end
end