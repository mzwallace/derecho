class Derecho
  module Sub
    class Srv < Derecho::Thor
      
      desc 'list', 'List all cloud servers'
      def list
        Derecho::Sub.config_check
        cs = Derecho::Rackspace::Server.new
        cs.get_servers.each do |cs|
          puts "Name   #{cs['name']} #{cs['id']}"
          puts "Flavor #{cs['flavor']['id']}"
          puts "Image  #{cs['image']['id']}"
          puts "IP(s)  #{cs['addresses']['public'][1]['addr']} (public) #{cs['addresses']['private'][0]['addr']} (private)"
          puts "Status #{cs['status']}" if cs['status'] == 'ACTIVE'
          puts "Status #{cs['status']} #{cs['progress']}%" if cs['status'] != 'ACTIVE'
          puts ''
        end
      end

    end
  end
end