require 'derecho'

class Derecho
  module Rackspace; end
end

Dir.glob("#{Dir.pwd}/lib/derecho/rackspace/*", &method(:require))