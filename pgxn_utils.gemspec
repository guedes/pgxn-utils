# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "pgxn_utils/version"

Gem::Specification.new do |s|
  s.name        = "pgxn_utils"
  s.version     = PgxnUtils::VERSION
  s.platform    = Gem::Platform::RUBY
  s.date        = %q{2012-03-06}
  s.authors     = ["Dickson S. Guedes"]
  s.email       = ["guedes@guedesoft.net"]
  s.homepage    = "http://github.com/guedes/pgxn-utils"
  s.summary     = %q{A PGXN set of tools to PostgreSQL extension's developers}
  s.description = %q{A PGXN set of tools to help developers create and publish your PostgreSQL extensions without pain}

  s.required_ruby_version = '>= 2.0.0'
  s.required_rubygems_version = '>= 1.3.7'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.post_install_message= <<-EOF

  PGXN Utils version #{PgxnUtils::VERSION} was installed!

  Issues? Please visit: https://github.com/guedes/pgxn-utils/issues

  Recomended tools:

  - PGXN Client: http://pgxnclient.projects.postgresql.org
  - PGXN Meta Validator: https://github.com/pgxn/pgxn-meta-validator

  Thank you for use this tool!

  Regards, Dickson S. Guedes

  EOF

  s.add_runtime_dependency "thor", "~> 0.14"
  s.add_runtime_dependency "rubyzip", "~> 1.2.0"
  s.add_runtime_dependency "multipart-post", "~> 2.0.0"
  s.add_runtime_dependency "highline", "~> 1.7.8"
  s.add_runtime_dependency "grit", "~> 2.5.0"
  s.add_development_dependency "rspec"
  s.add_development_dependency "mocha"
  s.add_development_dependency "simplecov", "~> 0.10.0"

end
