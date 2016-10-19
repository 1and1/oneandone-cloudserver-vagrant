require 'vagrant-oneandone/command/utils'

module VagrantPlugins
  module OneAndOne
    module Command
      class ListDatacenters < Vagrant.plugin('2', :command)
        include VagrantPlugins::OneAndOne::Command::Utils

        def execute
          options = OptionParser.new do |o|
            o.banner = I18n.t('vagrant_1and1.command.list_datacenters')
            o.separator ''
            o.separator 'Usage: vagrant oneandone datacenters [<api_key>]'
            o.separator ''
          end

          argv = parse_options(options)
          return unless argv

          compute = fog_oneandone(argv[0])

          rows = []
          compute.list_datacenters.body.each do |dc|
            rows << [
              dc['id'],
              dc['location'],
              dc['country_code']
            ]
          end

          display_table(@env, ['ID', 'Location', 'Country Code'], rows)
        end
      end
    end
  end
end
