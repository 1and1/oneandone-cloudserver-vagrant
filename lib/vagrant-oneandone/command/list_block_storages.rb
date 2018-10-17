require 'vagrant-oneandone/command/utils'

module VagrantPlugins
  module OneAndOne
    module Command
      class ListBlockStorages < Vagrant.plugin('2', :command)
        include VagrantPlugins::OneAndOne::Command::Utils

        def execute
          options = OptionParser.new do |o|
            o.banner = I18n.t('vagrant_1and1.command.list_block_storages')
            o.separator ''
            o.separator 'Usage: vagrant oneandone blockstorages [<api_key>]'
            o.separator ''
          end

          argv = parse_options(options)
          return unless argv

          compute = fog_oneandone(argv[0])

          rows = []
          compute.list_block_storages.body.each do |blks|
            rows << [
              blks['id'],
              blks['size'],
              blks['state'],
              blks['description'],
              blks['datacenter']['country_code'],
              blks['name'],
              blks['creation_date'],
              blks['server'] ? blks['server']['id'] : ''
            ]
          end

          display_table(@env, ['ID', 'Size', 'State', 'Description', 'Data Center', 'Name', 'Creation Date', 'Server'], rows)
        end
      end
    end
  end
end
