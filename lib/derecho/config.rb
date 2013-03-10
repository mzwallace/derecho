module Derecho
  
  class Config < Hash
    
    attr_accessor :path, :settings
    
    def initialize(config = nil)
      self.merge!(load_from_file(config)) if config.is_a?(String)
      self.merge!(config) if config.is_a?(Hash)
    end    
    
    def load_from_file(path)
      file = File.expand_path(path)
      
      if File.exists?(file)
        YAML.load_file(file)
      else
        raise "#{file} could not be found"
      end
    end
  
  end
  
end