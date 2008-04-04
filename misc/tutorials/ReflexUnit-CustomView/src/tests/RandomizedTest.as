package tests {
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import reflexunit.framework.TestCase;
	
	public class RandomizedTest extends TestCase {
		
		private var _errorOnTimerEvent:Boolean;
		private var _timer:Timer;
		
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