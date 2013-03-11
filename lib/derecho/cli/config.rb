module Derecho

  module CLI

    class Config < Thor

      attr_accessor :config

      def initialize(args=[], options={}, config={})
        super
        
        @config = Derecho::Config.new
      end

      desc 'show [*keys]', 'List all config settings'
      def show(*keys)
        @config.read
        
        puts ''
        puts "Read from: #{@config.path}"
        
        if keys.any?
          settings = keys.inject(@config.settings, &:fetch)
          puts settings.to_yaml.sub('---', '')
        else
          puts @config.settings.to_yaml.sub('---', '')
        end
        
        puts ''
      end

      desc 'set [*keys] [value]', 'Set a config value (i.e. set accounts rackspace username my_username)'
      def set(*keys)
        @config.read
        
        # figure out the hash from the array input
        hash = keys.reverse.inject { |value, key| { key => value } }
        
        # deep merge it with current config
        deep_merge!(@config.settings, hash)
        
        # write to file
        @config.write
        
        # output what they have changed
        puts hash.to_yaml.sub('---', '')
        puts ''
      end
      
      desc 'setup', 'This will create / overwrite your .derecho file'
      def setup
        rackspace_username = ask 'Rackspace Username?'
        rackspace_api_key  = ask 'Rackspace API Key?'
        rackspace_region   = ask 'Rackspace Region?'
        
        @config.settings = { 
          'accounts' => {
            'rackspace' => {
              'username' => rackspace_username,
              'api_key' => rackspace_api_key,
              'region' => rackspace_region
            }
          }
        }
        
        @config.write
        show
      end
      
      no_tasks do
        
        def check
          if yes?('There is no .derecho file in this directory, would you like to setup one now?')
            Derecho::CLI::Config.new.setup
          end
        end
        
        # THANK YOU RAILS!
        
        def deep_merge(hash, other_hash)
          hash = hash.clone
          deep_merge!(hash, other_hash)
        end
        
        def deep_merge!(hash, other_hash)
          other_hash.each_pair do |k,v|
            tv = hash[k]
            hash[k] = tv.is_a?(Hash) && v.is_a?(Hash) ? deep_merge(tv, v) : v
          end
          
          hash
        end
      
      end

    end

  end

end
