package reflexunit.framework.tests {
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import reflexunit.framework.TestCase;
	
	public class SampleTest extends TestCase {
		
		public function SampleTest() {
			super();
		}
		
		/*
		 * Small sample test methods.
		 */
		
		public function testBasicAssertTest():void {
			assertEquals( 1, 1 );
			assertFalse( false );
			assertTrue( true );
		}
		
		public function testAsynchTimer():void {
			var timer:Timer = new Timer( 100, 1 );
			timer.addEventListener( TimerEvent.TIMER_COMPLETE, addAsync( onTimerComplete, 1000 ) );
			timer.start();
		}
		
		public function testAsynchTimerTheTimesOut():void {
			var timer:Timer = new Timer( 100, 1 );
			timer.addEventListener( TimerEvent.TIMER_COMPLETE, addAsync( onTimerComplete, 10 ) );
			timer.start();
		}
		
		public function testThatResultsInError():void {
			var a:Array = new Array();
			a[1].fakeProperty;
		}
		
		public function testFailedEquals():void {
			assertEquals( 1, 2, '1 should equal 1' );
		}
		
		public function testFailedFalse():void {
			assertFalse( true );
		}
		
		public function testFailedTrue():void {
			assertTrue( false );
		}
		
		/*
		 * None of these methods should be executed.
		 */
		
		public function doesNotBeginWithTest():void {
		}
		
		public function testInTheNameButExpectsArguments( arg1:String, arg2:Boolean = true ):Boolean {
			return true;
		}
		
		public function testInTheNameButNonVoidReturnType():String {
			return 'String';
		}
		
		/*
		 * Event handlers.
		 */
		
		private function onTimerComplete( event:TimerEvent ):void {
			assertTrue( event.currentTarget is Timer );
		}
	}
}