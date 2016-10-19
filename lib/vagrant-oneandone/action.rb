require 'pathname'

require 'vagrant/action/builder'

module VagrantPlugins
  module OneAndOne
    module Action
      include Vagrant::Action::Builtin

      action_root = Pathname.new(File.expand_path('../action', __FILE__))
      autoload :Create, action_root.join('create')
      autoload :Destroy, action_root.join('destroy')
      autoload :Connect1And1, action_root.join('connect_1and1')
      autoload :GetState, action_root.join('get_state')
      autoload :PowerOff, action_root.join('power_off')
      autoload :PowerOn, action_root.join('power_on')
      autoload :ReadSSHInfo, action_root.join('read_ssh_info')
      autoload :ReadState, action_root.join('read_state')
      autoload :Reload, action_root.join('reload')

      def self.action_destroy
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Call, GetState do |env, b1|
            if env[:machine_state] != :not_created
              b1.use Call, DestroyConfirm do |env2, b2|
                if env2[:result]
                  b2.use Connect1And1
                  b2.use Destroy
                  b2.use ProvisionerCleanup if defined?(ProvisionerCleanup)
                end
              end
            else
              env[:ui].info I18n.t('vagrant_1and1.not_created')
            end
          end
        end
      end

      def self.action_halt
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Connect1And1
          b.use Call, GetState do |env, b1|
            case env[:machine_state]
            when :active
              b1.use PowerOff
            when :off
              env[:ui].info I18n.t('vagrant_1and1.already_stopped')
            when :not_created
              env[:ui].info I18n.t('vagrant_1and1.not_created')
            end
          end
        end
      end

      def self.action_read_ssh_info
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Connect1And1
          b.use ReadSSHInfo
        end
      end

      # This action is called to read the state of the machine. The
      # resulting state is put into the `env[:machine_state_id]`.
      def self.action_read_state
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Connect1And1
          b.use ReadState
        end
      end

      def self.action_reload
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Connect1And1
          b.use Call, GetState do |env, b1|
            case env[:machine_state]
            when :active
              b1.use Reload
              b1.use Provision
            when :off
              env[:ui].info I18n.t('vagrant_1and1.states.long_off')
            when :not_created
              env[:ui].info I18n.t('vagrant_1and1.not_created')
            end
          end
        end
      end

      def self.action_provision
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Call, GetState do |env, b1|
            case env[:machine_state]
            when :active
              b1.use Provision
            when :off
              env[:ui].info I18n.t('vagrant_1and1.states.long_off')
            when :not_created
              env[:ui].info I18n.t('vagrant_1and1.not_created')
            end
          end
        end
      end

      def self.action_ssh
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Connect1And1
          b.use Call, GetState do |env, b1|
            case env[:machine_state]
            when :active
              b1.use SSHExec
            when :off
              env[:ui].info I18n.t('vagrant_1and1.states.long_off')
            when :not_created
              env[:ui].info I18n.t('vagrant_1and1.not_created')
            end
          end
        end
      end

      def self.action_ssh_run
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Connect1And1
          b.use Call, GetState do |env, b1|
            case env[:machine_state]
            when :active
              b1.use SSHRun
            when :off
              env[:ui].info I18n.t('vagrant_1and1.states.long_off')
            when :not_created
              env[:ui].info I18n.t('vagrant_1and1.not_created')
            end
          end
        end
      end

      def self.action_up
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Connect1And1
          b.use Call, GetState do |env, b1|
            case env[:machine_state]
            when :not_created
              b1.use Create
              b1.use Provision
            when :off
              b1.use PowerOn
              b1.use Provision
            else
              env[:ui].info I18n.t('vagrant_1and1.already_created')
            end
          end
        end
      end
    end
  end
end
