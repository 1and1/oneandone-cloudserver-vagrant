require 'spec_helper'

describe VagrantPlugins::OneAndOne::Action do
  def run(action)
    Vagrant::Action::Runner.new.run described_class.send("action_#{action}"), @env
  end

  before :each do
    @machine.stub(:name).and_return('test-name')
  end

  describe 'action: up' do
    it 'should validate config' do
      Vagrant::Action::Builtin::ConfigValidate.any_instance.should_receive(:call)
      run(:up)
    end
    it 'should set up connection' do
      VagrantPlugins::OneAndOne::Action::Connect1And1.any_instance.should_receive(:call)
      run(:up)
    end
    it 'should check the machine state' do
      VagrantPlugins::OneAndOne::Action::GetState.any_instance.should_receive(:call)
      run(:up)
    end
    it 'should create the server' do
      @machine.state.stub(:id).and_return(:not_created)
      VagrantPlugins::OneAndOne::Action::Create.any_instance.should_receive(:call)
      run(:up)
    end
  end

  describe 'action: reload' do
    it 'should validate config' do
      Vagrant::Action::Builtin::ConfigValidate.any_instance.should_receive(:call)
      run(:reload)
    end
    it 'should set up connection' do
      VagrantPlugins::OneAndOne::Action::Connect1And1.any_instance.should_receive(:call)
      run(:reload)
    end
    it 'should check the machine state' do
      VagrantPlugins::OneAndOne::Action::GetState.any_instance.should_receive(:call)
      run(:reload)
    end
  end

  describe 'action: provision' do
    it 'should validate config' do
      Vagrant::Action::Builtin::ConfigValidate.any_instance.should_receive(:call)
      run(:provision)
    end
    it 'should check the machine state' do
      VagrantPlugins::OneAndOne::Action::GetState.any_instance.should_receive(:call)
      run(:provision)
    end
    it 'should run provisioning' do
      @machine.state.stub(:id).and_return(:active)
      Vagrant::Action::Builtin::Provision.any_instance.should_receive(:call)
      run(:provision)
    end
  end

  describe 'action: halt' do
    it 'should validate config' do
      Vagrant::Action::Builtin::ConfigValidate.any_instance.should_receive(:call)
      run(:halt)
    end
    it 'should set up connection' do
      VagrantPlugins::OneAndOne::Action::Connect1And1.any_instance.should_receive(:call)
      run(:halt)
    end
    it 'should check the machine state' do
      VagrantPlugins::OneAndOne::Action::GetState.any_instance.should_receive(:call)
      run(:halt)
    end
    it 'should stop the machine' do
      @machine.state.stub(:id).and_return(:active)
      VagrantPlugins::OneAndOne::Action::PowerOff.any_instance.should_receive(:call)
      run(:halt)
    end
  end

  describe 'action: ssh-config' do
    it 'should validate config' do
      Vagrant::Action::Builtin::ConfigValidate.any_instance.should_receive(:call)
      run(:read_ssh_info)
    end
    it 'should set up connection' do
      VagrantPlugins::OneAndOne::Action::Connect1And1.any_instance.should_receive(:call)
      run(:read_ssh_info)
    end
    it 'should get the server IP' do
      VagrantPlugins::OneAndOne::Action::ReadSSHInfo.any_instance.should_receive(:call)
      run(:read_ssh_info)
    end
  end

  describe 'action: ssh' do
    it 'should validate config' do
      Vagrant::Action::Builtin::ConfigValidate.any_instance.should_receive(:call)
      run(:ssh)
    end
    it 'should set up connection' do
      VagrantPlugins::OneAndOne::Action::Connect1And1.any_instance.should_receive(:call)
      run(:ssh)
    end
    it 'should check the machine state' do
      VagrantPlugins::OneAndOne::Action::GetState.any_instance.should_receive(:call)
      run(:ssh)
    end
    it 'should ssh to the machine' do
      @machine.state.stub(:id).and_return(:active)
      Vagrant::Action::Builtin::SSHExec.any_instance.should_receive(:call)
      run(:ssh)
    end
  end

  describe 'action: ssh run' do
    it 'should validate config' do
      Vagrant::Action::Builtin::ConfigValidate.any_instance.should_receive(:call)
      run(:ssh_run)
    end
    it 'should set up connection' do
      VagrantPlugins::OneAndOne::Action::Connect1And1.any_instance.should_receive(:call)
      run(:ssh_run)
    end
    it 'should check the machine state' do
      VagrantPlugins::OneAndOne::Action::GetState.any_instance.should_receive(:call)
      run(:ssh_run)
    end
    it 'should ssh to the machine and run command' do
      @machine.state.stub(:id).and_return(:active)
      Vagrant::Action::Builtin::SSHRun.any_instance.should_receive(:call)
      run(:ssh_run)
    end
  end

  describe 'action: status' do
    it 'should validate config' do
      Vagrant::Action::Builtin::ConfigValidate.any_instance.should_receive(:call)
      run(:read_state)
    end
    it 'should set up connection' do
      VagrantPlugins::OneAndOne::Action::Connect1And1.any_instance.should_receive(:call)
      run(:read_state)
    end

    it 'should get the server state' do
      VagrantPlugins::OneAndOne::Action::ReadState.any_instance.should_receive(:call)
      run(:read_state)
    end
  end

  describe 'action: destroy' do
    it 'should validate config' do
      Vagrant::Action::Builtin::ConfigValidate.any_instance.should_receive(:call)
      run(:destroy)
    end
    it 'should set up connection' do
      @machine.state.stub(:id).and_return(:active)
      @env[:ui].stub(:ask) { 'y' }
      VagrantPlugins::OneAndOne::Action::Connect1And1.any_instance.should_receive(:call)
      run(:destroy)
    end
    it 'should delete the server' do
      @machine.state.stub(:id).and_return(:active)
      @env[:ui].stub(:ask) { 'y' }
      VagrantPlugins::OneAndOne::Action::Destroy.any_instance.should_receive(:call)
      run(:destroy)
    end
  end
end
