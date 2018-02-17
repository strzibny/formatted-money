require 'rubygems/package_task'
require 'rake'
require 'rake/testtask'

gemspec = Gem::Specification.new do |s|
  s.name = 'formatted-money'
  s.version = '1.0.dev'
  s.author = 'Josef Strzibny'
  s.email = 'strzibny@strzibny.name'
  s.homepage = 'http://github.com/strzibny/formatted-money'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A dead simple library for converting human-readable money inputs to Integer and back'
  s.description = <<-EOF
                    For all Rubyist that use Integer for storing money values as cents.
                    This is a dead simple gem for converting money from user inputs to Integer values
                    for storing and fast precise calculations (and back). Does everything you need
                    and nothing else. Well tested.
                  EOF
  s.require_path = 'lib'
  s.required_ruby_version = '>= 2.0.0'
  s.files = FileList['LICENSE', 'Rakefile', 'README.md', 'doc/**/*', 'lib/**/*', 'test/*']
end

Gem::PackageTask.new gemspec do |_p|
end

Rake::TestTask.new('test') do |t|
  t.libs << 'test'
  t.pattern = 'test/test_*.rb'
  t.verbose = true
end

task :default => [:test]
