module Derecho

  module CLI

    class Config < Thor

      attr_accessor :settings, :settings_path, :file_path, :file_error

      def initialize(args=[], options={}, config={})
        super

        @file_path  = '~/.derecho'
        @file_error = Proc.new { |file| 'Could not locate file %s' % file }
      end

      desc 'show [account]? [key]?', 'List all config settings'
      def show(account = nil, key = nil)
        load_from_file unless @settings

        puts "Read from: #{@settings_path}"
        puts ''

        if account.nil?
          @settings.each do |name, account|
            puts "#{name}:"
            account.each do |key, value|
              puts "  #{key}:\t#{value}"
            end
            puts ''
          end
          puts ''
        else
          if key.nil?
            puts @settings[account]
          else
            puts @settings[account][key]
          end
        end
      end

      desc 'set [account] [key]? [value]?', 'Set a config value'
      def set(account, key, value = nil)
        load_from_file unless @settings
        if value.nil? then @settings[account] = key else @settings[account][key] = value end
      end

      no_tasks do

        def get(account, key = nil)
          load_from_file unless @settings
          if key.nil? then @settings[account] else @settings[account][key] end
        end

        #desc 'load [path]', 'Load the config file'
        def load(path = @file_path)
          begin
            load_from_file(path)
            puts "Config loaded successfully."
            puts ""
          rescue
            puts @file_error.call(File.expand_path(path))
            puts ""
          end
        end

        def load_from_file(path = @file_path)
          path   = File.expand_path(path)
          name   = File.basename(path)
          config = YAML.load_file(path) if File.exists?(path)
          config = YAML.load_file(name) if File.exists?(name) and !config

          raise @file_error.call(path) unless config
          @settings = config
          @settings_path = path
        end

      end

    end

  end

end
