source 'http://rubygems.org/gems'

puppet_version = ENV['CI_PUPPET_VERSION'] || '2.7.3'
ruby_version = ENV['CI_RUBY_VERSION'] || '1.8.7'

ruby ruby_version

case puppet_version
when '2.7.3'
  gem 'puppet-module'
  gem 'hiera'
  gem 'hiera-puppet'
  gem 'facter', '1.6.8'
  gem 'ruby-augeas'
  gem 'ruby-shadow'
else
  gem 'librarian-puppet'
end

group :test do
  gem 'rake'
  gem 'puppet', "#{puppet_version}"
  gem 'puppet-lint'
  gem 'rspec'
  gem 'rspec-puppet', "2.1.0"
  gem 'puppet-syntax'
  gem 'highline', "1.6.21" if ruby_version == '1.8.7'
  gem 'puppetlabs_spec_helper'
end

unless puppet_version == '2.7.3'
  group :development do
    gem 'minitest', "< 5.0"
    gem 'beaker'
    gem 'beaker-rspec'
    gem 'vagrant-wrapper'
    gem 'puppet-blacksmith'
    gem 'guard-rake'
  end
end
