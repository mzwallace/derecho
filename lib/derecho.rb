require 'thor'
require 'fog'

$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

module Derecho; end
require 'derecho/version'
require 'derecho/config'