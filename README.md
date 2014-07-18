# matlab-xunit

xUnit for Matlab with JUnit-compatible XML output

# README

Testing is wonderful! Let's make it easier and more rewarding!

The most popular testing platform for MATLAB functions and classes is/was Steve Eddins' excellent [Matlab xUnit](http://www.mathworks.com/matlabcentral/fileexchange/22846-matlab-xunit-test-framework) package.

The previous maintainer, [Thomas Smith](https://github.com/tgs/), made two additions to that package: the ability to give output in a JUnit-compatible XML format, and the ability to run DocTests, similar to the ``doctest`` module in Python or vignettes in R.

I've made one additional change: renaming ``runtests`` to ``runxunit`` so that it's compatible with MATLAB R2013a and newer. (``runtests`` is now a built-in function.)

# XML Output

Why would you want to do that?  Well, because other tools understand it. In particular, I'm using the Jenkins continuous integration system (http://jenkins-ci.org/) to automatically run unit tests when I check in code. Jenkins understands JUnit's XML report format, and can display it in very nice ways. By creating a test report file in the same format, we can leverage all of that.

For example, here's a screenshot of the table Jenkins generates from a single build's report:

![Jenkins test results](doc/images/jenkins_test_results.png)

And here's a graph of the test trend:

![Jenkins trend graph](doc/images/jenkins_trend_graph.png)

