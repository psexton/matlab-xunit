Matlab xUnit Plus Goodies
=========================

README
------

Testing is wonderful!  Let's make it easier and more rewarding!

The most popular testing platform for MATLAB functions and classes is
Steve Eddins' excellent `Matlab xUnit`_ package.

.. _`Matlab xUnit`: http://www.mathworks.com/matlabcentral/fileexchange/22846-matlab-xunit-test-framework

The previous maintainer, Thomas Smith, made two additions to that package:  
the ability to give output in a JUnit-compatible XML format, and the 
ability to run DocTests, similar to the ``doctest`` module in Python or 
vignettes in R.

I've made one additional change: renaming ``runtests`` to ``runxunit`` so
that it's compatible with MATLAB R2013a and newer. (``runtests`` is now a 
built-in function.)

XML Output
----------

Why would you want to do that?  Well, because other tools understand it.  In
particular, I'm using the Jenkins continuous integration system
(http://jenkins-ci.org/) to automatically run unit tests when I check in code,
and make a pretty graph of my progress in writing tests and fixing bugs.  You
can see a screenshot of Jenkins' `table generated from this data`_.  Here's a
graph of the test trend.

.. image:: http://tgs.github.com/images/test-graph.png

.. _`table generated from this data`: http://tgs.github.com/images/test-table.png

The implementation is based on `xml_io_tools`_ by Jaroslaw Tuszynski, which
is a nice way to generate XML in Matlab.  It uses about 1/3 the lines of
code as Matlab's built-in ``xmlwrite``.

.. _`xml_io_tools`: http://www.mathworks.com/matlabcentral/fileexchange/12907-xmliotools

Usage
~~~~~

To use this feature, grab either the ``master`` or ``xml`` branches from
GitHub, and put the ``xunit-matlab-doctest/xunit`` directory on your
MATLAB path (using ``addpath``).

Once you've written some unit tests (see `xUnit's help`_), you can then run::

    runxunit path/to/test/dir -xmlfile testreport.xml

Unsurprisingly, this will run your unit tests and put the results into
``testreport.xml`` in the current directory.

.. _`xUnit's help`: http://www.mathworks.com/matlabcentral/fx_files/22846/11/content/matlab_xunit/doc/xunit_product_page.html

Usage with Jenkins
~~~~~~~~~~~~~~~~~~

OK, this is really cool, but involves some setup.  First, you're going
to have to either install Jenkins on the machine that has Matlab, or
give Jenkins remote access to that machine (there may be Matlab
licensing issues to this, I have no idea).  As a note, installing
Jenkins is incredibly easy: you download one file and run one command.

Now, you need to create a job that checks out your code from Subversion
or whatever, and then runs your tests.  I'm not going to run you through
the whole thing, but here are the two important points:

First, you need a build step that will run the tests.  Mine looks
something like this::

    /path/to/matlab -nodisplay -r "try; \
        addpath /path/to/xunit-matlab-doctest/xunit; \
        runxunit -xmlfile testreport.xml the_tests/; \
      catch Ex; fprintf(2, Ex.getReport()); quit(1); end; \
      quit(0);"

And second, you need to check the Jenkins box that says "Publish JUnit
test result report."  I tell it to look at ``**/testreport.xml``.

Now save the configuration, tell the project to Build Now, and you should have
a lovely display of what tests were run, and which failed!

DocTests
--------

*(WARNING: DocTests is an experimental feature and not part of the officially supported public API.)*

What are these good for?  Well, often it's nice to have examples in your
documentation.  Well, now you can automatically run those examples to
make sure that they still produce the expected output.  This helps
prevent documentation rot.

If you're doing serious testing, it's best not to use DocTests for that,
because real unit testing frameworks like xUnit are much more flexible
and powerful.  In addition, documentation is supposed to be
documentation, and if you fill up your help file with lots of arcane
manipulations, no one will thank you.

What does a DocTest look like?  Here's a simple one::

        function sum = add2(num)
        %add2 Add two to a number
        %
        % Example:
        %
        % >> add2(88)
        % ans =
        %   90
        %

        sum = num + 2;

The DocTest system also has a limited ability to detect that an expected
exception was thrown, e.g. if you want to make sure an error message is
printed.  It is not sensitive to whitespace (it collapses all whitespace
to a single space when comparing the real result with the example).  It
also supports ``***`` as a wildcard.

Running
~~~~~~~

The method for causing DocTests to be run is a little bit in flux.  For
the moment, the best way is to copy the ``testDocTestsHere.m`` file from
``xunit/`` into a directory that contains functions with doctests.  Then,
you can use the normal xUnit ``runxunit`` function to run both unit and
doctests.

