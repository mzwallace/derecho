$:.unshift "#{File.dirname(__FILE__)}/../lib"
require 'fog'

class Derecho; end

require 'derecho/version'
require 'derecho/config'
require 'derecho/rackspace'
#require 'derecho/cli'