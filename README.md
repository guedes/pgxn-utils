pgxn utils
==========

What is it?
--------

It aims to be a set of task to help PostgreSQL extension's developers to focus more on the problem that they wants to solve than in the all structure and files and control files need to PGXS to build the extension.

How to install it?
------------------

    gem install pgxn_utils

How it works?
-------------

It is all about tasks. Let's see what tasks we have:

    $ pgxn_utils help
    Tasks:
      pgxn_utils bundle [extension_name]  # Bundles an extension.
      pgxn_utils change [extension_name]  # Change META's attributes in current extension.
      pgxn_utils help [TASK]              # Describe available tasks or one specific task
      pgxn_utils release filename         # Release a extension
      pgxn_utils skeleton extension_name  # Creates an extension skeleton in current directory.

# Creating a new extension

    $ pgxn_utils skeleton my_cool_extension
          create  my_cool_extension
          create  my_cool_extension/my_cool_extension.control
          create  my_cool_extension/META.json
          create  my_cool_extension/Makefile
          create  my_cool_extension/README.md
          create  my_cool_extension/doc/my_cool_extension.md
          create  my_cool_extension/sql/my_cool_extension.sql
          create  my_cool_extension/sql/uninstall_my_cool_extension.sql
          create  my_cool_extension/test/expected/base.out
          create  my_cool_extension/test/sql/base.sql

Thats it! Just start coding! ":)

# Changing something

Well suppose you want to change the default maintainer's name and the license, well just do:

    $ pgxn_utils change my_cool_extension --maintainer "Dickson Guedes" --license bsd
        conflict  META.json
    Overwrite /tmp/my_cool_extension/META.json? (enter "h" for help) [Ynaqdh] d
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
    Overwrite /tmp/my_cool_extension/META.json? (enter "h" for help) [Ynaqdh] Y
           force  META.json
       identical  my_cool_extension.control

It will wait you decide what to do.

For all switches that you can use with *change*, type:

    $ pgxn_utils help change
    Usage:
      pgxn_utils change [extension_name]
    
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
    
    Change META's attributes in current extension.

# Bundling and Releasing!

Well, since you finished your work you can bundle it to send to [PGXN](http://pgxn.org).

Bundle it:

    $ pgxn_utils bundle my_cool_extension
    Extension generated at: /home/guedes/extensions/my_cool_extension-0.0.1.zip

and release it:

    $ pgxn_utils release my_cool_extension-0.0.1.zip
    Enter your PGXN username: guedes
    Enter your PGXN password: ******
    Trying to release my_cool_extension-0.0.1.zip ... released successfully!
    Visit: https://manager.pgxn.org/distributions/my_cool_extension/0.0.1

You can export `PGXN_USER` and `PGXN_PASSWORD` environment variables to avoid
type username and password everytime.

# Working in progress

* [git](http://git-scm.org) support
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
