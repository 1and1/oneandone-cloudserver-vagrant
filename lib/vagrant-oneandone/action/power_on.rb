module VagrantPlugins
  module OneAndOne
    module Action
      class PowerOn
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new('vagrant_1and1::action::power_on')
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
            @logger.info "Starting server #{env[:machine].id}..."
            env[:ui].info(I18n.t('vagrant_1and1.starting_server'))

            server.on

            server.wait_for { ready? }

            env[:ui].info(I18n.t('vagrant_1and1.powered_on'))
          end

          @app.call(env)
        end
      end
    end
  end
end
