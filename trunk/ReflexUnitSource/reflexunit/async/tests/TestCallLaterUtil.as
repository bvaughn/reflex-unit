package reflexunit.async.tests {
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import mx.core.Application;
	
	import reflexunit.async.CallLaterUtil;
	import reflexunit.framework.TestCase;
	
	[ExcludeClass]
	public class TestCallLaterUtil extends TestCase {
		
		private var _errors:Array;
		private var _frameCountExpired:Boolean;
		private var _framesRemaining:int;
		private var _previousMilliseconds:int;
		private var _targetMilliseconds:int;
		private var _timeExpired:Boolean;
		private var _timer:Timer;
		
		/*
		 * Initialization
		 */
		
		override public function setupTest():void {
			mx.core.Application.application.addEventListener( Event.ENTER_FRAME, onEnterFrame, false, int.MAX_VALUE );
			
			_errors = new Array();
			
			_frameCountExpired = false;
			_timeExpired = false;
			
			_framesRemaining = 0;
			_targetMilliseconds = 0;
		}
		
		override public function tearDownTest():void {
			mx.core.Application.application.removeEventListener( Event.ENTER_FRAME, onEnterFrame );
		}
		
		/*
		 * Test methods
		 */
		
		public function testAccessorFrameDelay():void {
			_framesRemaining = 5;
			
			CallLaterUtil.accessorFrameDelay( this, 'testAccessorFrame', 5, 5 );
			
			_timer = new Timer( 1000, 1 );
			_timer.addEventListener( TimerEvent.TIMER_COMPLETE, addAsync( onTimerComplete, 2000 ), false, 0, true );
			_timer.start();
		}
		
		public function testAccessorTimeDelay():void {
			_targetMilliseconds = getTimer() + 1000;
			
			CallLaterUtil.accessorTimeDelay( this, 'testAccessorTime', 1000 );
			
			_timer = new Timer( 2000, 1 );
			_timer.addEventListener( TimerEvent.TIMER_COMPLETE, addAsync( onTimerComplete, 4000 ), false, 0, true );
			_timer.start();
		}
		
		public function testFunctionFrameDelay():void {
			_framesRemaining = 3;
			
			CallLaterUtil.functionFrameDelay( this, testMethodFrame, [ 3 ] );
			
			_timer = new Timer( 500, 1 );
			_timer.addEventListener( TimerEvent.TIMER_COMPLETE, addAsync( onTimerComplete, 1000 ), false, 0, true );
			_timer.start();
		}
		
		public function testFunctionTimeDelay():void {
			_targetMilliseconds = getTimer() + 300;
			
			CallLaterUtil.functionTimeDelay( this, testMethodTime, [ 300 ], 300 );
			
			_timer = new Timer( 600, 1 );
			_timer.addEventListener( TimerEvent.TIMER_COMPLETE, addAsync( onTimerComplete, 1200 ), false, 0, true );
			_timer.start();
		}
		
		/*
		 * Delayed methods
		 */
		
		public function set testAccessorFrame( frames:int ):void {
			if ( _frameCountExpired ) {
				_errors.push( 'CallLaterUtil.accessorFrameDelay executed late (expected: 0, actual: ' + _framesRemaining + ')' );
			} else if ( _framesRemaining > 0 ) {
				_errors.push( 'CallLaterUtil.accessorFrameDelay executed early (expected: 0, actual: ' + _framesRemaining + ')' );
			}
		}
		
		public function set testAccessorTime( milliseconds:int ):void {
			if ( _timeExpired ) {
				_errors.push( 'CallLaterUtil.accessorTimeDelay executed late (expected: ' + _targetMilliseconds + ', actual: ' + getTimer() + ')' );
			} else if ( getTimer() < _targetMilliseconds ) {
				_errors.push( 'CallLaterUtil.accessorTimeDelay executed early (expected: ' + _targetMilliseconds + ', actual: ' + getTimer() + ')' );
			}
		}
		
		private function testMethodFrame( frames:int ):void {
			if ( _frameCountExpired ) {
				_errors.push( 'CallLaterUtil.functionFrameDelay executed late (expected: 0, actual: ' + _framesRemaining + ')' );
			} else if ( _framesRemaining > 0 ) {
				_errors.push( 'CallLaterUtil.functionFrameDelay executed early (expected: 0, actual: ' + _framesRemaining + ')' );
			}
		}
		
		private function testMethodTime( milliseconds:int ):void {
			if ( _timeExpired ) {
				_errors.push( 'CallLaterUtil.functionTimeDelay executed late (expected: ' + _targetMilliseconds + ', actual: ' + getTimer() + ')' );
			} else if ( getTimer() < _targetMilliseconds ) {
				_errors.push( 'CallLaterUtil.functionTimeDelay executed early (expected: ' + _targetMilliseconds + ', actual: ' + getTimer() + ')' );
			}
		}
		
		/*
		 * Helper methods
		 */
		
		private function onEnterFrame( event:Event ):void {
			if ( _targetMilliseconds > 0 ) {
				if ( _previousMilliseconds > _targetMilliseconds ) {
					_timeExpired = true;
				}
			} else {
				_framesRemaining--;
				
				if ( _framesRemaining < 0 ) {
					_frameCountExpired = true;
				}
			}
			
			// Catch time here to allow for slight innacuracies (due to varying framerates).
			_previousMilliseconds = getTimer();
		}
		
		private function onTimerComplete( event:TimerEvent ):void {
			var message:String = _errors.length > 0 ? _errors[0] as String : null;
			
			assertEquals( _errors.length, 0, message );
		}
	}
}