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

  s.required_ruby_version = '>= 1.8.7'
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

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency "json", "~> 1.6.6"
      s.add_runtime_dependency "thor", "~> 0.14"
      s.add_runtime_dependency "rubyzip", "~> 0.9.7"
      s.add_runtime_dependency "multipart-post", "~> 1.1.5"
      s.add_runtime_dependency "highline", "~> 1.6.11"
      s.add_runtime_dependency "grit", "~> 2.4.1"
      s.add_development_dependency "rspec"
      s.add_development_dependency "mocha"
      s.add_development_dependency "simplecov", "~> 0.4.0"
    else
      s.add_dependency "json", "~> 1.6.6"
      s.add_dependency "thor", "~> 0.14"
      s.add_dependency "rubyzip", "~> 0.9.7"
      s.add_dependency "multipart-post", "~> 1.1.5"
      s.add_dependency "highline", "~> 1.6.11"
      s.add_dependency "grit", "~> 2.4.1"
    end
  else
    s.add_dependency "json", "~> 1.6.6"
    s.add_dependency "thor", "~> 0.14"
    s.add_dependency "rubyzip", "~> 0.9.7"
    s.add_dependency "multipart-post", "~> 1.1.5"
    s.add_dependency "highline", "~> 1.6.11"
    s.add_dependency "grit", "~> 2.4.1"
  end
end
