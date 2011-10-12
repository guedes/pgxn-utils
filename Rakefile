require 'bundler'
#include Rake::DSL
Bundler::GemHelper.install_tasks
require 'rspec/core/rake_task'

def format_cmd_output(cmd)
  `./bin/pgxn-utils #{cmd} | sed 's/^/    /' | sed 's/\[[0-9]*m//g'`
end

desc "Run RSpec"
RSpec::Core::RakeTask.new do |t|
  t.verbose = false
  t.rspec_opts = %w(--color)
end

desc "CTag Files"
task :ctag do
  #system("ctags -R --exclude=.git --exclude=log * ~/.rvm/gems/")
  system("ctags -R --exclude=.git --exclude=log *")
end

desc "Generate README.md"
task :generate_readme do
  rm_r "/tmp/my_cool_extension" if File.exist?("/tmp/my_cool_extension")
  rm_r "/tmp/my_cool_versioned_extension" if File.exist?("/tmp/my_cool_versioned_extension")
  readme = File.new("README.md.new", 'w')
  readme.puts <<-README
pgxn utils
==========

What is it?
--------

It aims to be a set of task to help PostgreSQL extension's developers to focus more on the problem that they wants to solve than in all structure and files and control files need to PGXS to build the extension.

How to install it?
------------------

If you have pgxn client installed you can do:

    pgxn install pgxn_utils

Or you can install it by rubygems:

    gem install pgxn_utils

How it works?
-------------

It is all about tasks. Let's see them:

    $ pgxn-utils help
#{format_cmd_output("help")}

# Creating a new extension

    $ pgxn-utils skeleton my_cool_extension
#{format_cmd_output("skeleton my_cool_extension -p /tmp")}

You can start creating an extension with or without version control. By default `pgxn-utils`
supports [git](http://git-scm.org) but it will not create a repository unless you use `--git`
option in the skeleton task.

    $ pgxn-utils skeleton my_cool_versioned_extension --git
#{format_cmd_output("skeleton my_cool_versioned_extension --git -p /tmp")}

Thats it! Just start coding! ":)

# Changing something

Well suppose you want to change the default maintainer's name and the license, just do:

    $ pgxn-utils change my_cool_extension --maintainer "Dickson Guedes" --license bsd
#{format_cmd_output("change my_cool_extension -p /tmp --maintainer 'Dickson Guedes' --license bsd")}

It will wait you decide what to do.

For all switches that you can use with *change*, type:

    $ pgxn-utils help change
#{format_cmd_output("help change")}

# Bundling and Releasing!

Well, since you finished your work you can bundle it to send to [PGXN](http://pgxn.org).

Bundle it:

    $ pgxn-utils bundle my_cool_extension
             create /home/guedes/extensions/my_cool_extension-0.0.1.zip

and release it:

    $ pgxn-utils release my_cool_extension-0.0.1.zip
    Enter your PGXN username: guedes
    Enter your PGXN password: ******
    Trying to release my_cool_extension-0.0.1.zip ... released successfully!
    Visit: https://manager.pgxn.org/distributions/my_cool_extension/0.0.1

You can export `PGXN_USER` and `PGXN_PASSWORD` environment variables to avoid
type username and password everytime.

# Git support

You can start a new extension with git support calling `skeleton` task with
`--git` flag, then in addition to create skeleton, `pgxn-utils` will initialize
a git repository and do a initial commit.

Once you have your extension in a git repository your `bundle` will use only the
commited files to create the archive, but if your repository is dirty then `pgxn-utils`
will hint you to commit or stash your changes, before bundle.

You must be careful with new files not added to repository, because they will NOT
be archived.

# Working in progress

* improve [git](http://git-scm.org) support
* proxy support
* custom templates

Copyright and License
---------------------

Copyright (c) 2011 Dickson S. Guedes.

This module is free software; you can redistribute it and/or modify it under
the [PostgreSQL License](http://www.opensource.org/licenses/postgresql).

Permission to use, copy, modify, and distribute this software and its
documentation for any purpose, without fee, and without a written agreement is
hereby granted, provided that the above copyright notice and this paragraph
and the following two paragraphs appear in all copies.

In no event shall Dickson S. Guedes be liable to any party for direct,
indirect, special, incidental, or consequential damages, including lost
profits, arising out of the use of this software and its documentation, even
if Dickson S. Guedes has been advised of the possibility of such damage.

Dickson S. Guedes specifically disclaims any warranties, including, but not
limited to, the implied warranties of merchantability and fitness for a
particular purpose. The software provided hereunder is on an "as is" basis,
and Dickson S. Guedes has no obligations to provide maintenance, support,
updates, enhancements, or modifications.
  README
end
task :default => :spec
