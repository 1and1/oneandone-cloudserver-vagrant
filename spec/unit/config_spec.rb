require 'spec_helper'

describe VagrantPlugins::OneAndOne::Config do
  before :each do
    ENV.stub(:[] => nil)
  end

  describe 'defaults' do
    subject do
      super().tap(&:finalize!)
    end

    it 'should default to nil' do
      expect(subject.api_key).to be_nil
      expect(subject.name).to be_nil
      expect(subject.description).to be_nil
      expect(subject.password).to be_nil
      expect(subject.ip).to be_nil
      expect(subject.timeout).to be_nil
      expect(subject.firewall_id).to be_nil
      expect(subject.load_balancer_id).to be_nil
      expect(subject.monitoring_policy_id).to be_nil
    end

    it 'fixed size should default to M' do
      expect(subject.fixed_size).to eq('M')
    end

    it 'data center should default to US' do
      expect(subject.datacenter).to eq('US')
    end

    it 'appliance should default to ubuntu1404-64std' do
      expect(subject.appliance).to eq('ubuntu1404-64std')
    end
  end

  describe 'overriding defaults' do
    [:api_key, :name, :description, :password, :ip, :fixed_size,
     :timeout, :datacenter, :appliance, :firewall_id,
     :load_balancer_id, :monitoring_policy_id].each do |attribute|
      it "should not default #{attribute} if overridden" do
        subject.send("#{attribute}=".to_sym, 'dummy')
        subject.finalize!
        subject.send(attribute).should == 'dummy'
      end
    end
  end
end
