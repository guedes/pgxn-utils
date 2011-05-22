pgxn utils
==========

What is?
--------

This is a set of task that aims to help PostgreSQL developers to focus more on the problem that they wants to solve than in the all structure and files and control files need to PGXS to build the extension.

It's a WIP but very functional. Please use it and help me improve it.

How to install it?
------------------

    gem install pgxn_utils

How it works?
-------------

    $ pgxn_utils help skeleton
    Usage:
      pgxn_utils skeleton extension_name

    Options:
      -p, [--target=TARGET]                    # Define the target directory
                                               # Default: .
      -m, [--maintainer=MAINTAINER]            # Maintainer's name
      -e, [--maintainer-mail=MAINTAINER_MAIL]  # Maintainer's mail
      -a, [--abstract=ABSTRACT]                # Defines a short description to abstract
      -l, [--license=LICENSE]                  # The extension license.
      -v, [--version=VERSION]                  # Initial version
      -d, [--description=DESCRIPTION]          # A long text that contains more information about extension
      -b, [--generated-by=GENERATED_BY]        # Name of extension's generator
      -t, [--tags=one two three]               # Defines extension's tags
      -r, [--release-status=RELEASE_STATUS]    # Initial extension's release status

See in action...

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

Thats it! Start coding! ":)

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
