require 'vagrant-oneandone/command/utils'

module VagrantPlugins
  module OneAndOne
    module Command
      class ListServers < Vagrant.plugin('2', :command)
        include VagrantPlugins::OneAndOne::Command::Utils

        def execute
          options = OptionParser.new do |o|
            o.banner = I18n.t('vagrant_1and1.command.list_servers')
            o.separator ''
            o.separator 'Usage: vagrant oneandone servers [<api_key>]'
            o.separator ''
          end

          argv = parse_options(options)
          return unless argv

          compute = fog_oneandone(argv[0])

          rows = []
          compute.servers.all.each do |s|
            rows << [s.id, s.name, s.status['state'], s.datacenter['country_code']]
          end

          display_table(@env, ['ID', 'Name', 'State', 'Data Center'], rows)
        end
      end
    end
  end
end
