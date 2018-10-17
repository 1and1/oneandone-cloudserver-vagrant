shared_examples 'provider/commands' do |_provider, _options|
  include_context 'acceptance'

  context 'commands' do
    it 'run oneandone list commands' do
      status('Test: listing appliances')
      result = execute('vagrant', 'oneandone', 'appliances')
      expect(result).to exit_with(0)
      expect(result.stdout).to match(/ubuntu1604-64std/)

      status('Test: listing block storages')
      result = execute('vagrant', 'oneandone', 'blockstorages')
      expect(result).to exit_with(0)

      status('Test: listing data centers')
      result = execute('vagrant', 'oneandone', 'datacenters')
      expect(result).to exit_with(0)
      expect(result.stdout).to match(/Germany/)

      status('Test: listing firewalls')
      result = execute('vagrant', 'oneandone', 'firewalls')
      expect(result).to exit_with(0)
      expect(result.stdout).to match(/Linux/)

      status('Test: listing public IP addresses')
      result = execute('vagrant', 'oneandone', 'ips')
      expect(result).to exit_with(0)
      expect(result.stdout).to match(/DHCP/)

      status('Test: listing load balancers')
      result = execute('vagrant', 'oneandone', 'loadbalancers')
      expect(result).to exit_with(0)
      expect(result.stdout).to match(/Method/)

      status('Test: listing monitoring policies')
      result = execute('vagrant', 'oneandone', 'monitors')
      expect(result).to exit_with(0)
      expect(result.stdout).to match(/Agent/)

      status('Test: listing servers')
      result = execute('vagrant', 'oneandone', 'servers')
      expect(result).to exit_with(0)
      expect(result.stdout).to match(/Data\sCenter/)

      status('Test: listing fixed-serves sizes')
      result = execute('vagrant', 'oneandone', 'sizes')
      expect(result).to exit_with(0)
      expect(result.stdout).to match(/5XL/)

      status('Test: listing SSH keys')
      result = execute('vagrant', 'oneandone', 'sshkeys')
      expect(result).to exit_with(0)
    end
  end
end
