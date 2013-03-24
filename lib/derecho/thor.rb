require 'thor'

class Derecho
  class Thor < Thor
    
    def initialize *args
      super
      # adds space at the beginning of every output the cli makes
      say ''
      # adds space at the end of every output the cli makes
      ObjectSpace.define_finalizer self, proc { puts '' }
    end
    
    desc "help [command]", "Find help on a specific command"
    def help(task = nil, subcommand = false)
      task ? self.class.task_help(shell, task) : self.class.help(shell, subcommand)
    end
    
    class << self
      
      def subcommand_help(cmd)
        desc "help [command]", "Find help on a specific command"
        class_eval <<-RUBY
          def help(command = nil, subcommand = true); super; end
        RUBY
      end
      
    end
    
  end
end