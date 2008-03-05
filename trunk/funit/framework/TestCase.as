package funit.framework {
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import funit.introspection.model.MethodModel;
	import funit.introspection.util.IntrospectionUtil;
	
	/**
	 * Base implementation of <code>ITest</code> interface.
	 * This class provides a bootstrap implementation of the <code>run</code> method but no runnable tests.
	 * To create runnable tests, you may extend this class and define <code>public</code> test methods.
	 * 
	 * Subclasses of this class may implement an optional <code>public static</code> method named <code>testMethods</code>.
	 * This method should return an <code>Array</code> of functions that are to be tested.
	 * In this event, all methods not included in the returned <code>Array</code> will be ignored.
	 * An example implementation of this method is as follows:
	 * <code>
	 * public static function testMethods():Array {
	 * 	return new Array();
	 * }
	 * </code>
	 * 
	 * If no such <code>testMethods</code> method is defined, all methods meeting the following conditions are automatically run:
	 * <ul>
	 *   <li>name starts with "test"</li>
	 *   <li>accepts no parameters</li>
	 *   <li>return type of <code>void</code></li>
	 * </ul>
	 * 
	 * It is useful to also note that many tests may be asynchronous in nature.
	 * If this is the case, the name of the function defining this test should begin with "testAsync".
	 * An example is as follows:
	 * <code>
	 * public function testAsynchTimer():void {
	 * 	var timer:Timer = new Timer( 100, 1 );
	 * 	timer.addEventListener( TimerEvent.TIMER_COMPLETE, addAsync( onTimerComplete, 1000 ), false, 0, true );
	 * 	timer.start();
	 * }
	 * </code>
	 */
	public class TestCase extends Assert implements ITest {
		
		private var _description:Description;
		private var _name:String;
		private var _currentTestIndex:int = -1;
		private var _numAsycTests:int;
		private var _result:Result;
		private var _runNotifier:RunNotifier;
		
		/*
		 * Initialization
		 */
		
		public function TestCase() {
			_description = new Description( this );
		}
		
		/*
		 * Public methods
		 */
		
		/**
		 * Add an asynchronous check point to the test.
		 * This method will return an event handler function.
		 * 
		 * @param eventHandler The Function to execute once the related event has successfully occurred
		 * @param timeout The maximum allowable time (in ms) the event may not fire before it is considered a failure
		 * @param failureMessageFunction Optional method to provide a custom error message in the event of a failure
		 * @param failureMessageFunctionArgs Optional argumetns to pass to the failureMessageFunction
		 */
		public function addAsync( eventHandler:Function,
		                          timeout:int = 1000,
		                          failureMessageFunction:Function = null,
		                          failureMessageFunctionArgs:Array = null ):Function {
			
			_numAsycTests++;
			
			// If this Timer event handler executes before the below wrapper consider it a failure.
			var onTimerComplete:Function = function( event:TimerEvent ):void {
				var message:String = 'Asynchronous function was not executed in ' + timeout + 'ms';
				
				// If a failure handler has been provided, use its custom message.
				if ( failureMessageFunction != null ) {
					message = failureMessageFunction.apply( this, failureMessageFunctionArgs ) as String;
				}
				
				// Don't throw the Error but rather, add it directly to the Result.
				// (We have no way to catch a thrown error in an asynchronous test.)
				 _result.addFailure( currentTestMethodModel,
				                     new AssertFailedError( message ) );
				 
				runNextTest();
			}
			
			var timer:Timer = new Timer( timeout, 1 );
			timer.addEventListener( TimerEvent.TIMER_COMPLETE, onTimerComplete );
			timer.start();
			
			// If this wrapper executes before the above Timer handler our test was a success.
			var eventHandlerWrapper:Function = function( event:Event ):void {
				
				// Do not pass through to the wrapped function if the assertion has already failed (ie. timed-out).
				if ( !timer.running ) {
					return;
				}
				
				timer.removeEventListener( TimerEvent.TIMER_COMPLETE, onTimerComplete );
				timer.stop();
				
				eventHandler.call( this, event );
				
				_numAsycTests--;
				
				runNextTest();
			}
			
			return eventHandlerWrapper;
		}
		
		/**
		 * @inheritDoc
		 */
		public function run( result:Result, runNotifier:RunNotifier ):void {
			_currentTestIndex = -1;
			_result = result;
			_runNotifier = runNotifier;
			
			runNextTest();
		}
		
		private function runNextTest():void {
			if ( _currentTestIndex >= 0 ) {
				_runNotifier.testCompleted( currentTestMethodModel );
			}
			
			_currentTestIndex++;
			
			_numAsycTests = 0;
			
			// Once no more tests are left to run, alert the RunNotifier and return.
			// The container ITest (or Runner) will take things from here.
			if ( _currentTestIndex >= _description.methodModels.length ) {
				_runNotifier.allTestsCompleted();
				
				return;
			}
			
			var methodModel:MethodModel = _description.methodModels[ _currentTestIndex ] as MethodModel;
			
			setup();
			
			try {
				_runNotifier.testStarting( currentTestMethodModel );
				
				methodModel.method.call( methodModel.thisObject );
				
			} catch ( error:Error ) {
				_numAsycTests = 0;
				
				if ( error is AssertFailedError ) {
					_result.addFailure( methodModel, error as AssertFailedError );
				} else {
					_result.addError( methodModel, error );
				}
			}
			
			tearDown();
			
			_result.testsRun++;
			
			if ( _numAsycTests == 0 ) {
				runNextTest();
			}
		}
		
		/*
		 * Getter / setter methods
		 */
		
		/**
		 * @inheritDoc
		 */
		public function get currentTestMethodModel():MethodModel {
			if ( _currentTestIndex >= _description.methodModels.length ) {
				return null;
			}
			
			return _description.methodModels[ _currentTestIndex ] as MethodModel;
		}
		
		/**
		 * @see funit.framework.Description
		 */
		public function get description():Description {
			return _description;
		}
		
		/**
		 * Gets the name of a TestCase.
		 */
		public function get name():String {
			return _name;
		}
		public function set name( value:String ):void {
			_name = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get testCount():int {
			return _description.testCount;
		}
		
		/*
		 * Helper methods
		 */
		
		/**
		 * Causes the current test to intentionally fail with an optional message.
		 */
		protected function fail( message:String = null ):void {
			throw new AssertFailedError( message ? message : 'Test was instructed to fail.' );
		}
		
		/**
		 * Sets up the fixture, for example, open a network connection.
		 * This method may be overriden as necessary.
		 */
		protected function setup():void {
		}
		
		/**
		 * Tears down the fixture, for example, close a network connection.
		 * This method may be overriden as necessary.
		 */
		protected function tearDown():void {
		}
	}
}