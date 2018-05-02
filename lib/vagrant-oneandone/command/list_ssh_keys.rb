require 'vagrant-oneandone/command/utils'

module VagrantPlugins
  module OneAndOne
    module Command
      class ListSshKeys < Vagrant.plugin('2', :command)
        include VagrantPlugins::OneAndOne::Command::Utils

        def execute
          options = OptionParser.new do |o|
            o.banner = I18n.t('vagrant_1and1.command.list_ssh_keys')
            o.separator ''
            o.separator 'Usage: vagrant oneandone sshkeys [<api_key>]'
            o.separator ''
          end

          argv = parse_options(options)
          return unless argv

          compute = fog_oneandone(argv[0])

          rows = []
          compute.list_ssh_keys.body.each do |ssh_key|
            rows << [
              ssh_key['id'],
              ssh_key['name'],
              ssh_key['description'],
              ssh_key['state'],
              ssh_key['servers'] ? ssh_key['servers'].to_s : '',
              ssh_key['md5'],
              ssh_key['public_key'].to_s,
              ssh_key['creation_date']
            ]
          end

          display_table(@env, ['ID', 'Name', 'Description', 'State', 'Servers', 'MD5', 'Public Key', 'Creation Date'], rows)
        end
      end
    end
  end
end
