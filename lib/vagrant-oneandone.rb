require 'pathname'
require 'vagrant-oneandone/plugin'
require 'vagrant-oneandone/version'

module VagrantPlugins
  module OneAndOne
    lib_path = Pathname.new(File.expand_path('../vagrant-oneandone', __FILE__))
    autoload :Action, lib_path.join('action')
    autoload :Errors, lib_path.join('errors')

    def self.source_root
      @source_root ||= Pathname.new(File.expand_path('../../', __FILE__))
    end

    def self.public_key(private_key_path)
      File.read("#{private_key_path}.pub")
    rescue
      raise Errors::PublicKeyError, key: "#{private_key_path}.pub"
    end

    def self.init_i18n
      I18n.load_path << File.expand_path('locales/en.yml', source_root)
      I18n.reload!
    end
  end
end
