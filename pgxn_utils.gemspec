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
  s.summary     = %q{A PGXN set of tools to developers}
  s.description = %q{A PGXN set of tools to help developers create and publish your PostgreSQL extensions without pain}

  s.rubyforge_project = "pgxn_utils"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # dev
  s.add_development_dependency "rspec"

  # prod
  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<thor>, ["~> 0.14"])
    else
      s.add_dependency(%q<thor>, ["~> 0.14"])
    end
  else
    s.add_dependency(%q<thor>, ["~> 0.14"])
  end
end
