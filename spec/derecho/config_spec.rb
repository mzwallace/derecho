require 'spec_helper'
require 'derecho/config'

describe Derecho do

  let(:hash) { {'test' => {'a' => 'a_test', 'b' => 'b_test', 'c' => 'c_test'}} }
  let(:path) { 'spec/tmp/.test' }

  before :each do
    # create tmp dir
    dir = File.dirname(path)
    Dir.mkdir(dir) unless Dir.exists?(dir)
    
    # create .test file
    yaml = hash.to_yaml.sub('---', '')
    File.open(path, 'w+') {|f| f.write(yaml) }
    
    # create a new instance of Config to work with
    @config = Derecho::Config.new(hash)
  end

  after :each do
    # delete the .test file
    File.delete(path) if File.exists?(path)
    
    # delete the tmp dir
    dir = File.dirname(path)
    Dir::delete(dir) if Dir.exists?(dir)
  end

  describe "::Config" do

    it "should be an instance of Derecho::Config" do
      @config.should be_an_instance_of Derecho::Config
    end

    it "should initialize correctly when no arguments are passed" do
      @config = Derecho::Config.new
      @config.settings.should be_empty
    end

    it "should initialize correctly when a String is passed as the argument" do
      expect(@config.settings).to eq(YAML.load_file(File.expand_path(path)))
    end

    it "should initialize correctly when a Hash is passed as the argument" do
      @config = Derecho::Config.new(hash)
      expect(@config.settings).to eq(hash)
    end

    it "should raise error when no file is found" do
      File.delete(path) if File.exists?(path)
      lambda { Derecho::Config.new(path) }.should raise_error
    end

    it "should be accessible like a Hash" do
      expect(@config['test']['a']).to eq('a_test')
      @config['test']['a'] = 'testing'
      expect(@config['test']['a']).to eq('testing')
    end

  end

end