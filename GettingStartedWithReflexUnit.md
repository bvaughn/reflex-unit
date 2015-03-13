by [Brian Vaughn](mailto:boynamedbri@gmail.com)

# Setting Up #

First let's create a new Flex Project in Flex Builder. If you haven't already done so you will also need to download a Reflex Unit SWC from the [downloads section](http://code.google.com/p/reflex-unit/downloads/list).

To association the SWC with your project, do the following:
  1. In Flex Builder, right-click on the project you've created and select the "Properties" option
  1. Go to the "Flex Build Path" tab and the click on the "Library Path" sub-tab
  1. Choose "Add SWC" and browse to where you saved the Reflex Unit SWC

Now we're ready to begin.

# Writing Your First Test #

Reflex Unit supports several ways of creating tests and defining a collection of test methods. For our example we'll demonstrate the simplest method (and probably most commonly used). Rather than write example code to test we'll further simplify by testing one of the built-in Flash classes, `Timer`.

Create a new ActionScript class named "TimerTest" that extends the [TestCase](http://reflex-unit.googlecode.com/svn/trunk/ReflexUnitSource/docs/reflexunit/framework/TestCase.html) class. For now, define the following empty methods:

```
override public function setupTest():void {
}

override public function tearDownTest():void {
}
```

The `setupTest` and `tearDownTest` methods are not required. Overriding them however provides our test class with an easy mehcnanism to perform pre-test and post-test operations. The Reflex Unit test runner will call these methods automatically, before/after each test method is executed. For the purposes of our test, we'll not be needing either method but it helps it to know that they are available.

Next let's create an empty test method. By default, Reflex Unit automatically executes a method as a test if it meets the following conditions:
  1. The name begins with "test"
  1. The method excepts no parameters
  1. The method has a return type of `void`

Given this let's create a method named `testTimer` with a void return type:

```
public function testTimerCompletes():void {
}
```

Reflex unit supports both synchronous and asynchronous testing. Test results are verified by [assertions](http://reflex-unit.googlecode.com/svn/trunk/ReflexUnitSource/docs/reflexunit/framework/Assert.html). An assertion is a statement of an expected condition. If the expected condition is not met then a test is considered to have failed. (This is true unless the test method has been marked as an expected-failure. See the [Description](http://reflex-unit.googlecode.com/svn/trunk/ReflexUnitSource/docs/reflexunit/framework/models/Description.html) documentation for more info.)

For the purposes of our example test, we'll make a synchronous assertion as well as an asynchronous one. Let's go ahead and fill in our test class:

```
package {
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import reflexunit.framework.TestCase;
	
	public class TimerTest extends TestCase {
		
		private var _timer:Timer;
		
		override public function setupTest():void {
		}
		
		override public function tearDownTest():void {
		}
		
		public function testTimerCompletes():void {
			_timer = new Timer( 500, 1 );
			_timer.addEventListener( TimerEvent.TIMER_COMPLETE, addAsync( onTimerComplete, 1000 ) );
			_timer.start();
			
			assertTrue( _timer.running, 'Timer should be running' );
		}
		
		private function onTimerComplete( event:TimerEvent ):void {
			_timer.removeEventListener( TimerEvent.TIMER_COMPLETE, onTimerComplete );
			
			assertFalse( _timer.running, 'Timer should not be running' );
		}
	}
}
```

Our test now asserts 2 things:
  1. Starting our `Timer` sets its "running" state to true
  1. Our Timer fires a completion event within the allotted time

Let's take a closer look at this second assertion. To test asynchronous behavior our test method uses the [addAsync](http://reflex-unit.googlecode.com/svn/trunk/ReflexUnitSource/docs/reflexunit/framework/TestCase.html#addAsync()) method. This method _must_ be used in the context of a call to `addEventListener`. It takes a few parameters, but the two most significant are:
  * The event listener method defined by your test class
  * A timeout, or maximum allowable time (in milliseconds) before the test should be considered a failure

In our above test we've create a `Timer` that should complete in 500 milliseconds. We then tell `addAsync` that it should allow up to 1000 milliseconds before considering the timer to have failed.

We now have a usable test, but how do we run it?

# Choosing a Test Runner #

Reflex Unit provides several methods of running a suite of tests and viewing the results. For our purposes we'll use the graphical display, [Flex Viewer](http://reflex-unit.googlecode.com/svn/trunk/ReflexUnitSource/docs/reflexunit/framework/display/flexviewer/FlexViewer.html).

Invoking it is easy. All it needs is a [Recipe](http://reflex-unit.googlecode.com/svn/trunk/ReflexUnitSource/docs/reflexunit/framework/models/Recipe.html). (A `Recipe` is simply a collection of tests that should be run.) We can pass `Flex Viewer` our newly created test as follows:

```
<?xml version="1.0" encoding="utf-8"?>
<mx:Application width="100%" height="100%" layout="absolute"
                initialize="onInitialize( event )"
                xmlns:flexviewer="reflexunit.framework.display.flexviewer.*"
                xmlns:mx="http://www.adobe.com/2006/mxml">
	
	<mx:Script>
		<![CDATA[
			import mx.events.FlexEvent;
			
			import reflexunit.framework.models.Recipe;
			import reflexunit.framework.TestSuite;
			
			private function onInitialize( event:FlexEvent ):void {
				flexViewer.controller.recipe = new Recipe( new TestSuite( [ TimerTest ] ) );
			}
		]]>
	</mx:Script>
	
	<flexviewer:FlexViewer id="flexViewer" width="100%" height="100%" />
	
</mx:Application>
```

That's it! Running the above `Application` will display a graphical interface for running our test and viewing its results. To add more tests, we simply pass additional classes to the [TestSuite](http://reflex-unit.googlecode.com/svn/trunk/ReflexUnitSource/docs/reflexunit/framework/TestSuite.html) constructor.

# Continuous Integration #

Although a graphical test runner is useful for developers, often times production code is tested with a continuous integrate tool such as [Cruise Control](http://cruisecontrol.sourceforge.net/). Reflex Unit provides a test runner for this very purpose: [Cruise Control Logger](http://reflex-unit.googlecode.com/svn/trunk/ReflexUnitSource/docs/reflexunit/framework/display/CruiseControlLogger.html).)

To run our above test using the Cruise Control Logger, we can start by creating a new ActionScript class that extends Sprite. It should look like this:

```
package {

	import flash.display.Sprite;
	
	import reflexunit.framework.Runner;
	import reflexunit.framework.TestSuite;
	import reflexunit.framework.display.CruiseControlLogger;
	
	public class CruiseControlDemo extends Sprite {
		public function CruiseControlDemo() {
			Runner.create( new TestSuite( [ TimerTest ] ), [ new CruiseControlLogger() ] );
		}
	}
}
```

Viewing our test case in this runner will output the following to our Flex console:

```
-----------------TESTRUNNEROUTPUTBEGINS----------------
Test Suite success: true
<testsuites time="516">
  <testsuite name="TimerTest">
    <testcase time="516" name="testTimerCompletes"/>
  </testsuite>
</testsuites>
-----------------TESTRUNNEROUTPUTBEGINS----------------
```

# In Closing #

I hope you have found this tutorial helpful. We've only scratched the surface of the types of testing that is possible but you now have a foundation on which to build. For further information I recommend the following sources:
  * [Reflex Unit documentation](http://reflex-unit.googlecode.com/svn/trunk/ReflexUnitSource/docs/index.html)
  * [FAQs](http://code.google.com/p/reflex-unit/wiki/FAQs) and [How-To](http://code.google.com/p/reflex-unit/wiki/HOWTOList) wiki pages

If the links above don't lead you to an answer, feel free to contact one of our project owners (listed on the right side of the [home page](http://code.google.com/p/reflex-unit/)).