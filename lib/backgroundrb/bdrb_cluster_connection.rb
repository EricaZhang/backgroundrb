# class stores connections to BackgrounDRb servers in a cluster manner
module BackgrounDRb
  class ClusterConnection
    attr_accessor :backend_connections,:config,:cache

    def initialize
      @bdrb_servers = []
      @backend_connections = []
      establish_connections
      @round_robin = (0...@backend_connections.length).to_a
    end

    def initialize_memcache

    end

    # initialize all backend server connections
    def establish_connections
      if t_servers = BDRB_CONFIG[:client]
        connections = t_servers.split(',')
        connections.each do |conn_string|
          ip = conn_string.split(':')[0]
          port = conn_string.split(':')[1].to_i
          @bdrb_servers << OpenStruct.new(:ip => ip,:port => port)
        end
      else
        @bdrb_servers << OpenStruct.new(:ip => BDRB_CONFIG[:backgroundrb][:ip],:port => BDRB_CONFIG[:backgroundrb][:port].to_i)
      end
      @bdrb_servers.each_with_index do |connection_info,index|
        @backend_connections << Connection.custom_connection(connection_info.ip,connection_info.port)
      end
    end # end of method establish_connections

    def worker(worker_name,worker_key = nil)
      chosen = choose_server
      chosen.worker(worker_name,worker_key)
    end

    def new_worker options = {}
      chosen = choose_server
      chosen.new_worker(options)
    end

    def choose_server
      if @round_robin.empty?
        @round_robin = (0...@backend_connections.length).to_a
      end
      @backend_connections[@round_robin.shift]
    end
  end # end of ClusterConnection
end # end of Module BackgrounDRb
