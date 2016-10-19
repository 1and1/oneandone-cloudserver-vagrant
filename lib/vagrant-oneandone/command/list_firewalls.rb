require 'vagrant-oneandone/command/utils'

module VagrantPlugins
  module OneAndOne
    module Command
      class ListFirewalls < Vagrant.plugin('2', :command)
        include VagrantPlugins::OneAndOne::Command::Utils

        def execute
          options = OptionParser.new do |o|
            o.banner = I18n.t('vagrant_1and1.command.list_firewalls')
            o.separator ''
            o.separator 'Usage: vagrant oneandone firewalls [<api_key>]'
            o.separator ''
          end

          argv = parse_options(options)
          return unless argv

          compute = fog_oneandone(argv[0])

          rows = []
          compute.firewalls.all.each do |fw|
            rows << [fw.id, fw.name]
          end

          display_table(@env, %w(ID Name), rows)
        end
      end
    end
  end
end
