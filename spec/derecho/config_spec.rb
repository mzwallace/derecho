require 'helper'
require 'derecho/config'

describe Derecho do

  let(:hash) { {'test' => {'a' => 'a_test', 'b' => 'b_test', 'c' => 'c_test'}} } 
  let(:path) { 'spec/tmp/.test' }
  
  before :each do
    yaml = hash.to_yaml.sub('---', '')
    File.open(File.expand_path(path), 'w+') {|f| f.write(yaml) }
    @config = Derecho::Config.new(hash)
  end
  
  after :each do 
    File.delete(path)
  end

  describe "::Config" do
    
    it "should be an instance of Derecho::Config" do 
      @config.should be_an_instance_of Derecho::Config
    end
    
    it "should initialize correctly when no arguments are passed" do
      @config = Derecho::Config.new
      @config.should be_empty
    end
    
    it "should initialize correctly when a String is passed as the argument" do
      expect(@config).to eq(YAML.load_file(File.expand_path(path)))
    end
    
    it "should initialize correctly when a Hash is passed as the argument" do 
      @config = Derecho::Config.new(hash)
      expect(@config).to eq(hash)
    end
  end

end