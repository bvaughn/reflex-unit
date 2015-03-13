# Part 3: Creating a Sample Test Suite #

If you would like a more detailed explanation of creating Reflex Unit tests, see the [Getting Started Guide](GettingStartedWithReflexUnit.md). For the purposes of this tutorial we are simply going to create a dummy "test" that executes asynchronously and returns random values (success, failure, or error).

By executing asynchronously we will be able to watch our viewer update itself in real time as each test is completed. To do this, we'll use the built in Flash `Timer`. Let's define our test as follows:

## RandomizedTest.as ##

```
package tests {
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import reflexunit.framework.TestCase;
	
	public class RandomizedTest extends TestCase {
		
		private var _errorOnTimerEvent:Boolean;
		private var _timer:Timer;
		
		// These dummy methods will each be executed since they begin with "test".
		// See: http://reflex-unit.googlecode.com/svn/trunk/ReflexUnitSource/docs/reflexunit/framework/models/Description.html
		public function test0():void { testMethodHelper(); }
		public function test1():void { testMethodHelper(); }
		public function test2():void { testMethodHelper(); }
		public function test3():void { testMethodHelper(); }
		public function test4():void { testMethodHelper(); }
		public function test5():void { testMethodHelper(); }
		public function test6():void { testMethodHelper(); }
		public function test7():void { testMethodHelper(); }
		public function test8():void { testMethodHelper(); }
		public function test9():void { testMethodHelper(); }
		
		// This helper method will create random, asynchronous test results.
		private function testMethodHelper( minTime:int = 250, maxTime:int = 500 ):void {
			var timerTime:int = minTime + ( Math.random() * ( maxTime - minTime ) ); 
			var timeOutTime:int;
			
			var random:Number = Math.random();
			
			// 65% chance of success
			if ( random < .65 ) {
				_errorOnTimerEvent = false;
				
				timeOutTime = maxTime * 2;
				
			// 25% chance of failure
			} else if ( random < .9 ) {
				_errorOnTimerEvent = false;
				
				timeOutTime = minTime / 2;
				
			// 10% chance of runtime error
			} else {
				_errorOnTimerEvent = true;
				
				timeOutTime = maxTime * 2;
			}
			
			_timer = new Timer( timerTime, 1 );
			_timer.addEventListener( TimerEvent.TIMER_COMPLETE, addAsync( onTimerComplete, timeOutTime ) );
			_timer.start();
			
			assertTrue( _timer.running, 'Timer should be running' );
		}
		
		// At this point our test could still fail, error, or succeed.
		private function onTimerComplete( event:TimerEvent ):void {
			_timer.removeEventListener( TimerEvent.TIMER_COMPLETE, onTimerComplete );
			
			if ( _errorOnTimerEvent ) {
				throw new Error( 'This is an expected error' );
			}
			
			var maxIndex:int = Math.round( Math.random() * 6 );
			
			for ( var index:int = 0; index <= maxIndex; index++ ) {
				assertTrue( true );
			}
			
			assertFalse( _timer.running, 'Timer should not be running' );
		}
	}
}
```

We've now created a legitimate (although contrived) test that can be run within the Reflex Unit framework. This test consists of 10 testable methods (`test0` - `test9`) each resulting in a random outcome.

In reality an application will rarely contain only a single test class. Because of this we will be designing a viewer that displays results with multiple test classes in mind. For this purpose it would be useful if we had more than just one test to run in our sample viewer. This can easily be achieved by extending our `RandomizedTest` class.

Create as many sub-classes as you would like. An example is as follows:

## TestSubClass.as ##

```
package tests {
	public class TestSubClass extends RandomizedTest {}
}
```

At this point you may wish to see your example tests in action. This can be done easily! Simple update your main Application component as follows (replacing the example `TestSubClass` component with the sub-classes you created in the previous step):

## Main.mxml ##

```
<?xml version="1.0" encoding="utf-8"?>
<mx:Application width="100%" height="100%" layout="absolute"
                backgroundColor="0xFFFFFF" backgroundGradientColors="[ 0xFFFFFF, 0xFFFFFF ]"
                initialize="onInitialize( event )"
                xmlns:local="*"
                xmlns:mx="http://www.adobe.com/2006/mxml">
	
	<mx:Script>
		<![CDATA[
			import mx.events.FlexEvent;
			
			import reflexunit.framework.models.Recipe;
			import reflexunit.framework.TestSuite;
			
			import tests.TestSubClass;
			
			private function onInitialize( event:FlexEvent ):void {
				viewer.controller.recipe = new Recipe(
					new TestSuite( [ TestSubClass ] ) );
			}
		]]>
	</mx:Script>
	
	<local:CustomResultViewer id="viewer" width="100%" height="100%" />
	
</mx:Application>
```

You are now ready to run your application if you wish. At this point nothing fancy will happen, but you will see console output indicating that your test results and times.

## [Continue to Part 4..](WritingYourOwnCustomViewer4.md) ##