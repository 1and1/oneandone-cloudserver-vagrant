require 'spec_helper'

describe VagrantPlugins::OneAndOne::ConfigResolver do
  subject { described_class.new(env) }

  let(:config) do
    double('config').tap do |config|
      config.stub(:api_key) { 'dummy-key' }
      config.stub(:name) { 'test-test' }
    end
  end

  let(:ssh_config) do
    double('ssh_config').tap do |config|
      config.stub(:username) { nil }
      config.stub(:port) { nil }
    end
  end

  let(:machine_config) do
    double('machine_config').tap do |config|
      config.stub(:ssh) { ssh_config }
    end
  end

  let(:machine_env) do
    double('machine_env').tap do |me|
      me.stub(:root_path) { 'path/to/root' }
    end
  end

  let(:env) do
    {}.tap do |env|
      env[:ui] = double('ui')
      env[:ui].stub(:info).with(anything)
      env[:machine] = double('machine')
      env[:machine].stub(:provider_config) { config }
      env[:machine].stub(:data_dir) { '/data/dir' }
      env[:machine].stub(:config) { machine_config }
      env[:machine].stub(:env) { machine_env }
      env[:oneandone_compute] = double('oneandone_compute')
    end
  end

  let(:appliances) do
    double('appliances').tap do |a|
      a.stub(:body) do
        [
          { 'id' => 'abc123', 'name' => 'dummy1', 'os_family' => 'Linux' },
          { 'id' => 'xyw987', 'name' => 'dummy2', 'os_family' => 'Linux' },
          { 'id' => 'ap4562', 'name' => 'dummy3', 'os_family' => 'Windows' }
        ]
      end
    end
  end

  let(:flavors) do
    double('flavors').tap do |f|
      f.stub(:body) do
        [
          { 'id' => 'dummy_id1', 'name' => 'dummy_size1' },
          { 'id' => 'dummy_id2', 'name' => 'dummy_size2' },
          { 'id' => 'dummy_id3', 'name' => 'dummy_size3' }
        ]
      end
    end
  end

  let(:datacenters) do
    double('datacenters').tap do |f|
      f.stub(:body) do
        [
          { 'id' => 'dc_id1', 'country_code' => 'earth' },
          { 'id' => 'dc_id2', 'country_code' => 'mars' },
          { 'id' => 'dc_id2', 'country_code' => 'jupiter' }
        ]
      end
    end
  end

  let(:ips) do
    double('ips').tap do |a|
      a.stub(:body) do
        [
          { 'id' => 'ip_id1', 'ip' => '1.1.1' },
          { 'id' => 'ip_id2', 'ip' => '2.2.2', 'assigned_to' => 'something' },
          { 'id' => 'ip_id3', 'ip' => '3.3.3' }
        ]
      end
    end
  end

  describe 'resolve_appliance' do
    context 'with ID' do
      it 'returns the specified server appliance ID' do
        config.stub(:appliance) { 'xyw987' }
        env[:oneandone_compute].stub(:list_server_appliances) { appliances }
        subject.resolve_appliance(env).should eq('xyw987')
      end
    end
    context 'with name' do
      it 'returns the specified server appliance ID' do
        config.stub(:appliance) { 'dummy1' }
        env[:oneandone_compute].stub(:list_server_appliances) { appliances }
        subject.resolve_appliance(env).should eq('abc123')
      end
    end
    context 'with invalid appliance identifier' do
      it 'raises an error' do
        config.stub(:appliance) { 'nonexisting' }
        env[:oneandone_compute].stub(:list_server_appliances) { appliances }
        expect { subject.resolve_appliance(env) }
          .to raise_error(VagrantPlugins::OneAndOne::Errors::NoMatchingApplianceError)
      end
    end
    context 'with unsupported server appliance' do
      it 'raises an error' do
        config.stub(:appliance) { 'dummy3' }
        env[:oneandone_compute].stub(:list_server_appliances) { appliances }
        expect { subject.resolve_appliance(env) }
          .to raise_error(VagrantPlugins::OneAndOne::Errors::UnsupportedApplianceError)
      end
    end
  end

  describe 'resolve_fixed_instance_size' do
    context 'with ID' do
      it 'returns the specified fixed-server size ID' do
        config.stub(:fixed_size) { 'dummy_id2' }
        env[:oneandone_compute].stub(:list_fixed_servers) { flavors }
        subject.resolve_fixed_instance_size(env).should eq('dummy_id2')
      end
    end
    context 'with name' do
      it 'returns the specified fixed-server size ID' do
        config.stub(:fixed_size) { 'dummy_size1' }
        env[:oneandone_compute].stub(:list_fixed_servers) { flavors }
        subject.resolve_fixed_instance_size(env).should eq('dummy_id1')
      end
    end
    context 'with invalid flavor identifier' do
      it 'raises an error' do
        config.stub(:fixed_size) { 'dummy' }
        env[:oneandone_compute].stub(:list_fixed_servers) { flavors }
        expect { subject.resolve_fixed_instance_size(env) }
          .to raise_error(VagrantPlugins::OneAndOne::Errors::NoMatchingFixedSizeError)
      end
    end
  end

  describe 'resolve_datacenter' do
    context 'with ID' do
      it 'returns the specified data center ID' do
        config.stub(:datacenter) { 'earth' }
        env[:oneandone_compute].stub(:list_datacenters) { datacenters }
        subject.resolve_datacenter(env).should eq('dc_id1')
      end
    end
    context 'with name' do
      it 'returns the specified data center ID' do
        config.stub(:datacenter) { 'mars' }
        env[:oneandone_compute].stub(:list_datacenters) { datacenters }
        subject.resolve_datacenter(env).should eq('dc_id2')
      end
    end
    context 'with invalid data center identifier' do
      it 'raises an error' do
        config.stub(:datacenter) { 'saturn' }
        env[:oneandone_compute].stub(:list_datacenters) { datacenters }
        expect { subject.resolve_datacenter(env) }
          .to raise_error(VagrantPlugins::OneAndOne::Errors::NoMatchingDataCenterError)
      end
    end
  end

  describe 'resolve_public_ip' do
    context 'with ID' do
      it 'returns the specified public IP ID' do
        config.stub(:ip) { 'ip_id3' }
        env[:oneandone_compute].stub(:list_public_ips) { ips }
        subject.resolve_public_ip(env).should eq('ip_id3')
      end
    end
    context 'with name' do
      it 'returns the specified public IP ID' do
        config.stub(:ip) { '1.1.1' }
        env[:oneandone_compute].stub(:list_public_ips) { ips }
        subject.resolve_public_ip(env).should eq('ip_id1')
      end
    end
    context 'with invalid public IP identifier' do
      it 'raises an error' do
        config.stub(:ip) { '4.4.4' }
        env[:oneandone_compute].stub(:list_public_ips) { ips }
        expect { subject.resolve_public_ip(env) }
          .to raise_error(VagrantPlugins::OneAndOne::Errors::NoMatchingPublicIPAddressError)
      end
    end
    context 'with assigned public IP' do
      it 'raises an error' do
        config.stub(:ip) { '2.2.2' }
        env[:oneandone_compute].stub(:list_public_ips) { ips }
        expect { subject.resolve_public_ip(env) }
          .to raise_error(VagrantPlugins::OneAndOne::Errors::IPAddressInUseError)
      end
    end
  end

  describe 'resolve_ssh_key' do
    context 'with private_key_path provided' do
      it 'returns ssh key' do
        ssh_config.stub(:private_key_path) do
          File.expand_path('../../../spec/keys/test_id_rsa', __FILE__)
        end
        subject.resolve_ssh_key(env).should include('oneandone provider test key')
      end
    end
    context 'with invalid private_key_path' do
      it 'raises an error' do
        ssh_config.stub(:private_key_path) { '/path/to/private_key' }
        expect { subject.resolve_ssh_key(env) }.to raise_error
      end
    end
  end
end
