package reflexunit.framework.tests {
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import reflexunit.framework.TestCase;
	
	public class FrameworkTest extends TestCase {
		
		/*
		 * Test that all assertion methods work.
		 */
		
		public function testAddAsync():void {
			var timer:Timer = new Timer( 100, 1 );
			timer.addEventListener( TimerEvent.TIMER_COMPLETE, addAsync( onTimerComplete, 1000 ) );
			timer.start();
		}
		
		[TestCase(shouldFail="true")]
		public function testAddAsyncFailureExpected():void {
			var timer:Timer = new Timer( 100, 1 );
			timer.addEventListener( TimerEvent.TIMER_COMPLETE, addAsync( onTimerComplete, 10 ) );
			timer.start();
		}
		
		public function testAssertEquals():void {
			assertEquals( 1, 1 );
		}
		
		public function testAssertFalse():void {
			assertFalse( false );
		}
		
		public function testAssertNotEquals():void {
			assertNotEquals( 1, 2 );
		}
		
		public function testAssertNotNull():void {
			assertNotNull(  new Object() );
		}
		
		public function testAssertNull():void {
			assertNull( null );
		}
		
		public function testAssertTrue():void {
			assertTrue( true );
		}
		
		[TestCase(shouldFail="true")]
		public function testFailureExpected():void {
			assertTrue( false );
		}
		
		/*
		 * Test that invalid values make our assert methods fail.
		 * TODO: Wrap these tests in an "expects-failure" block somehow.
		 */
		
		public function testAssertEqualsFails():void {
			assertEquals( 1, 2 );
		}
		
		public function testAssertFalseFails():void {
			assertFalse( true );
		}
		
		public function testAssertNotEqualsFails():void {
			assertNotEquals( 1, 1 );
		}
		
		public function testAssertNotNullFails():void {
			assertNotNull(  null );
		}
		
		public function testAssertNullFails():void {
			assertNull( new Object() );
		}
		
		public function testAssertTrueFails():void {
			assertTrue( false );
		}
		
		[TestCase(shouldFail="true")]	// Note that a 'failure' is not the same as an 'error'; this test should still fail.
		public function testAddAsyncError():void {
			var timer:Timer = new Timer( 100, 1 );
			timer.addEventListener( TimerEvent.TIMER_COMPLETE, addAsync( onTimerCompleteWithError, 1000 ) );
			timer.start();
		}
		
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