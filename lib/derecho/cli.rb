require 'derecho'
require 'thor'
require 'fog'
require 'yaml'

class Derecho::CLI < Thor

  attr_accessor :username, :api_key, :region, :lb

  desc 'lb', 'List all cloud load balancers'
  def lb
    load_config unless @config
    rackspace = @config['rackspace']
    
    lb = Fog::Rackspace::LoadBalancers.new(
      :rackspace_api_key => rackspace['api_key'],
      :rackspace_username => rackspace['username'],
      :rackspace_lb_endpoint => "https://#{rackspace['region']}.loadbalancers.api.rackspacecloud.com/v1.0/"
    )

    lb.list_load_balancers.body['loadBalancers'].each do |lb|
     puts "Name    #{lb['name']} #{lb['id']}"
     puts "Port    #{lb['port']}"
     puts 'IP(s)   ' + lb['virtualIps'].map { |ip| ip['address'] }.join(',')
     puts "Status  #{lb['status']}"
     puts "Node(s) #{lb['nodeCount']}"
     puts ''
    end
  end

  desc 'srv', 'List all cloud servers'
  def srv
    load_config unless @config
    rackspace = @config['rackspace']
    
    cs = Fog::Compute::RackspaceV2.new(
      :rackspace_username => rackspace['username'], 
      :rackspace_api_key => rackspace['api_key'], 
      :rackspace_endpoint => "https://#{rackspace['region']}.servers.api.rackspacecloud.com/v2"
    )
    
    cs.list_servers.body['servers'].each do |cs|
      puts "Name   #{cs['name']} #{cs['id']}"
      puts "Flavor #{cs['flavor']['id']}"
      puts "Image  #{cs['image']['id']}"
      puts "IPs    #{cs['addresses']['public'][1]['addr']} (public) #{cs['addresses']['private'][0]['addr']} (private)"
      puts "Status #{cs['status']}" if cs['status'] == "ACTIVE"
      puts "Status #{cs['status']} #{cs['progress']}%" if cs['status'] != "ACTIVE"
      puts ""
    end
  end
  
  private

  def load_config
    config = YAML.load_file(File.expand_path('~/.derecho'))
    config = YAML.load_file('.derecho') unless config
    
    unless (config['rackspace']['username'] and config['rackspace']['api_key'] and config['rackspace']['region'])
      puts 'Could not locate configuration information in your .derecho file'
      puts 'Place one in your home directory or the current directory'
      exit
    end

    @config = config
  end

end