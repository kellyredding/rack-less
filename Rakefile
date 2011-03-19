require 'rubygems'
require 'bundler'
Bundler.setup

require 'rake/gempackagetask'
require 'simple_gem/testtasks'

require 'lib/rack/less/version'

spec = Gem::Specification.new do |s|
  s.name             = 'rack-less'
  s.version          = RackLess::Version.to_s
  s.has_rdoc         = true
  s.extra_rdoc_files = %w(README.rdoc)
  s.rdoc_options     = %w(--main README.rdoc)
  s.summary          = "A better way to use LESS CSS in Ruby web apps."
  s.author           = 'Kelly Redding'
  s.email            = 'kelly@kelredd.com'
  s.homepage         = 'http://github.com/kelredd/rack-less'
  s.files            = %w(README.rdoc Rakefile) + Dir.glob("{lib}/**/*")
  # s.executables    = ['rack-less']

  s.add_development_dependency("shoulda", [">= 2.10.2"])
  s.add_development_dependency("leftright", [">= 0.0.6"])
  s.add_development_dependency("sinatra", [">= 0.9.4"])
  s.add_development_dependency("rack-test", [">= 0.5.3"])
  s.add_development_dependency("webrat", [">= 0.6.0"])
  s.add_development_dependency("yui-compressor", [">=0.9.1"])
  s.add_development_dependency("kelredd-simple-gem", [">= 0.7.0"])

  s.add_dependency("rack", [">= 0.4"])
  s.add_dependency("less", [">= 1.2.21"])
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

SimpleGem::TestTasks.new

desc 'Generate the gemspec to serve this gem'
task :gemspec do
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, 'w') {|f| f << spec.to_ruby }
  puts "Created gemspec: #{file}"
end

task :default => :gem
