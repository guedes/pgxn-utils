pgxn utils
==========

[![Gem Version](https://badge.fury.io/rb/pgxn_utils.svg)](https://badge.fury.io/rb/pgxn_utils)
[![PGXN version](https://badge.fury.io/pg/pgxn_utils.svg)](https://badge.fury.io/pg/pgxn_utils)

What is it?
-----------

PGXN Utils are a set of tasks that help developers to create PostgreSQL
extensions, putting the extension's files in the recommended places and helping
to bundle and release them to PGXN.

How to install it?
------------------

If you have the [PGXN client](http://pgxnclient.projects.postgresql.org/)
installed you can do:

    pgxn install pgxn_utils

Or you can install it with rubygems:

    gem install pgxn_utils

How does it work?
-----------------

It is all about tasks. Let's see them:

    $ pgxn-utils help
    Tasks:
      pgxn-utils bundle [extension_name]  # Bundle the extension in a zip file
      pgxn-utils change [extension_name]  # Change META.json attributes
      pgxn-utils help [TASK]              # Describe available tasks or one specific task
      pgxn-utils release filename         # Release an extension to PGXN
      pgxn-utils skeleton extension_name  # Create an extension skeleton in current directory

# Creating a new extension

    $ pgxn-utils skeleton my_cool_extension
          create  my_cool_extension
          create  my_cool_extension/my_cool_extension.control
          create  my_cool_extension/.gitignore
          create  my_cool_extension/.template
          create  my_cool_extension/META.json
          create  my_cool_extension/Makefile
          create  my_cool_extension/README.md
          create  my_cool_extension/doc/my_cool_extension.md
          create  my_cool_extension/sql/my_cool_extension.sql
          create  my_cool_extension/sql/uninstall_my_cool_extension.sql
          create  my_cool_extension/test/expected/base.out
          create  my_cool_extension/test/sql/base.sql


Thats it! Just start coding! ":)

## Git support

You can start a new extension with or without version control. By default `pgxn-utils`
supports [git](http://git-scm.org) but it will not create a repository unless you
use `--git` option in the skeleton task.

    $ pgxn-utils skeleton my_cool_versioned_extension --git
          create  my_cool_versioned_extension
          create  my_cool_versioned_extension/my_cool_versioned_extension.control
          create  my_cool_versioned_extension/.gitignore
          create  my_cool_versioned_extension/.template
          create  my_cool_versioned_extension/META.json
          create  my_cool_versioned_extension/Makefile
          create  my_cool_versioned_extension/README.md
          create  my_cool_versioned_extension/doc/my_cool_versioned_extension.md
          create  my_cool_versioned_extension/sql/my_cool_versioned_extension.sql
          create  my_cool_versioned_extension/sql/uninstall_my_cool_versioned_extension.sql
          create  my_cool_versioned_extension/test/expected/base.out
          create  my_cool_versioned_extension/test/sql/base.sql
            init  /tmp/my_cool_versioned_extension
          commit  initial commit

When you create a new extension with git support in addition to creating the skeleton,
`pgxn-utils` will initialize a git repository and create the initial commit.

Once you have your extension in a git repository your `bundle` will use only the
committed files to create the archive, but if your repository is dirty then `pgxn-utils`
will suggest that you to commit or stash your changes before bundling.

You must be careful with new files not added to repository, because they will **not**
be archived.

## Default templates

`pgxn-utils` has three templates: `sql`, `c` and `fdw`. If you call `skeleton` without
specifying a template, `sql` is the default. But if your extension will supply some C
modules or you will create a FDW, you can create the extension calling `skeleton` with a
`--template` option.

    $ pgxn-utils skeleton my_cool_c_extension --template=c
          create  my_cool_c_extension
          create  my_cool_c_extension/my_cool_c_extension.control
          create  my_cool_c_extension/.gitignore
          create  my_cool_c_extension/.template
          create  my_cool_c_extension/META.json
          create  my_cool_c_extension/Makefile
          create  my_cool_c_extension/README.md
          create  my_cool_c_extension/doc/my_cool_c_extension.md
          create  my_cool_c_extension/sql/my_cool_c_extension.sql
          create  my_cool_c_extension/sql/uninstall_my_cool_c_extension.sql
          create  my_cool_c_extension/src/my_cool_c_extension.c
          create  my_cool_c_extension/test/expected/base.out
          create  my_cool_c_extension/test/sql/base.sql

    $ pgxn-utils skeleton my_cool_fdw_extension --template=fdw
          create  my_cool_fdw_extension
          create  my_cool_fdw_extension/my_cool_fdw_extension.control
          create  my_cool_fdw_extension/.gitignore
          create  my_cool_fdw_extension/.template
          create  my_cool_fdw_extension/META.json
          create  my_cool_fdw_extension/Makefile
          create  my_cool_fdw_extension/README.md
          create  my_cool_fdw_extension/doc/my_cool_fdw_extension.md
          create  my_cool_fdw_extension/sql/my_cool_fdw_extension.sql
          create  my_cool_fdw_extension/sql/uninstall_my_cool_fdw_extension.sql
          create  my_cool_fdw_extension/src/my_cool_fdw_extension_fdw.c
          create  my_cool_fdw_extension/test/expected/base.out
          create  my_cool_fdw_extension/test/sql/base.sql

The templates contain example code and some links to PostgreSQL documentation
that will try to help you to start coding. SQL and C templates contains some test
examples, and the example code will compile and pass `make installcheck`.
However, this code is intended to be an example, and you must write your own
tests and code.

## Custom templates

If you don't like the templates provided by `pgxn-utils` you can create you own.
Just create a directory with at least a `META.json` or
`META.json.tt` file and then use your directory as argument to the `--template`
option.

To know how create your own template, see the examples in the
[templates directory](https://github.com/guedes/pgxn-utils/tree/master/lib/pgxn_utils/templates).

# Changing something

Suppose you want to change the default maintainer's name and the license, just do:

    $ pgxn-utils change my_cool_extension --maintainer "Dickson Guedes" --license bsd
        conflict  META.json
    Overwrite /tmp/my_cool_extension/META.json? (enter "h" for help) [Ynaqdh]
	{
         "name": "my_cool_extension",
         "abstract": "A short description",
         "description": "A long description",
         "version": "0.0.1",
    -    "maintainer": "The maintainer's name",
    +    "maintainer": "Dickson Guedes",
    -    "license": "postgresql",
    +    "license": "bsd",
         "provides": {
            "my_cool_extension": {
               "abstract": "A short description",
               "file": "sql/my_cool_extension.sql",
               "docfile": "doc/my_cool_extension.md",
               "version": "0.0.1"
            }
         },
         "release_status": "unstable",
         "generated_by": "The maintainer's name",
         "meta-spec": {
            "version": "1.0.0",
            "url": "http://pgxn.org/meta/spec.txt"
         }
      }
    Retrying...
    Overwrite /tmp/my_cool_extension/META.json? (enter "h" for help) [Ynaqdh]
	       force  META.json
       identical  my_cool_extension.control

It will wait until you decide what to do.

For all switches that you can use with *change*, type:

    $ pgxn-utils help change
    Usage:
      pgxn-utils change [extension_name]

    Options:
      -p, [--target=TARGET]                  # Define the target directory
                                             # Default: .
      -m, [--maintainer=MAINTAINER]          # Maintainer's name <maintainer@email>
      -a, [--abstract=ABSTRACT]              # Defines a short description to abstract
      -l, [--license=LICENSE]                # The extension license.
      -v, [--version=VERSION]                # Initial version
      -d, [--description=DESCRIPTION]        # A long text that contains more information about extension
      -b, [--generated-by=GENERATED_BY]      # Name of extension's generator
      -t, [--tags=one two three]             # Defines extension's tags
      -r, [--release-status=RELEASE_STATUS]  # Initial extension's release status

    Changes META's attributes in current extension

# Bundling and Releasing!

Assuming you've created a [PGXN Manager](http://manager.pgxn.org/) account,
once you've finished your work you can bundle it to send to [PGXN](http://pgxn.org).
Note that if your extension is in a git repository, `bundle` will use only the
committed files to create the archive, and if your repository is dirty, `pgxn-utils`
will suggest that you commit or stash your changes before bundling.

Let's bundle it:

    $ pgxn-utils bundle my_cool_extension
             create /home/guedes/extensions/my_cool_extension-0.0.1.zip

and release it:

    $ pgxn-utils release my_cool_extension-0.0.1.zip
    Enter your PGXN username: guedes
    Enter your PGXN password: ******
    Trying to release my_cool_extension-0.0.1.zip ... released successfully!
    Visit: https://manager.pgxn.org/distributions/my_cool_extension/0.0.1

You can export the `PGXN_USER` and `PGXN_PASSWORD` environment variables to avoid
typing your username and password every time.

# PGXN Client integration

If you have [PGXN client](http://pgxnclient.projects.postgresql.org/) installed you
can change the command line from `pgxn-utils some_task` to `pgxn some_task` and this
will save you some typing. See:

    $ cd /tmp
    $ pgxn skeleton --help
    PGXN Utils version: 0.1.6
    Usage:
      pgxn skeleton extension_name

    Options:
          [--git]                            # Initialize a git repository after create the extension
      -a, [--abstract=ABSTRACT]              # Defines a short description to abstract
      -p, [--target=TARGET]                  # Define the target directory
                                             # Default: .
          [--template=TEMPLATE]              # The template that will be used to create the extension. Expected values are: sql, c, fdw
                                             # Default: sql
      -r, [--release-status=RELEASE_STATUS]  # Initial extension's release status
      -d, [--description=DESCRIPTION]        # A long text that contains more information about extension
      -b, [--generated-by=GENERATED_BY]      # Name of extension's generator
      -l, [--license=LICENSE]                # The extension license
      -t, [--tags=one two three]             # Defines extension's tags
      -v, [--version=VERSION]                # Initial version
      -m, [--maintainer=MAINTAINER]          # Maintainer's name <maintainer@email>

    Creates an extension skeleton in current directory

    $ pgxn skeleton test
          create  test
          create  test/test.control
          create  test/.gitignore
          create  test/.template
          create  test/META.json
          create  test/Makefile
          create  test/README.md
          create  test/doc/test.md
          create  test/sql/test.sql
          create  test/sql/uninstall_test.sql
          create  test/test/expected/base.out
          create  test/test/sql/base.sql

    $ cd test/
    $ pgxn bundle
             run  make distclean from "."
          create  /tmp/test-0.0.1.zip

# Working in progress

* proxy support
* improve [git](http://git-scm.org) support
* improve custom templates

Copyright and License
---------------------

Copyright (c) 2011-2019 Dickson S. Guedes.

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
