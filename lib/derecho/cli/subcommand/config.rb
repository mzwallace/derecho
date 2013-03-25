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
            say Derecho::Config.prepare settings
          else
            say Derecho::Config.prepare @config.settings
          end
        end

        desc 'set [*keys] [value]', 'Set a config value (i.e. set accounts rackspace username my_username)'
        def set *keys
          check
          @config.read
          
          hash = keys.reverse.inject { |value, key| { key => value } }
          
          if yes? "#{Derecho::Config.prepare hash}\n\nWrite this to the config file?"
            deep_merge! @config.settings, hash
            @config.write
          else
            say ''
            say 'Canceled.'
          end
        end
      
        desc 'setup', 'This will create / overwrite your .derecho file'
        def setup
          if @config.exists?
            unless yes? 'You already have a .derecho file in this directory, do you want to overwrite it?'
              exit
            end
          end
          
          say ''
          username = ask 'Enter Rackspace Username:'
          api_key  = ask 'Enter Rackspace API Key:'
          region   = ask 'Enter Rackspace Region:'
                
          @config.settings = { 
            'accounts' => {
              'rackspace' => {
                'username' => username,
                'api_key'  => api_key,
                'region'   => region
              }
            }
          }
        
          @config.write
          say ''
          show
        end
      
        no_tasks do
        
          def check
            unless @config.exists?
              if yes? 'There is no .derecho file in this directory, would you like to setup one now?'
                setup
              else
                say ''
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
