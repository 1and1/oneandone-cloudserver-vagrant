# Test Results

## Functional Tests

```
rake spec:acceptance
Skipping: cli/version
Skipping: cli/box
Skipping: cli/plugin
Skipping: cli/init
Skipping: provider/oneandone/synced_folder/nfs
Skipping: provider/oneandone/synced_folder/rsync
Skipping: provider/oneandone/provisioner/chef-solo
Skipping: provider/oneandone/provisioner/puppet
Skipping: provider/oneandone/provisioner/shell
Skipping: provider/oneandone/provisioner/docker
Skipping: provider/oneandone/network/private_network
Skipping: provider/oneandone/network/forwarded_port
Skipping: provider/oneandone/synced_folder
Skipping: provider/oneandone/basic
Skipping: provider/oneandone/package

provider/oneandone/general
  it should behave like provider/general
    after box add
      can manage machine lifecycle
        Execute: vagrant box add dummy /home/nb/workspace/spc/oneandone-cloudserver-vagrant/box/dummy.box
        Test: creating machine
        Execute: vagrant up --provider=oneandone
        Test: checking machine status
        Execute: vagrant status
        Test: showing ssh config
        Execute: vagrant ssh-config
        Test: machine is available by ssh
        Execute: vagrant ssh -c echo foo
        Test: reloading machine
        Execute: vagrant reload
        Test: halting machine
        Execute: vagrant halt
        Test: starting machine
        Execute: vagrant up
        Test: provisioning machine
        Execute: vagrant provision
        Test: destroying machine
        Execute: vagrant destroy --force
        Execute: vagrant destroy --force
        can manage machine lifecycle

provider/oneandone/commands
  it should behave like provider/commands
    commands
      run oneandone list commands
        Test: listing appliances
        Execute: vagrant oneandone appliances
        Test: listing data centers
        Execute: vagrant oneandone datacenters
        Test: listing firewalls
        Execute: vagrant oneandone firewalls
        Test: listing public IP addresses
        Execute: vagrant oneandone ips
        Test: listing load balancers
        Execute: vagrant oneandone loadbalancers
        Test: listing monitoring policies
        Execute: vagrant oneandone monitors
        Test: listing servers
        Execute: vagrant oneandone servers
        Test: listing fixed-serves sizes
        Execute: vagrant oneandone sizes
        run oneandone list commands

Finished in 13 minutes 34 seconds
```

## Unit Tests

```
rake spec:unit
/root/.rbenv/versions/2.2.5/bin/ruby -S rspec

VagrantPlugins::OneAndOne::Action
  action: up
    should validate config
    should set up connection
    should check the machine state
    should create the server
  action: reload
    should validate config
    should set up connection
    should check the machine state
  action: provision
    should validate config
    should check the machine state
    should run provisioning
  action: halt
    should validate config
    should set up connection
    should check the machine state
    should stop the machine
  action: ssh-config
    should validate config
    should set up connection
    should get the server IP
  action: ssh
    should validate config
    should set up connection
    should check the machine state
    should ssh to the machine
  action: ssh run
    should validate config
    should set up connection
    should check the machine state
    should ssh to the machine and run command
  action: status
    should validate config
    should set up connection
    should get the server state
  action: destroy
    should validate config
    should set up connection
    should delete the server

VagrantPlugins::OneAndOne::ConfigResolver
  resolve_appliance
    with ID
      returns the specified server appliance ID
    with name
      returns the specified server appliance ID
    with invalid appliance identifier
      raises an error
    with unsupported server appliance
      raises an error
  resolve_fixed_instance_size
    with ID
      returns the specified fixed-server size ID
    with name
      returns the specified fixed-server size ID
    with invalid flavor identifier
      raises an error
  resolve_datacenter
    with ID
      returns the specified data center ID
    with name
      returns the specified data center ID
    with invalid data center identifier
      raises an error
  resolve_public_ip
    with ID
      returns the specified public IP ID
    with name
      returns the specified public IP ID
    with invalid public IP identifier
      raises an error
    with assigned public IP
      raises an error
  resolve_ssh_key
    with private_key_path provided
      returns ssh key
    with invalid private_key_path
      raises an error

VagrantPlugins::OneAndOne::Config
  defaults
    should default to nil
    fixed size should default to M
    data center should default to US
    appliance should default to ubuntu1404-64std
  overriding defaults
    should not default api_key if overridden
    should not default name if overridden
    should not default description if overridden
    should not default password if overridden
    should not default ip if overridden
    should not default fixed_size if overridden
    should not default timeout if overridden
    should not default datacenter if overridden
    should not default appliance if overridden
    should not default firewall_id if overridden
    should not default load_balancer_id if overridden
    should not default monitoring_policy_id if overridden

VagrantPlugins::OneAndOne::Provider
  to string
    should output the provider name

Finished in 1.1 seconds
64 examples, 0 failures
```