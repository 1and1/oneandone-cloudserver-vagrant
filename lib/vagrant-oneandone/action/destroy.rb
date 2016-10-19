require 'log4r'

module VagrantPlugins
  module OneAndOne
    module Action
      class Destroy
        def initialize(app, _env)
          @app    = app
          @logger = Log4r::Logger.new('vagrant_1and1::action::destroy')
        end

        def call(env)
          compute = env[:oneandone_compute]
          server_id = env[:machine].id
          server = begin
                     compute.servers.get(server_id)
                   rescue
                     nil
                   end

          if server.nil?
            @logger.warn "Unable to find server #{server_id}..."
            env[:ui].warn(I18n.t('vagrant_1and1.errors.instance_not_found'))
            env[:machine].id = nil
          else
            @logger.info "Deleting server #{server_id}..."
            env[:ui].info(I18n.t('vagrant_1and1.wait_deleting_server'))

            # wait until the server is ready to be deleted
            result = begin
                       server.wait_for { ready? }
                     rescue
                       false
                     end

            if result
              result = begin
                         server.destroy
                       rescue
                         false
                       end

              if result
                loop do
                  begin
                    compute.get_server(server_id)
                  rescue
                    break
                  end
                  sleep 5
                end
                env[:machine].id = nil
                env[:ui].info(I18n.t('vagrant_1and1.server_deleted'))
              else
                @logger.warn "Unable to delete server #{server_id}..."
                env[:ui].warn(I18n.t('vagrant_1and1.errors.could_not_delete'))
              end
            else
              @logger.warn "Unable to delete server #{server_id}..."
              env[:ui].warn(I18n.t('vagrant_1and1.errors.could_not_delete'))
            end
          end

          @app.call(env)
        end
      end
    end
  end
end
