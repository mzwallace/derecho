require 'derecho'

class Derecho
  class Config
    
    attr_accessor :settings
    
    # simple cattr_accessor
    @@path = "#{Dir.pwd}/.derecho"
    def self.path; @@path; end
    def path; @@path; end
    def self.path= obj; @@path = obj; end
    def path= obj; @@path = obj; end
    
    def initialize config = {}
      config.is_a?(Hash) ? @settings = config : read(config) 
    end
    
    def read path = nil
      path ||= @@path
      @@path = File.expand_path path 
      @settings = YAML.load_file @@path
    end
    
    def write path = nil
      path ||= @@path
      @@path = File.expand_path path
      file = File.open @@path, 'w+'
      file.puts format @settings
      file.close
    end
    
    def [] key
      @settings[key]
    end
    
    def []= key, value
      @settings[key] = value
    end
    
    def exists?
      self.class.exists?
    end
    
    class << self
      
      def exists?
        File.exists? File.expand_path @@path
      end
      
      def format hash
        hash.to_yaml.sub('---', '').split('\n').map(&:rstrip).join('\n').strip
      end
    
    end
    
  end
end