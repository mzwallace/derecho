$:.unshift "#{File.dirname(__FILE__)}/../../lib"
require 'derecho'
require 'derecho/thor'
require 'derecho/sub'
Dir.glob("#{Dir.pwd}/lib/derecho/sub/*", &method(:require))

class Derecho
  class CLI < Derecho::Thor

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
      
  end
end