$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rake'
require 'rake/testtask'

SPEC = Gem::Specification.new do |s|
  s.name = "formatted-money"
  s.version = '0.0.1'
  s.author = "Josef Strzibny"
  s.email = "strzibny@strzibny.name"
  s.homepage = "http://github.com/strzibny/formatted-money"
  s.platform = Gem::Platform::RUBY
  s.summary = ""  
  s.description = ""
  s.require_path = "lib"
  s.files = [
    'LICENSE',
    'Rakefile',
    'README.md',
    'lib/**/*',
    'test/*'
  ]
end

Rake::TestTask.new('test') do |t|
  t.libs << 'test'
  t.pattern = 'test/test_*.rb'
  t.verbose = true
end