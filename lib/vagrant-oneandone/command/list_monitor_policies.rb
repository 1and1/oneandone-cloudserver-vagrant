require 'vagrant-oneandone/command/utils'

module VagrantPlugins
  module OneAndOne
    module Command
      class ListMonitorPolicies < Vagrant.plugin('2', :command)
        include VagrantPlugins::OneAndOne::Command::Utils

        def execute
          options = OptionParser.new do |o|
            o.banner = I18n.t('vagrant_1and1.command.list_monitor_policies')
            o.separator ''
            o.separator 'Usage: vagrant oneandone monitors [<api_key>]'
            o.separator ''
          end

          argv = parse_options(options)
          return unless argv

          compute = fog_oneandone(argv[0])

          rows = []
          compute.monitoring_policies.all.each do |mp|
            rows << [mp.id, mp.name, mp.email, mp.state, mp.agent ? 'yes' : 'no']
          end

          display_table(@env, %w(ID Name Email State Agent), rows)
        end
      end
    end
  end
end
