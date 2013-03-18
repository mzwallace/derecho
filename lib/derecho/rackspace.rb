require 'derecho'
require 'fog'

class Derecho
  module Rackspace; end
end

Dir.glob("#{File.dirname(__FILE__)}/../../lib/derecho/rackspace/*", &method(:require))