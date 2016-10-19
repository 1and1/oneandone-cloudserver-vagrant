module VagrantPlugins
  module OneAndOne
    class ConfigResolver
      def initialize(env)
        @logger  = Log4r::Logger.new('vagrant_1and1::action::config_resolver')
        @compute = env[:oneandone_compute]
        @provider_config = env[:machine].provider_config
      end

      def resolve_fixed_instance_size(env)
        @logger.info 'Obtaining fixed-instance list'

        env[:ui].info(I18n.t('vagrant_1and1.finding_fixed_instance_size'))

        sizes = @compute.list_fixed_servers

        @logger.info "Finding size matching '#{@provider_config.fixed_size}'"

        size = find_matching(sizes.body, %w(id name), @provider_config.fixed_size)

        raise Errors::NoMatchingFixedSizeError unless size
        size['id']
      end

      def resolve_appliance(env)
        @logger.info 'Obtaining server appliances'

        env[:ui].info(I18n.t('vagrant_1and1.finding_appliance'))

        appliances = @compute.list_server_appliances(q: @provider_config.appliance)

        @logger.info "Finding server appliance matching '#{@provider_config.appliance}'"

        app = find_matching(appliances.body, %w(id name), @provider_config.appliance)

        raise Errors::NoMatchingApplianceError unless app
        raise Errors::UnsupportedApplianceError if 'linux'.casecmp(app['os_family']) != 0
        app['id']
      end

      def resolve_datacenter(env)
        @logger.info 'Obtaining data centers'

        env[:ui].info(I18n.t('vagrant_1and1.finding_datacenter'))

        datacenters = @compute.list_datacenters

        @logger.info "Finding data center matching '#{@provider_config.datacenter}'"

        dc = find_matching(datacenters.body, %w(id country_code), @provider_config.datacenter)

        raise Errors::NoMatchingDataCenterError unless dc
        dc['id']
      end

      def resolve_public_ip(env)
        # do nothing unless IP is set
        if @provider_config.ip
          @logger.info 'Obtaining public IPs'

          env[:ui].info(I18n.t('vagrant_1and1.finding_public_ip'))

          public_ips = @compute.list_public_ips

          @logger.info "Finding public IP matching '#{@provider_config.ip}'"

          ip = find_matching(public_ips.body, %w(id ip), @provider_config.ip)

          raise Errors::NoMatchingPublicIPAddressError unless ip

          raise Errors::IPAddressInUseError if ip['assigned_to']

          ip['id']
        end
      end

      def resolve_ssh_key(env)
        private_key = env[:machine].config.ssh.private_key_path
        private_key = private_key[0] if private_key.is_a?(Array)
        private_key = File.expand_path(private_key, env[:machine].env.root_path)
        OneAndOne.public_key(private_key)
      end

      private

      def find_matching(collection, keys, value)
        collection.each do |item|
          keys.each do |key|
            return item if value.casecmp(item[key]) == 0
          end
        end
        @logger.error "No item key '#{value}' found in collection #{collection}"
        nil
      end
    end
  end
end
