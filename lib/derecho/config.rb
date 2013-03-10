module Derecho
  
  class ConfigFileNotFoundError < Error; end
  
  # an instance of this class can be accessed like a hash for set and get 
  class Config < Hash
    
    attr_accessor :path, :settings
    
    def initialize(config = nil)
      # if argument is not nil load it from a hash or config file location
      unless config.nil?
        self.merge!(config.is_a?(Hash) ? config : read(config))
      end
      
      # if config file path is nil set it to the default
      @path ||= '#{Dir.pwd}/.derecho'
    end
    
    def read(path=nil)
      # if no argument then read the default path
      path ||= @path
      
      file = File.expand_path(path)
      
      if File.exists?(file)
        YAML.load_file(file)
        @path = path
      else
        raise ConfigFileNotFoundError
      end
    end
    
    def write
      # overwrite current file
      file = File.open(@path, 'w+')
      file.puts self.to_yaml.sub('---', '')
      file.close
    end
  
  end
  
end