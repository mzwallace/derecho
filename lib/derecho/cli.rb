$:.unshift "#{File.dirname(__FILE__)}/../../lib"
require 'derecho'
require 'derecho/thor'
require 'derecho/sub'
require 'derecho/view'

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
    subcommand 'config', Derecho::Sub::Config

    desc 'lb', 'Manage cloud load balancers'
    subcommand 'lb', Derecho::Sub::Lb

    desc 'srv', 'Manage cloud servers'
    subcommand 'srv', Derecho::Sub::Srv
      
    desc 'init', 'Create a .derecho file in this directory'
    def init
      if File.exists? File.expand_path "#{Dir.pwd}/.derecho"
        say 'You have already initialized Derecho in this directory'
        Derecho::Sub::Config.new.show
      else
        Derecho::Sub::Config.new.setup
      end
    end
    
    map %w(-v --version) => :version
    desc 'version', 'Show version number'
    def version
      say "v#{Derecho::VERSION}"
    end
    
  end
end