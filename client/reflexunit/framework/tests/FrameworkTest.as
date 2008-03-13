package reflexunit.framework.tests {
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import reflexunit.framework.TestCase;
	
	[ExcludeClass]
	public class FrameworkTest extends TestCase {
		
		/*
		 * Test that all assertion methods work.
		 */
		
		[Test]
		public function metaDataTestCaseSupported():void {
			assertTrue( true );
		}
		
		public function testAddAsync():void {
			var timer:Timer = new Timer( 100, 1 );
			timer.addEventListener( TimerEvent.TIMER_COMPLETE, addAsync( onTimerComplete, 1000 ) );
			timer.start();
		}
		
		[Test(shouldFail="true")]
		public function testAddAsyncFailureExpected():void {
			var timer:Timer = new Timer( 100, 1 );
			timer.addEventListener( TimerEvent.TIMER_COMPLETE, addAsync( onTimerComplete, 10 ) );
			timer.start();
		}
		
		/*
		 * Test that invalid values make our assert methods fail.
		 * TODO: Wrap these tests in an "expects-failure" block somehow.
		 */
		
		/**
		 * Note that a 'failure' is not the same as an 'error'; this test should still result in an error.
		 * 
		 * @internal
		 * TODO: Wrap this somehow so that the error doesn't display in the test runner
		 */
		[Test(shouldFail="true")]
		public function testAddAsyncError():void {
			var timer:Timer = new Timer( 100, 1 );
			timer.addEventListener( TimerEvent.TIMER_COMPLETE, addAsync( onTimerCompleteWithError, 1000 ) );
			timer.start();
		}
		
		[Test(shouldFail="true")]
		public function testAddAsyncFails():void {
			var timer:Timer = new Timer( 100, 1 );
			timer.addEventListener( TimerEvent.TIMER_COMPLETE, addAsync( onTimerComplete, 10 ) );
			timer.start();
		}
		
		/*
		 * Test that the test properly handles runtime errors.
		 */
		
		public function testRunTimeError():void {
			var a:Array = new Array();
			a[1].fakeProperty;
		}
		
		/*
		 * None of these methods should be executed.
		 */
		
		public function doesNotBeginWithTest():void {
			throw new Error( 'Invalid method executed: doesNotBeginWithTest()' );
		}
		
		public function testInTheNameButExpectsArguments( arg1:String, arg2:Boolean = true ):Boolean {
			throw new Error( 'Invalid method executed: testInTheNameButExpectsArguments()' );
		}
		
		public function testInTheNameButNonVoidReturnType():String {
			throw new Error( 'Invalid method executed: testInTheNameButNonVoidReturnType()' );
		}
		
		/*
		 * Event handlers.
		 */
		
		private function onTimerComplete( event:TimerEvent ):void {
			assertTrue( event.currentTarget is Timer );
		}
		
		private function onTimerCompleteWithError( event:TimerEvent ):void {
			var obj:Object;
			obj[0];	// Cause a RTE to be thrown to make sure the testing framework catches it.
		}
	}
}