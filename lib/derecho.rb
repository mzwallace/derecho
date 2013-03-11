$:.unshift "#{File.dirname(__FILE__)}/../lib"
require 'fog'
require 'derecho/thor'

class Derecho
  class CLI < Derecho::Thor; end
end

require 'derecho/version'
require 'derecho/config'