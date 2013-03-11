$:.unshift(File.join(File.dirname(__FILE__), "../..", "lib"))
require 'derecho'

module Derecho
  
  class Config
    
    @@default_path = "#{Dir.pwd}/.derecho"
    
    attr_accessor :path, :settings
    
    def initialize(config = nil)
      # if argument is not nil load it from a hash or config file
      unless config.nil?
        config.is_a?(Hash) ? @settings = config : read(config)
      end
      
      # if config file path is nil set it to the default
      @path ||= @@default_path
      @settings ||= {}
    end
    
    def read(path=nil)
      # if no argument then read and set path
      path ||= @path
      
      @path = File.expand_path(path)
      @settings = YAML.load_file(@path)
    end
    
    def write(path=nil)
      # if no argument then read the default path
      path ||= @path
      
      # overwrite current file
      file = File.open(@path, 'w+')
      file.puts @settings.to_yaml.sub('---', '')
      file.close
    end
    
    # allows you to access the instance of this class like an array but with extending Hash or Array
    def [](key)
      @settings[key]
    end
  
  end
  
end