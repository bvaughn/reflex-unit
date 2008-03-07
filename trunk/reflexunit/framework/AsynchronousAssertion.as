package reflexunit.framework {
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * Wrapper class used to contain a single test method call to <code>TestCase.addAsync</code>.
	 * 
	 * This class will dispatch an <code>Event.COMPLETE</code> event to indicate that the asynchronous assertion completed successfully.
	 * It will dispatch and <code>ErrorEvent.ERROR</code> error to indicate that the assertion failed.
	 * Failure can be due to a runtime <code>Error</code> or an <code>AssertFailedError</code>; in either case, this value will be stored in <code>error</code>.
	 */
	public class AsynchronousAssertion extends EventDispatcher {
		
		private var _error:Error;
		private var _eventHandler:Function;
		private var _failureMessageFunction:Function;
		private var _failureMessageFunctionArgs:Array;
		private var _thisObject:*;
		private var _timer:Timer;
		private var _timeout:int;
		
		/*
		 * Initialization
		 */
		
		public function AsynchronousAssertion( thisObject:*,
		                                       eventHandler:Function,
		                                       timeout:int = 1000,
		                                       failureMessageFunction:Function = null,
		                                       failureMessageFunctionArgs:Array = null ) {
			
			_eventHandler = eventHandler;
			_failureMessageFunction = failureMessageFunction;
			_failureMessageFunctionArgs = failureMessageFunctionArgs;
			_thisObject = thisObject;
			_timeout = timeout;
			
			_timer = new Timer( timeout, 1 );
			_timer.addEventListener( TimerEvent.TIMER_COMPLETE, onTimerComplete );
			_timer.start();
		}
		
		/*
		 * Getter / setter methods
		 */
		
		/**
		 * An <code>Error</code> may have occurred during the execution of this asynchronous assertion.
		 * If so this is a reference to that <code>Error</code> (or <code>AssertionFailedError</code>).
		 */
		public function get error():Error {
			return _error;
		}
		
		/**
		 * Inline/wrapper <code>Event</code> handler method.
		 */
		public function get wrapperFunction():Function {
			return onEvent;
		}
		
		/*
		 * Helper methods
		 */
		
		/**
		 * Helper method used by <code>addAsycn</code>.
		 * If the function returned by this method executes before the specified Timer handler then our test was a success.
		 */
		private function onEvent( event:Event ):void {
			event.currentTarget.removeEventListener( event.type, onEvent );
			
			// Do not pass through to the wrapped function if the assertion has already failed (ie. timed-out).
			if ( !_timer.running ) {
				return;
			}
			
			// Remove strong event reference.
			_timer.removeEventListener( TimerEvent.TIMER_COMPLETE, onTimerComplete ); 
			_timer.stop();
			
			// Errors (including AssertFailedErrors) can occur in asynchronous handlers too; be sure to catch them.
			try {
				_eventHandler.call( _thisObject, event );
			} catch ( error:Error ) {
				_error = error;
				
				dispatchEvent( new ErrorEvent( ErrorEvent.ERROR ) );
				
				return;
			}
			
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		/**
		 * Helper method used by <code>addAsycn</code>.
		 * If this Timer event handler, defined by this method, executes before the below wrapper then our test has failed.
		 * Note that a failure may be what is expected, in which case the test is actually a success.
		 */
		private function onTimerComplete( event:TimerEvent ):void {
			
			// Remove strong event reference.
			// We don't need to remove the original listener; we don't pass the Event through once the Timer stops 
			event.currentTarget.removeEventListener( TimerEvent.TIMER_COMPLETE, wrapperFunction );
			
			var errorMessage:String;
			
			// If a failure handler has been provided, use its custom message.
			if ( _failureMessageFunction != null ) {
				try {
					errorMessage = _failureMessageFunction.apply( _thisObject, _failureMessageFunctionArgs ) as String;
				} catch ( error:Error ) {}
			}
			
			if ( !errorMessage ) {
				errorMessage = 'Asynchronous function was not executed in ' + _timeout + 'ms';
			}
			
			_error = new AssertFailedError( errorMessage );
			
			dispatchEvent( new ErrorEvent( ErrorEvent.ERROR ) );
		}
	}
}