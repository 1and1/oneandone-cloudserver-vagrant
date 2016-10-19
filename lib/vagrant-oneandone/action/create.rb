require 'log4r'

require 'vagrant-oneandone/config_resolver'

module VagrantPlugins
  module OneAndOne
    module Action
      class Create
        def initialize(app, env)
          @app = app
          @machine = env[:machine]
          @compute = env[:oneandone_compute]
          @logger = Log4r::Logger.new('vagrant_1and1::action::create')
          @resolver = ConfigResolver.new(env)
        end

        def call(env)
          # send new server request
          server = @compute.servers.create(
            name: @machine.provider_config.name || @machine.config.vm.hostname,
            description: @machine.provider_config.description,
            fixed_instance_id: @resolver.resolve_fixed_instance_size(env),
            appliance_id: @resolver.resolve_appliance(env),
            datacenter_id: @resolver.resolve_datacenter(env),
            rsa_key: @resolver.resolve_ssh_key(env),
            ip_id: @resolver.resolve_public_ip(env),
            firewall_id: @machine.provider_config.firewall_id,
            load_balancer_id: @machine.provider_config.load_balancer_id,
            monitoring_policy_id: @machine.provider_config.monitoring_policy_id
          )

          env[:ui].info I18n.t('vagrant_1and1.creating_server')

          # set timeout
          Fog.timeout = if @machine.provider_config.timeout.nil?
                          1800
                        else
                          @machine.provider_config.timeout
                        end
          # wait for the request to complete
          server.wait_for { ready? }

          @machine.id = server.id
          env[:ui].info(" -- Server Name: #{server.name}")
          env[:ui].info(" -- Server Size: #{@machine.provider_config.fixed_size}")
          env[:ui].info(" -- Server Appliance: #{@machine.provider_config.appliance}")
          env[:ui].info(" -- Data Center: #{@machine.provider_config.datacenter}")
          ip = begin
                 server.ips[0]['ip']
               rescue
                 ''
               end
          env[:ui].info(" -- Public IP: #{ip}")

          env[:ui].info(I18n.t('vagrant_1and1.ready'))

          @app.call(env)
        end

        def recover(env)
          return if env['vagrant.error'].is_a?(Vagrant::Errors::VagrantError)

          terminate(env) if @machine.state.id != :not_created
        end

        def terminate(env)
          destroy_env = env.dup
          destroy_env.delete(:interrupted)
          destroy_env[:config_validate] = false
          destroy_env[:force_confirm_destroy] = true
          env[:action_runner].run(Actions.destroy, destroy_env)
        end
      end
    end
  end
end
