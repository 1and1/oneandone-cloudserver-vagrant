require 'vagrant-oneandone/command/utils'

module VagrantPlugins
  module OneAndOne
    module Command
      class ListAppliances < Vagrant.plugin('2', :command)
        include VagrantPlugins::OneAndOne::Command::Utils

        def execute
          options = OptionParser.new do |o|
            o.banner = I18n.t('vagrant_1and1.command.list_appliances')
            o.separator ''
            o.separator 'Usage: vagrant oneandone appliances [<api_key>]'
            o.separator ''
          end

          argv = parse_options(options)
          return unless argv

          compute = fog_oneandone(argv[0])

          rows = []
          compute.list_server_appliances.body.each do |app|
            rows << [
              app['id'],
              app['name'],
              app['type'],
              app['os'],
              app['os_architecture']
            ]
          end

          display_table(@env, %w(ID Name Type OS Architecture), rows)
        end
      end
    end
  end
end
