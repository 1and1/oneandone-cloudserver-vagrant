require 'fog-oneandone'
require 'log4r'

module VagrantPlugins
  module OneAndOne
    module Action
      class Connect1And1
        def initialize(app, _env)
          @app    = app
          @logger = Log4r::Logger.new('vagrant_1and1::action::connect_1and1')
        end

        def call(env)
          config   = env[:machine].provider_config
          api_key  = config.api_key

          params = {
            oneandone_api_key: api_key
          }

          env[:oneandone_compute] = Fog::Compute::OneAndOne.new params

          @app.call(env)
        end
      end
    end
  end
end
