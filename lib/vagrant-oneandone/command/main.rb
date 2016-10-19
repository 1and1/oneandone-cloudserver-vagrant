require 'vagrant-oneandone/action'

module VagrantPlugins
  module OneAndOne
    module Command
      class Main < Vagrant.plugin('2', :command)
        def self.synopsis
          I18n.t('vagrant_1and1.command.synopsis')
        end

        def initialize(argv, env)
          @main_args, @sub_command, @sub_args = split_main_and_subcommand(argv)

          @subcommands = Vagrant::Registry.new

          @subcommands.register(:appliances) do
            require File.expand_path('../list_appliances', __FILE__)
            ListAppliances
          end
          @subcommands.register(:datacenters) do
            require File.expand_path('../list_datacenters', __FILE__)
            ListDatacenters
          end
          @subcommands.register(:firewalls) do
            require File.expand_path('../list_firewalls', __FILE__)
            ListFirewalls
          end
          @subcommands.register(:ips) do
            require File.expand_path('../list_ips', __FILE__)
            ListIPs
          end
          @subcommands.register(:loadbalancers) do
            require File.expand_path('../list_load_balancers', __FILE__)
            ListLoadBalancers
          end
          @subcommands.register(:monitors) do
            require File.expand_path('../list_monitor_policies', __FILE__)
            ListMonitorPolicies
          end
          @subcommands.register(:servers) do
            require File.expand_path('../list_servers', __FILE__)
            ListServers
          end
          @subcommands.register(:sizes) do
            require File.expand_path('../list_sizes', __FILE__)
            ListSizes
          end

          super(argv, env)
        end

        def execute
          if @main_args.include?('-h') || @main_args.include?('--help')
            return help
          end

          command_class = @subcommands.get(@sub_command.to_sym) if @sub_command
          return help if !command_class || !@sub_command

          # Initialize and execute the command class
          command_class.new(@sub_args, @env).execute
        end

        def help
          opts = OptionParser.new do |o|
            o.banner = 'Usage: vagrant oneandone <subcommand> [<api_key>]'
            o.separator ''
            o.separator I18n.t('vagrant_1and1.command.available_subcommands')

            keys = []
            @subcommands.each { |key| keys << key.to_s }

            keys.sort.each { |key| o.separator "     #{key}" }

            o.separator ''
            o.separator I18n.t('vagrant_1and1.command.help_subcommands') +
                        ' `vagrant oneandone <subcommand> -h`'
          end

          @env.ui.info(opts.help)
        end
      end
    end
  end
end
