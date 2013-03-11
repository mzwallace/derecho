require 'helper'
require 'derecho/cli/config'

describe Derecho do

  let(:hash) { {'test' => {'a' => 'a_test', 'b' => 'b_test', 'c' => 'c_test'}} } 
  let(:path) { 'spec/tmp/.test' }
  
  before :each do
    # create the tmp dir
    dir = File.dirname(path)
    Dir.mkdir(dir) unless Dir.exists?(dir)
    
    # create the test yaml file
    yaml = hash.to_yaml.sub('---', '')
    File.open(File.expand_path(path), 'w+') {|f| f.write(yaml) }
    
    # create an instance of the config
    @config = Derecho::CLI::Config.new
    @config.config.path = path;
  end
  
  after :each do 
    # delete the .test file
    File.delete(path) if File.exists?(path)
    
    # delete the tmp dir
    dir = File.dirname(path)
    Dir::delete(dir) if Dir.exists?(dir)
    
  end

  describe "::CLI::Config" do

    it "should be an instance of Derecho::CLI::Config" do
      @config.should be_an_instance_of Derecho::CLI::Config
    end

    it "should be able to show all settings" do
      output = capture(:stdout) { @config.show }
      expect(output).to eq("\nRead from: #{File.expand_path(path)}\n" + hash.to_yaml.sub('---', '') + "\n")
    end
=begin
    it "should be able to get a group of config settings" do
      output = capture(:stdout) { @config.show(['test', 'a']) }
      expect(output).to eq("\nRead from: #{File.expand_path(path)}\n" + hash.to_yaml.sub('---', '') + "\n")
    end
    
    it "should be able to set a specific config setting" do
      @config.set('test', 'a', 'changed')
      expect(@config.settings['test']['a']).to eq('changed')
    end

    it "should be able to set a group of config settings" do
      @config.set('test', {'a' => 'changed'})
      expect(@config.settings['test']['a']).to eq('changed')
    end
=end
  end

end