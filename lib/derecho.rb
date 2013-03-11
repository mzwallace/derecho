$:.unshift "#{File.dirname(__FILE__)}/../lib"
require 'fog'
require 'thor'

class Derecho
  class CLI < Thor; end
end

require 'derecho/version'
require 'derecho/config'