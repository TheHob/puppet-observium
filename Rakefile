require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'

# These two gems aren't always present, for instance
# on Travis with --without development
begin
  require 'puppet_blacksmith/rake_tasks'
rescue LoadError
end

exclude_paths = [
  'pkg/**/*',
  'vendor/**/*',
  'spec/**/*',
]

Rake::Task[:lint].clear
PuppetLint::RakeTask.new :lint do |config|
  config.ignore_paths = exclude_paths
  config.log_format = "%{path}:%{linenumber}:%{check}:%{KIND}:%{message}"
  config.disable_checks = [
    '80chars',
    'class_parameter_defaults',
    'class_inherits_from_params_class',
  ]
end

PuppetLint.configuration.relative = true
PuppetSyntax.exclude_paths = exclude_paths

desc "Install depenencies with librarian-puppet."
task :librarian_fixtures do
  FileUtils.ln_s '../Puppetfile', 'spec/fixtures/Puppetfile', :force => true
  Dir.chdir('spec/fixtures/') do
    if File.exists?('Puppetfile.lock')
      puts 'Puppetfile.lock found, updating Puppet modules from Puppetfile.'
      %x(bundle exec librarian-puppet update --verbose)
    else
      puts 'New Puppetfile, installing modules from Puppetfile.'
      %x(bundle exec librarian-puppet install --verbose)
    end
  end
end

if File.exists?('spec/Puppetfile')
  task :librarian_fixtures => :spec_prep
  task :spec => :librarian_fixtures
end

desc "Run syntax, lint, and spec tests."
task :test => [
  :syntax,
  :lint,
  :spec,
]
