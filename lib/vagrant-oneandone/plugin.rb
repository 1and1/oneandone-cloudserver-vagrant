begin
  require 'vagrant'
rescue LoadError
  raise 'The Vagrant 1&1 plugin must be run within Vagrant.'
end

module VagrantPlugins
  module OneAndOne
    class Plugin < Vagrant.plugin('2')
      name 'OneAndOne'
      description <<-DESC
        This plugin installs a provider that allows Vagrant to manage
        1&1 Cloud servers.
      DESC

      config(:oneandone, :provider) do
        require_relative 'config'
        Config
      end

      provider(:oneandone, parallel: true) do
        OneAndOne.init_i18n

        require_relative 'provider'
        Provider
      end

      command('oneandone') do
        OneAndOne.init_i18n

        require_relative 'command/main'
        Command::Main
      end
    end
  end
end
