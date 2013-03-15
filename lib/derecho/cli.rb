$:.unshift "#{File.dirname(__FILE__)}/../../lib"
require 'derecho'
require 'derecho/thor'
require 'derecho/sub'
require 'derecho/view'

class Derecho
  class CLI < Derecho::Thor
    
    desc 'config', 'Manage config settings'
    subcommand 'config', Derecho::Sub::Config

    desc 'lb', 'Manage cloud load balancers'
    subcommand 'lb', Derecho::Sub::Lb

    desc 'srv', 'Manage cloud servers'
    subcommand 'srv', Derecho::Sub::Srv
      
    desc 'init', 'Create a .derecho file in this directory'
    def init
      if File.exists?(File.expand_path("#{Dir.pwd}/.derecho"))
        puts ''
        puts 'You have already initialized Derecho in this directory'
        Derecho::Sub::Config.new.show
      else
        Derecho::Sub::Config.new.setup
      end
    end
    
    map %w(-v --version) => :version
    desc 'version', 'Show version number'
    def version
      puts "v#{Derecho::VERSION}"
    end
    
  end
end