module VagrantPlugins
  module OneAndOne
    module Action
      class GetState
        def initialize(app, env)
          @app = app
          @machine = env[:machine]
        end

        def call(env)
          env[:machine_state] = @machine.state.id
          @app.call(env)
        end
      end
    end
  end
end
