require 'vagrant'

# require "vagrant-oneandone/action"

module VagrantPlugins
  module OneAndOne
    class Provider < Vagrant.plugin('2', :provider)
      def initialize(machine)
        @machine = machine
      end

      def action(name)
        action_method = "action_#{name}"
        return Action.send(action_method) if Action.respond_to?(action_method)
        nil
      end

      def ssh_info
        env = @machine.action('read_ssh_info')
        env[:machine_ssh_info]
      end

      def state
        env = @machine.action('read_state')

        state_id = env[:machine_state_id]

        # Get the short and long description
        short = I18n.t("vagrant_1and1.states.short_#{state_id}")
        long  = I18n.t("vagrant_1and1.states.long_#{state_id}")

        # Return the MachineState object
        Vagrant::MachineState.new(state_id, short, long)
      end

      def to_s
        '1&1 Cloud Server'
      end
    end
  end
end
