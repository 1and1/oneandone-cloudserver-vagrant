require 'vagrant'

module VagrantPlugins
  module OneAndOne
    class Config < Vagrant.plugin('2', :config)
      attr_accessor :api_key
      attr_accessor :name
      attr_accessor :description
      attr_accessor :fixed_size
      attr_accessor :datacenter
      attr_accessor :appliance
      attr_accessor :password
      attr_accessor :firewall_id
      attr_accessor :ip
      attr_accessor :load_balancer_id
      attr_accessor :monitoring_policy_id
      attr_accessor :timeout

      def initialize
        @api_key              = UNSET_VALUE
        @name                 = UNSET_VALUE
        @description          = UNSET_VALUE
        @fixed_size           = UNSET_VALUE
        @datacenter           = UNSET_VALUE
        @appliance            = UNSET_VALUE
        @password             = UNSET_VALUE
        @firewall_id          = UNSET_VALUE
        @ip                   = UNSET_VALUE
        @load_balancer_id     = UNSET_VALUE
        @monitoring_policy_id = UNSET_VALUE
        @timeout              = UNSET_VALUE
      end

      def finalize!
        @api_key              = ENV['ONEANDONE_API_KEY'] if @api_key == UNSET_VALUE
        @name                 = nil if @name == UNSET_VALUE
        @password             = nil if @password == UNSET_VALUE
        @appliance            = 'ubuntu1404-64std' if @appliance == UNSET_VALUE
        @datacenter           = 'US' if @datacenter == UNSET_VALUE
        @fixed_size           = 'M' if @fixed_size == UNSET_VALUE
        @timeout              = nil if @timeout == UNSET_VALUE
        @ip                   = nil if @ip == UNSET_VALUE
        @firewall_id          = nil if @firewall_id == UNSET_VALUE
        @load_balancer_id     = nil if @load_balancer_id == UNSET_VALUE
        @monitoring_policy_id = nil if @monitoring_policy_id == UNSET_VALUE
        @description          = nil if @description == UNSET_VALUE
      end

      def validate(machine)
        errors = []
        errors << I18n.t('vagrant_1and1.config.api_key_required') unless @api_key

        key = machine.config.ssh.private_key_path
        key = key[0] if key.is_a?(Array)
        if !key
          errors << I18n.t('vagrant_1and1.config.private_key')
        elsif !File.file?(File.expand_path("#{key}.pub", machine.env.root_path))
          errors << I18n.t('vagrant_1and1.config.public_key', key: "#{key}.pub")
        end

        { 'OneAndOne Provider' => errors }
      end
    end
  end
end
