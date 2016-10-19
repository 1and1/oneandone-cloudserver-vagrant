require 'vagrant-oneandone/command/utils'

module VagrantPlugins
  module OneAndOne
    module Command
      class ListIPs < Vagrant.plugin('2', :command)
        include VagrantPlugins::OneAndOne::Command::Utils

        def execute
          options = OptionParser.new do |o|
            o.banner = I18n.t('vagrant_1and1.command.list_public_ips')
            o.separator ''
            o.separator 'Usage: vagrant oneandone ips [<api_key>]'
            o.separator ''
          end

          argv = parse_options(options)
          return unless argv

          compute = fog_oneandone(argv[0])

          rows = []
          compute.list_public_ips.body.each do |ip|
            dhcp = ip['is_dhcp'] ? 'yes' : 'no'
            assigned = ip['assigned_to'] ? ip['assigned_to']['name'] : '-'
            rows << [
              ip['id'],
              ip['ip'],
              dhcp,
              ip['state'],
              ip['datacenter']['country_code'],
              assigned
            ]
          end

          display_table(
            @env,
            ['ID', 'IP Address', 'DHCP', 'State', 'Data Center', 'Owner'],
            rows
          )
        end
      end
    end
  end
end
