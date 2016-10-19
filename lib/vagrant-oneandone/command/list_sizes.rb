require 'vagrant-oneandone/command/utils'

module VagrantPlugins
  module OneAndOne
    module Command
      class ListSizes < Vagrant.plugin('2', :command)
        include VagrantPlugins::OneAndOne::Command::Utils

        def execute
          options = OptionParser.new do |o|
            o.banner = I18n.t('vagrant_1and1.command.list_sizes')
            o.separator ''
            o.separator 'Usage: vagrant oneandone sizes [<api_key>]'
            o.separator ''
          end

          argv = parse_options(options)
          return unless argv

          compute = fog_oneandone(argv[0])

          rows = []
          compute.list_fixed_servers.body.each do |s|
            rows << [
              s['id'],
              s['name'],
              s['hardware']['ram'],
              s['hardware']['vcore'],
              s['hardware']['cores_per_processor'],
              s['hardware']['hdds'][0]['size']
            ]
          end

          display_table(
            @env,
            ['ID', 'Name', 'RAM (GB)', 'CPU No.', 'Cores per CPU', 'Disk Size (GB)'],
            rows
          )
        end
      end
    end
  end
end
