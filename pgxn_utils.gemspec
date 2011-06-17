# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "pgxn_utils/version"

Gem::Specification.new do |s|
  s.name        = "pgxn_utils"
  s.version     = PgxnUtils::VERSION
  s.platform    = Gem::Platform::RUBY
  s.date        = %q{2011-05-06}
  s.authors     = ["Dickson S. Guedes"]
  s.email       = ["guedes@guedesoft.net"]
  s.homepage    = "http://github.com/guedes/pgxn-utils"
  s.summary     = %q{A PGXN set of tools to PostgreSQL extension's developers}
  s.description = %q{A PGXN set of tools to help developers create and publish your PostgreSQL extensions without pain}

  s.required_ruby_version = '>= 1.8.7'
  s.required_rubygems_version = '>= 1.3.7'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency "json", "~> 1.5.2"
      s.add_runtime_dependency "thor", "~> 0.14"
      s.add_runtime_dependency "rubyzip", "~> 0.9.4"
      s.add_runtime_dependency "zippy", "~> 0.1.0"
      s.add_development_dependency "rspec"
      s.add_development_dependency "simplecov", "~> 0.4.0"
    else
      s.add_dependency "json", "~> 1.5.2"
      s.add_dependency "thor", "~> 0.14"
      s.add_dependency "rubyzip", "~> 0.9.4"
      s.add_dependency "zippy", "~> 0.1.0"
    end
  else
    s.add_dependency "json", "~> 1.5.2"
    s.add_dependency "thor", "~> 0.14"
    s.add_dependency "rubyzip", "~> 0.9.4"
    s.add_dependency "zippy", "~> 0.1.0"
  end
end
