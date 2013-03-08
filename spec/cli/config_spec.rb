require 'helper'
require 'derecho/cli/config'

describe Derecho do

  before :each do
    @config = Derecho::CLI::Config.new
    @config.file_path = 'spec/.test'
  end

  describe "::CLI::Config" do

    it "should be an instance of Derecho::CLI::Config" do
      @config.should be_an_instance_of Derecho::CLI::Config
    end

    it "should error if no config file is found" do
      @config.file_path = "nowayinhell"
      output = capture(:stdout) { @config.load }
      expect(output.chomp).to eq(@config.file_error.call(File.expand_path(@config.file_path)))
    end

    it "is able to load the config from a file" do
      @config.load_from_file
      expect(@config.settings['test']['a']).to eq('a_test')
    end

    it "should be able to get a specifc config setting" do
      expect(@config.get('test', 'a')).to eq('a_test')
    end

    it "should be able to get a group of config settings" do
      expect(@config.get('test')['a']).to eq('a_test')
    end

    it "should be able to set a specific config setting" do
      @config.set('test', 'a', 'changed')
      expect(@config.settings['test']['a']).to eq('changed')
    end

    it "should be able to set a group of config settings" do
      @config.set('test', {'a' => 'changed'})
      expect(@config.settings['test']['a']).to eq('changed')
    end

  end

end