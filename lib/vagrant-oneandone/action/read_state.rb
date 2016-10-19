require 'log4r'

module VagrantPlugins
  module OneAndOne
    module Action
      class ReadState
        def initialize(app, _env)
          @app    = app
          @logger = Log4r::Logger.new('vagrant_1and1::action::read_state')
        end

        def call(env)
          env[:machine_state_id] = read_state(env[:oneandone_compute], env[:machine])
          @app.call(env)
        end

        def read_state(oneandone, machine)
          return :not_created if machine.id.nil?

          state = begin
                    oneandone.status(machine.id).body['state'].downcase.to_sym
                  rescue
                    nil
                  end

          if state.nil? || state == :removing
            @logger.info(I18n.t('vagrant_1and1.not_created'))
            return :not_created
          end

          case state
          when :configuring, :powered_on, :powering_on, :deploying
            return :active
          when :powered_off, :powering_off
            return :off
          end

          # unknown state?
          state
        end
      end
    end
  end
end
