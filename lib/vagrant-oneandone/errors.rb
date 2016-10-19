module VagrantPlugins
  module OneAndOne
    module Errors
      class OneAndOneError < Vagrant::Errors::VagrantError
        error_namespace('vagrant_1and1.errors')
      end

      class IPAddressInUseError < OneAndOneError
        error_key(:ip_address_already_in_use)
      end

      class NoApiKeyError < OneAndOneError
        error_key(:missing_api_key)
      end

      class NoMatchingFixedSizeError < OneAndOneError
        error_key(:no_matching_fixed_size)
      end

      class NoMatchingApplianceError < OneAndOneError
        error_key(:no_matching_appliance)
      end

      class NoMatchingDataCenterError < OneAndOneError
        error_key(:no_matching_datacenter)
      end

      class NoMatchingPublicIPAddressError < OneAndOneError
        error_key(:no_matching_public_ip)
      end

      class PublicKeyError < OneAndOneError
        error_key(:ssh_key_not_found)
      end

      class RsyncError < OneAndOneError
        error_key(:rsync)
      end

      class UnsupportedApplianceError < OneAndOneError
        error_key(:unsupported_appliance)
      end
    end
  end
end
