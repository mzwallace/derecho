# adds ../lib to the load path
$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require 'rspec'
require 'derecho'

RSpec.configure do |config|

  def capture(stream)
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure
      eval("$#{stream} = #{stream.upcase}")
    end

    result
  end

end