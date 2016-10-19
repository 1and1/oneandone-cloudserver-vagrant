require 'vagrant-oneandone/provider'

describe VagrantPlugins::OneAndOne::Provider do
  before :each do
    @provider = VagrantPlugins::OneAndOne::Provider.new :machine
  end

  describe 'to string' do
    it 'should output the provider name' do
      @provider.to_s.should eq('1&1 Cloud Server')
    end
  end
end
