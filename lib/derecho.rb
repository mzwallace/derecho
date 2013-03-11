$:.unshift "#{File.dirname(__FILE__)}/../lib"
require 'fog'
require 'derecho/thor'

class Derecho; end

require 'derecho/version'
require 'derecho/config'