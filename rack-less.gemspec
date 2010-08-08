# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rack-less}
  s.version = "1.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Kelly Redding"]
  s.date = %q{2010-08-08}
  s.email = %q{kelly@kelredd.com}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc", "Rakefile", "lib/rack", "lib/rack/less", "lib/rack/less/base.rb", "lib/rack/less/config.rb", "lib/rack/less/options.rb", "lib/rack/less/request.rb", "lib/rack/less/response.rb", "lib/rack/less/source.rb", "lib/rack/less/version.rb", "lib/rack/less.rb"]
  s.homepage = %q{http://github.com/kelredd/rack-less}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A better way to use LESS CSS in Ruby web apps.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<shoulda>, [">= 2.10.2"])
      s.add_development_dependency(%q<sinatra>, [">= 0.9.4"])
      s.add_development_dependency(%q<rack-test>, [">= 0.5.3"])
      s.add_development_dependency(%q<webrat>, [">= 0.6.0"])
      s.add_development_dependency(%q<yui-compressor>, [">= 0.9.1"])
      s.add_runtime_dependency(%q<rack>, [">= 0.4"])
      s.add_runtime_dependency(%q<less>, [">= 1.2.21"])
    else
      s.add_dependency(%q<shoulda>, [">= 2.10.2"])
      s.add_dependency(%q<sinatra>, [">= 0.9.4"])
      s.add_dependency(%q<rack-test>, [">= 0.5.3"])
      s.add_dependency(%q<webrat>, [">= 0.6.0"])
      s.add_dependency(%q<yui-compressor>, [">= 0.9.1"])
      s.add_dependency(%q<rack>, [">= 0.4"])
      s.add_dependency(%q<less>, [">= 1.2.21"])
    end
  else
    s.add_dependency(%q<shoulda>, [">= 2.10.2"])
    s.add_dependency(%q<sinatra>, [">= 0.9.4"])
    s.add_dependency(%q<rack-test>, [">= 0.5.3"])
    s.add_dependency(%q<webrat>, [">= 0.6.0"])
    s.add_dependency(%q<yui-compressor>, [">= 0.9.1"])
    s.add_dependency(%q<rack>, [">= 0.4"])
    s.add_dependency(%q<less>, [">= 1.2.21"])
  end
end
