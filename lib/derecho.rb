$:.unshift "#{File.dirname(__FILE__)}/../lib"

class Derecho; end

require 'derecho/version'
require 'derecho/config'
require 'derecho/rackspace'
require 'derecho/cli'