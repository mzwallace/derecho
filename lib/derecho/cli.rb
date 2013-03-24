require 'derecho'
require 'derecho/thor'
require 'derecho/cli/subcommand'
require 'derecho/cli/view'

class Derecho
  class CLI < Derecho::Thor
        
    desc 'config', 'Manage config settings'
    subcommand 'config', Subcommand::Config

    desc 'lb', 'Manage load balancers'
    subcommand 'lb', Subcommand::Lb

    desc 'srv', 'Manage servers'
    subcommand 'srv', Subcommand::Srv
      
    desc 'init', 'Create a .derecho file in this directory'
    def init
      if Config.new.exists?
        say 'You have already initialized Derecho in this directory.'
        say ''
        Subcommand::Config.new.show
      else
        Subcommand::Config.new.setup
      end
    end
    
    map %w(-v --version) => :version
    desc 'version', 'Show version number'
    def version
      say "v#{VERSION}"
    end
    
  end
end