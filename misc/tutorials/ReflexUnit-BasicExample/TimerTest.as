package {
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import reflexunit.framework.TestCase;
	
	public class TimerTest extends TestCase {
		
		private var _timer:Timer;
		
		override public function setupTest():void {
			_timer = new Timer( 500, 1 );
		}
		
		override public function tearDownTest():void {
			_timer.removeEventListener( TimerEvent.TIMER_COMPLETE, onTimerComplete );
		}
		
		public function testTimerCompletes():void {
			_timer.addEventListener( TimerEvent.TIMER_COMPLETE, addAsync( onTimerComplete, 1000 ) );
			_timer.start();
			
			assertTrue( _timer.running, 'Timer should be running' );
		}
		
		private function onTimerComplete( event:TimerEvent ):void {
			assertFalse( _timer.running, 'Timer should not be running' );
		}
	}
}