require 'rubygems'
require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

# Do not buffer output
$stdout.sync = true
$stderr.sync = true

# Change to the directory of this file.
Dir.chdir(File.expand_path('../', __FILE__))

namespace :spec do
  desc 'Run acceptance specs'
  task :acceptance do
    components = %w(
      general
      commands
    ).map { |s| "provider/oneandone/#{s}" }

    exec "bundle exec vagrant-spec test --components=#{components.join(' ')}"
  end

  desc 'Run unit specs using RSpec'
  RSpec::Core::RakeTask.new('unit') do |t|
    t.pattern = './unit/**/*_spec.rb'
  end
end

desc 'Run all tests'
task spec: ['spec:unit', 'spec:acceptance']

task default: 'spec:unit'
