
module VagrantPlugins
  module OneAndOne
    module Action
      class Reload
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new('vagrant_1and1::action::reload')
          @machine = env[:machine]
        end

        def call(env)
          compute = env[:oneandone_compute]
          server = begin
                     compute.servers.get(@machine.id)
                   rescue
                     nil
                   end

          if server.nil?
            @logger.warn "Unable to find server #{env[:machine].id}..."
            env[:ui].warn(I18n.t('vagrant_1and1.errors.instance_not_found'))
            env[:machine].id = nil
          else
            @logger.info "Restarting server #{env[:machine].id}..."
            env[:ui].info(I18n.t('vagrant_1and1.reloading_server'))

            # if needed, wait until the server is ready
            server.wait_for { ready? }

            if env[:force_halt]
              compute.change_status(server_id: server.id,
                                    action: 'REBOOT', method: 'HARDWARE')
            else
              server.reboot
            end

            server.wait_for { ready? }

            env[:ui].info(I18n.t('vagrant_1and1.rebooted'))
          end

          @app.call(env)
        end
      end
    end
  end
end
