require 'puppetlabs_spec_helper/module_spec_helper'

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))

Dir[File.join(fixture_path, 'modules/*/lib')].each do |mod|
  $: << mod
end

RSpec.configure do |c|
  c.hiera_config = File.join(fixture_path, 'hiera.yaml')
  c.formatter = 'documentation'
  c.default_facts = {
    :operatingsystem => 'CentOS',
    :osfamily => 'RedHat',
  }

  if ENV['PUPPET_DEBUG']
    Puppet::Util::Log.level = :debug
    Puppet::Util::Log.newdestination(:console)
  end

  if ENV['PARSER'] == 'future'
    c.parser = 'future'
  end
end
