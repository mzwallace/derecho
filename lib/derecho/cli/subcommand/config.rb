class Derecho
  class CLI < Derecho::Thor
    module Subcommand
      class Config < Derecho::Thor

        attr_accessor :config
      
        def initialize *args
          super
          @config = Derecho::Config.new
        end
      
        desc 'show [*keys]', 'Print groups or specific config settings'
        def show *keys
          check
          @config.read
        
          say "Read from: #{@config.path}"
          say ''
          
          if keys.any?
            settings = keys.inject(@config.settings, &:fetch)
            say settings
          else
            say @config.settings.to_yaml
          end
        end

        desc 'set [*keys] [value]', 'Set a config value (i.e. set accounts rackspace username my_username)'
        def set *keys
          check
          @config.read
        
          # figure out the hash from the array input
          hash = keys.reverse.inject { |value, key| { key => value } }
        
          # deep merge it with current config
          deep_merge!(@config.settings, hash)
        
          # write to file
          @config.write
        
          # output what they have changed
          say hash.to_yaml.sub('---', '')
        end
      
        desc 'setup', 'This will create / overwrite your .derecho file'
        def setup
          if @config.exists?
            unless yes? 'You already have a .derecho file in this directory, do you want to overwrite it?'
              exit
            end
          end
        
          rackspace_username = ask 'Enter Rackspace Username:'
          rackspace_api_key  = ask 'Enter Rackspace API Key:'
          rackspace_region   = ask 'Enter Rackspace Region:'
                
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
            unless @config.exists?
              if yes? 'There is no .derecho file in this directory, would you like to setup one now?'
                setup
              else
                say 'To continue you must setup a .derecho file in this directory.'
                exit
              end
            end
          end
        
          # THANK YOU RAILS!
        
          def deep_merge hash, other_hash
            hash = hash.clone
            deep_merge! hash, other_hash
          end
        
          def deep_merge! hash, other_hash
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
end
