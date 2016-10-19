shared_examples 'provider/general' do |provider, options|
  unless options[:box]
    raise ArgumentError,
          "box option must be specified for provider: #{provider}"
  end

  include_context 'acceptance'

  before do
    environment.skeleton('general')
    assert_execute('vagrant', 'box', 'add', 'dummy', options[:box])
  end

  after do
    # Make sure we always run destroy
    execute('vagrant', 'destroy', '--force')
  end

  context 'after box add' do
    it 'can manage machine lifecycle' do
      status('Test: creating machine')
      result = execute('vagrant', 'up', "--provider=#{provider}")
      expect(result).to exit_with(0)
      expect(result.stdout).to match(/ready/)
      expect(result.stdout).to match(/foobar/)

      status('Test: checking machine status')
      result = execute('vagrant', 'status')
      expect(result).to exit_with(0)
      expect(result.stdout).to match(/active/)

      status('Test: showing ssh config')
      result = execute('vagrant', 'ssh-config')
      expect(result).to exit_with(0)
      expect(result.stdout).to match(/User\sroot/)

      status('Test: machine is available by ssh')
      result = execute('vagrant', 'ssh', '-c', 'echo foo')
      expect(result).to exit_with(0)
      expect(result.stdout).to match(/foo\n$/)

      status('Test: reloading machine')
      result = execute('vagrant', 'reload')
      expect(result).to exit_with(0)
      expect(result.stdout).to match(/rebooted/)

      status('Test: halting machine')
      result = execute('vagrant', 'halt')
      expect(result).to exit_with(0)
      expect(result.stdout).to match(/stopped/)

      status('Test: starting machine')
      result = execute('vagrant', 'up')
      expect(result).to exit_with(0)
      expect(result.stdout).to match(/running/)

      status('Test: provisioning machine')
      assert_execute('vagrant', 'provision')
      expect(result).to exit_with(0)

      status('Test: destroying machine')
      result = execute('vagrant', 'destroy', '--force')
      expect(result).to exit_with(0)
      expect(result.stdout).to match(/destroyed/)
    end
  end
end
