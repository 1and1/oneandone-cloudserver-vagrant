require 'log4r'

module VagrantPlugins
  module OneAndOne
    module Action
      class ReadSSHInfo
        def initialize(app, _env)
          @app    = app
          @logger = Log4r::Logger.new('vagrant_1and1::action::read_ssh_info')
        end

        def call(env)
          env[:machine_ssh_info] = read_ssh_info(env[:oneandone_compute], env[:machine])

          @app.call(env)
        end

        def read_ssh_info(oneandone, machine)
          return nil if machine.id.nil?

          # Find the server
          server = begin
                     oneandone.servers.get(machine.id)
                   rescue
                     nil
                   end
          if server.nil?
            # The server can't be found
            @logger.info("The server #{machine.id} couldn't be found.")
            machine.id = nil
            return nil
          end

          ip = begin
                 server.ips[0]['ip']
               rescue
                 nil
               end

          if ip.nil?
            @logger.warn('SSH is unavailable.')
            return nil
          end

          {
            host: ip,
            port: 22,
            username: 'root'
          }
        end
      end
    end
  end
end
