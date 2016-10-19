# Vagrant OneAndOne Cloud Provider

[![Build Status](https://travis-ci.org/StackPointCloud/oneandone-cloudserver-vagrant.svg?branch=master)](https://travis-ci.org/StackPointCloud/oneandone-cloudserver-vagrant)

## Table of Contents

* [Introduction](#introduction)
* [Features](#features)
* [Requirements](#requirements)
* [Usage](#usage)
* [Configuration](#configuration)
* [Supported Commands](#supported-commands)
* [Examples](#examples)
* [Development](#development)


## Introduction

This is a [Vagrant](http://www.vagrantup.com) plugin that adds a
1&amp;1 provider to Vagrant, which allows Vagrant to control and provision 
machines in the [1&amp;1 Server Cloud](https://www.1and1.com/dynamic-cloud-server).

## Features

* Create and destroy servers.
* Start, stop and restart servers.
* Provision the servers with built-in Vagrant provisioners.
* SSH into the instances.
* Custom sub-commands within the Vagrant CLI to query 1&amp;1 Server entities.

## Requirements

* Ruby 2.0 or higher
* [Vagrant 1.4+](http://www.vagrantup.com/downloads.html)
* [1&amp;1](https://www.1and1.com/dynamic-cloud-server) API access key
* SSH (RSA) public/private key pair

**Note:** Public and private keys need to be stored on the same location.

## Usage

Install the plugin using the standard installation method, the Vagrant command-line interface:

```
vagrant plugin install vagrant-oneandone
```

Before we start using the plugin we must provider a custom [box](https://www.vagrantup.com/docs/boxes.html) for the 1&amp;1
provider. Vagrant requires any provider to introduce its own [package format](https://www.vagrantup.com/docs/boxes/format.html)
for Vagrant environment.

You can find an example box and instructions how to create it in the [box directory](box/).
To use the `dummy.box`, add it to Vagrant:

```
vagrant box add dummy https://github.com/StackPointCloud/oneandone-cloudserver-vagrant/raw/master/box/dummy.box
```

Assuming you have a valid [Vagrantfile](https://www.vagrantup.com/docs/vagrantfile/) 
in the same directory, initiate a machine creation, i.e., server deployment:

```
vagrant up --provider=oneandone
```

The following example shows a minimal Vagrantfile configuration for the 1&amp;1 provider.

```ruby
Vagrant.configure('2') do |config|
  config.vm.box = 'dummy'
  config.ssh.private_key_path = 'path/to/private/key'

  config.vm.provider :oneandone do |server|
    server.api_key = 'your api key'
    server.name    = 'my-server-name'
  end
end
```

## Configuration

The 1&amp;1 Vagrant provider exposes a few provider-specific configuration options:

* `api_key`: The API key for accessing 1&amp;1 Cloud Server (required). Defaults to `ENV['ONEANDONE_API_KEY']`, if not provided.
* `name`: The server host name. Required, if Vagrant `config.vm.hostname` option is not specified. It has precedence over `hostname`, if both options are set.
* `fixed_size`: A fixed-instance size for the server (required). ID or name is supported. Defaults to `M`, if not provided.
* `appliance`: A server appliance for the server (required). ID or name (without spaces) is supported. Defaults to `ubuntu1404-64std`, if not provided.
* `datacenter`: A data center for the server (required). ID or country code is supported. Defaults to `US`, if not provided.
* `description`: The server description.
* `password`: The server's `root` user password.
* `ip`: An unassigned public IP address for the server. ID or IP address can be used.
* `firewall_id`: The ID of a firewall policy that is to be assigned to the server.
* `load_balancer_id`: The ID of a load balancer that is to be assigned to the server.
* `monitoring_policy_id`: The ID of a monitoring policy that is to be assigned to the server.
* `timeout`: The server deployment timeout in seconds. Defaults to `1800`, if not provided.

**Note:** Only Linux-based server appliances are supported in this version of the plugin.

## Supported Commands

The following Vagrant actions are currently supported with the provider:

- `vagrant up`: Creates or starts an existing server instance.
- `vagrant status`: Displays the server status (active, off, not created).
- `vagrant halt`: Stops the server instance. If `--force` option is specified, performs hardware-based shutdown.
- `vagrant ssh`: Connects to the server instance using the configured public/private keys. No insecure Vagrant key is supported.
- `vagrant ssh-config`: Displays the SSH configuration for the server instance.
- `vagrant provision`: Provisions the server with one or more.
- `vagrant reload`: Reboots the server instance. If `--force` option is specified, performs hardware-based reset.
- `vagrant destroy`: Destroys the server instance. If `--force` option is specified, deletes the server without asking for confirmation.

In addition to these, several custom commands are available to list 1&amp;1 Cloud entities.

```
vagrant oneandone
Usage: vagrant oneandone <subcommand> [<api_key>]

Available subcommands:
     appliances
     datacenters
     firewalls
     ips
     loadbalancers
     monitors
     servers
     sizes

For help on any subcommand run `vagrant oneandone <subcommand> -h`
```

An example of a custom command output:

```
vagrant oneandone datacenters
+----------------------------------+------------------------------------------------------+--------------+
| ID                               | Location                                             | Country Code |
+----------------------------------+------------------------------------------------------+--------------+
| 81DEF28500FBC2A973FC0C620DF5B721 | Spain                                                | ES           |
| 908DC2072407C94C8054610AD5A53B8C | United States of America                             | US           |
| 4EFAD5836CE43ACA502FD5B99BEE44EF | Germany                                              | DE           |
| 5091F6D8CBFEF9C26ACE957C652D5D49 | United Kingdom of Great Britain and Northern Ireland | GB           |
+----------------------------------+------------------------------------------------------+--------------+
```

## Examples

The Vagrantfile examples in this section can be found in the `examples` directory of this repository.

It is assumed that a valid API key is set in `$ONEANDONE_API_KEY` environment variable.

* A simple CoreOS server configuration:
```ruby
Vagrant.configure('2') do |config|
  config.vm.box = 'dummy'
  config.ssh.private_key_path = '~/.ssh/id_rsa'

  config.vm.provider :oneandone do |server|
    server.name       = 'vagrant-coreos'
    server.appliance  = 'CoreOS_Stable_64std'
  end
end
```

* Deploy a Django DB application server:
```ruby
Vagrant.configure('2') do |config|
  config.vm.box = 'dummy'
  config.ssh.private_key_path = '~/.ssh/id_rsa'

  config.vm.provider :oneandone do |server|
    server.name       = 'django-db-server'
    server.appliance  = 'django'
    server.datacenter = 'DE'
    server.fixed_size = 'L'
  end
end
```

* Run shell provisioning on an Ubuntu 12.04 instance:
```ruby
Vagrant.configure('2') do |config|
  config.vm.hostname = 'ubuntu1204-server-example'
  config.vm.box = 'dummy'
  config.ssh.private_key_path = '~/.ssh/id_rsa'
  config.ssh.pty = true

  config.vm.provider :oneandone do |oneandone|
    oneandone.appliance  = 'ubuntu1204-64std'
    oneandone.datacenter = 'ES'
    oneandone.fixed_size = 'S'
  end

  config.vm.provision "shell" do |s|
    s.inline = 'apt-get update && apt-get install -y'
  end
end
```

* Create multiple servers in parallel:
```ruby
Vagrant.configure('2') do |config|
  config.vm.box = 'dummy'
  config.ssh.private_key_path = '~/.ssh/id_rsa'

  config.vm.define :centos do |centos|
   centos.ssh.pty = true
   centos.vm.provider :oneandone do |vm|
     vm.name        = 'worker1'
     vm.description = 'worker node 1'
     vm.appliance   = 'centos7-64std'
     vm.datacenter  = 'US'
   end
  end

  config.vm.define :ubuntu do |ubuntu|
   ubuntu.vm.provider :oneandone do |vm|
     vm.name        = 'worker2'
     vm.description = 'worker node 2'
     vm.appliance   = 'ubuntu1604-64std'
     vm.datacenter  = 'US'
   end
  end
end
```

* Provision a Debian 8 server with Docker:
```ruby
Vagrant.configure('2') do |config|
  config.vm.box = 'dummy'
  config.ssh.private_key_path = '~/.ssh/id_rsa'

  config.vm.provider :oneandone do |oneandone|
    oneandone.name       = 'debian8-docker'
    oneandone.appliance  = 'debian8-64std'
    oneandone.datacenter = 'GB'
    oneandone.fixed_size = 'XL'
  end

  config.vm.provision "docker" do |d|
  end
end
```

## Development

While Ruby 2.0 might be sufficient to run the plugin within Vagrant, some of the
plugin dependencies may require a higher version of Ruby to install. Therefore, 
Ruby 2.2.3 or higher is recommended for the plugin development.

Check out the repository and use [Bundler](http://bundler.io/) to install dependencies.

The current version of Vagrant (1.8.6 and 1.8.7.dev) requires Bundler version 1.12.5.

    $ gem install bundler -v 1.12.5

Install the plugin dependency gems:

    $ bundle install

Execute the unit test task:

    $ rake spec:unit

`bundle exec vagrant <command>` enables you to test the plugin during the development.

Build the plugin gem for local installation and deployment to https://rubygems.org/:

    $ rake build

Before you send a pull request, make sure you have successfully run the functional 
tests as well.

    $ rake spec:acceptance
