## About Reflex Unit ##

**Reflex Unit** is a testing framework for **Flex 2** and **Flex 3** applications. It is designed to be a drop-in replacement for Flex Unit (although minor code changes will be required).

Reflex Unit offers the following features:
  * Testing framework uses reflection, eliminating the need to manually declare each test method. Simply specify the name of a class containing testable methods (see [documentation](http://reflex-unit.googlecode.com/svn/trunk/ReflexUnitSource/docs/reflexunit/framework/models/Description.html) for more) and they will be automatically added to the TestSuite.

  * Test cases are not required to extend a base testing class. Using Reflex Unit, test methods may be defined within the classes they are testing. Tests may optionally implement an `ITestCase` interface (or extend the included `TestCase` class) to be notified of _setup_ and _teardown_ events.

  * Multiple asynchronous tests may execute in parallel. By default, Reflex Unit will only execute one test method at a time. However, using the available [metadata markup](http://reflex-unit.googlecode.com/svn/trunk/ReflexUnitSource/docs/reflexunit/framework/models/Description.html), methods may be tagged to run in parallel for faster overall testing times.

  * Multiple output styles and formats are included by default, including:
    * **ConsoleViewer** - A simple debugging application that prints the status and result of each test method
    * **CruiseControlLogger** - An XML logger for use with [Cruise Control](http://cruisecontrol.sourceforge.net/)
    * **FlexViewer** - A graphical debugger application providing feedback about: test status, errors/failures, & execution time; (try available [demo](http://reflex-unit.googlecode.com/files/ReflexUnitDemo.zip))

  * Reflex Unit will also soon include an Eclipse plug-in to run tests, view results, and jump directly to a source code view for failed assertions. More information to come shortly!