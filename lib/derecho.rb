require 'derecho/version'
require 'rubygems'
require 'thor'
require 'fog'
require 'yaml'

module Derecho
  
  class Derecho < Thor
  
    attr_accessor :username, :api_key, :region, :lb
  
    desc 'lb', 'List all cloud load balancers'
    def lb
      load_config
  
      lb = Fog::Rackspace::LoadBalancers.new(
        :rackspace_api_key => @api_key,
        :rackspace_username => @username,
        :rackspace_lb_endpoint => "https://#{@region}.loadbalancers.api.rackspacecloud.com/v1.0/"
      )
  
      lb.list_load_balancers.body['loadBalancers'].each do |lb|
       puts "ID #{lb['id']}"
       puts "Name #{lb['name']}"
       puts "Port #{lb['port']}"
       puts 'IP Address(es) \r\n'
       puts lb['virtualIps'].map { |ip| ip['address'] }.join(',')
       puts "Status #{lb['status']}"
       puts "Node(s) #{lb['nodeCount']}"
       puts ''
      end
    end
  
    desc 'srv', 'List all cloud servers'
    def srv
      load_config
      cs = CloudServers::Connection.new(:username => @username, :api_key => @api_key, :region => @region)
      cs.servers.each do |cs|
        puts cs
=begin
        puts "ID #{lb[:id]}"
        puts "Name #{lb[:name]}"
        puts "Port #{lb[:port]}"
        puts "IP Address(es) " + lb[:virtualIps].map { |ip| ip[:address] }.join(",")
        puts "Status #{lb[:status]}"
        puts "Nodes #{lb[:nodeCount]}"
        puts ""
=end
      end
    end

=begin
    desc 'db', 'List all cloud databases'
    def db
      load_config
      lb = CloudLB::Connection.new(:username => @username, :api_key => @api_key, :region => @region)
  
      lb.list_load_balancers.each do |lb|
       puts "ID #{lb[:id]}"
       puts "Name #{lb[:name]}"
       puts "Port #{lb[:port]}"
       puts "IP Address(es) " + lb[:virtualIps].map { |ip| ip[:address] }.join(",")
       puts "Status #{lb[:status]}"
       puts "Nodes #{lb[:nodeCount]}"
       puts ""
      end
    end
  
    desc 'file', 'List all cloud files buckets'
    def file
      load_config
      lb = CloudLB::Connection.new(:username => @rs_username, :api_key => @api_key, :region => @region)
  
      lb.list_load_balancers.each do |lb|
       puts "ID #{lb[:id]}"
       puts "Name #{lb[:name]}"
       puts "Port #{lb[:port]}"
       puts "IP Address(es) " + lb[:virtualIps].map { |ip| ip[:address] }.join(",")
       puts "Status #{lb[:status]}"
       puts "Nodes #{lb[:nodeCount]}"
       puts ""
      end
    end
=end
    private
  
    def load_config
      config = YAML.load_file(File.expand_path('~/.derecho'))
      config = YAML.load_file('.derecho') unless config
  
      unless config and config['username'] and config['api_key'] and config['region']
        puts 'Could not locate configuration information in your .derecho file'
        puts 'Place one in your home directory or the current directory'
        exit
      end
  
      @config = config
    end
  
  end

end
