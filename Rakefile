require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'

desc "Run RSpec"
RSpec::Core::RakeTask.new do |t|
  t.verbose = false
  #t.rspec_opts = %w(-fs --color)
  t.rspec_opts = %w(--color)
  #dont show warnings here yet
  #t.ruby_opts  = %w(-w)
end

desc "CTag Files"
task :ctag do
  #system("ctags -R --exclude=.git --exclude=log * ~/.rvm/gems/")
  system("ctags -R --exclude=.git --exclude=log *")
end

task :default => :spec
