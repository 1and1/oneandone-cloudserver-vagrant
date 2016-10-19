require 'vagrant-oneandone/command/utils'

module VagrantPlugins
  module OneAndOne
    module Command
      class ListLoadBalancers < Vagrant.plugin('2', :command)
        include VagrantPlugins::OneAndOne::Command::Utils

        def execute
          options = OptionParser.new do |o|
            o.banner = I18n.t('vagrant_1and1.command.list_load_balancers')
            o.separator ''
            o.separator 'Usage: vagrant oneandone loadbalancers [<api_key>]'
            o.separator ''
          end

          argv = parse_options(options)
          return unless argv

          compute = fog_oneandone(argv[0])

          rows = []
          compute.list_load_balancers.body.each do |lb|
            rows << [
              lb['id'],
              lb['name'],
              lb['ip'],
              lb['method'],
              lb['state'],
              lb['datacenter']['country_code']
            ]
          end

          display_table(
            @env,
            ['ID', 'Name', 'IP Address', 'Method', 'State', 'Data Center'],
            rows
          )
        end
      end
    end
  end
end
