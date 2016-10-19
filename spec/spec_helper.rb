require 'vagrant'

Dir['lib/**/*.rb'].each do |file|
  require_string = file.match(%r{lib\/(.*)\.rb})[1]
  require require_string
end

RSpec.configure do |config|
  VagrantPlugins::OneAndOne.init_i18n

  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true

  config.mock_with :rspec do |c|
    c.yield_receiver_to_any_instance_implementation_blocks = true
  end
  config.raise_errors_for_deprecations!

  config.before(:each) do
    def call
      described_class.new(@app, @env).call(@env)
    end

    provider_config = double(api_key: 'dummy')
    vm_config = double(
      vm: double('config_vm',
                 box: nil,
                 hostname: nil,
                 communicator: nil),
      validate: []
    )
    @app = double 'app', call: true
    @machine = double 'machine',
                      provider_config: provider_config,
                      config: vm_config,
                      state: double('state', id: nil),
                      communicate: double('communicator'),
                      ssh_info: {},
                      data_dir: Pathname.new(''),
                      id: nil

    @env = {
      machine: @machine,
      ui: double('ui', info: nil, output: nil)
    }
  end
end
