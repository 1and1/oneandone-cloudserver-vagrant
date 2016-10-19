Vagrant::Spec::Acceptance.configure do |c|
  c.component_paths << File.expand_path('../spec/acceptance', __FILE__)
  c.skeleton_paths << File.expand_path('../spec/acceptance/skeletons', __FILE__)

  c.env['PRIVATE_KEY_PATH'] = File.expand_path('../spec/keys/test_id_rsa', __FILE__)

  c.provider 'oneandone',
             box: File.expand_path('../box/dummy.box', __FILE__)
end
