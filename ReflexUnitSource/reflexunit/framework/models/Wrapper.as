package reflexunit.framework.models {
	import flash.events.ErrorEvent;
	import flash.events.Event;
	
	import reflexunit.framework.Assert;
	import reflexunit.framework.ITestCase;
	import reflexunit.framework.RunNotifier;
	import reflexunit.framework.TestCase;
	import reflexunit.framework.constants.TestConstants;
	import reflexunit.framework.errors.AssertFailedError;
	import reflexunit.framework.statuses.IStatus;
	import reflexunit.introspection.models.ArgModel;
	import reflexunit.introspection.models.MethodModel;
	import flash.utils.getTimer;
	
	/**
	 * Wraps a testable method as it is executed.
	 * This class has several responsibilities, including the following:
	 * <ul>
	 *   <li>Interpreting method outcome/status (see below)</li>
	 *   <li>Catching synchronous and asynchronous runtime errors</li>
	 * </ul>
	 * 
	 * The execution of a testable method will result in one of the following being added to the provided <code>Result</code>:
	 * <ul>
	 *   <li><code>Failure</code>: one or more tests defined in this method failed due to a runtime <code>Error</code> or an invalid assertion</li>
	 *   <li><code>Success</code>: all tests defined in this method have executed successfully</li>
	 * </ul>
	 *
	 * @see reflexunit.framework.models.Result
	 * @see reflexunit.framework.statuses.Failure
	 * @see reflexunit.framework.statuses.Success
	 */
	public class Wrapper {
		
		private var _asynchronousAssertions:Array;
		private var _methodModel:MethodModel;
		private var _numAsserts:int;
		private var _previousStatus:IStatus;
		private var _result:Result;
		private var _runNotifier:RunNotifier;
		private var _timeAtStart:int;
		
		/*
		 * Initialization
		 */
		
		/**
		 * Constructor
		 * 
		 * @param methodModelIn Test method to monitor and execute.
		 * @param resultIn Result object to add test status to
		 */
		public function Wrapper( methodModelIn:MethodModel, resultIn:Result ) {
			_methodModel = methodModelIn;
			_result = resultIn;
			
			_asynchronousAssertions = new Array();
			
			// TODO: Should we be using a brand new instance of the test-class for each test?
		}
		
		/**
		 * Executes the test method wrapped by this class.
		 */
		public function run( runNotifier:RunNotifier ):void {
			_runNotifier = runNotifier;
			
			setupTest();
			
			// Don't include setup time.
			_timeAtStart = getTimer();
			
			// Be sure to catch Errors (including AssertionFailedErrors) that occur synchronously.
			try {
				_methodModel.method.call( methodModel.thisObject );
				
				// Grab these values now; they're static and if another test is begun while this one is executing their values will be reset.
				_asynchronousAssertions = TestCase.asynchronousAssertions;
				
				_numAsserts = Assert.numAsserts;
				
			} catch ( error:Error ) {
				
				// Assertions may have occurred before the Error so retrieve them as well.
				_numAsserts = Assert.numAsserts;
				
				if ( error is AssertFailedError ) {
					
					// At this point, we must decide if the failure was expected.
					// If not then we should store the current failure as a failure.
					if ( !isFailureExpected() ) {
						_previousStatus = _result.addFailure( _methodModel, error as AssertFailedError, _numAsserts, runTime );
					} else {
						_previousStatus = _result.addSuccess( _methodModel, _numAsserts, runTime );
					}
					
				} else {
					_previousStatus = _result.addError( _methodModel, error, _numAsserts, runTime );
				}
				
				tearDownTest();
				
				return;
			}
			
			// If no AsynchronousAssertions were defined and no Error thrown then our test has succeeded.
			if ( !isAsync ) {
				_previousStatus = _result.addSuccess( _methodModel, _numAsserts, runTime );
				
				tearDownTest();
				
			} else {
				for each ( var asynchronousAssertion:AsynchronousAssertion in _asynchronousAssertions ) {
					asynchronousAssertion.addEventListener( ErrorEvent.ERROR, onAsynchronousAssertionError );
					asynchronousAssertion.addEventListener( Event.COMPLETE, onAsynchronousAssertionComplete );
				}
			}
		}
		
		/*
		 * Getter / setter methods
		 */
		
		/**
		 * Method currently executing has made one or more asynchronous assertions. 
		 */
		public function get isAsync():Boolean {
			return _asynchronousAssertions.length > 0;
		}
		
		/**
		 * The current test method is expected to fail.
		 * In this case, an <code>AssertFailedError</code> should actually result in a <code>Success</code>.
		 */
		public function isFailureExpected():Boolean {
			if ( _methodModel.metaDataModel ) {
				for each ( var argModel:ArgModel in _methodModel.metaDataModel.argModels ) {
					if ( argModel.key == TestConstants.METADATA_ARG_SHOULD_FAIL && argModel.value.toString() == 'true' ) {
						return true;
					}
				}
			}
			
			return false;
		}
		
		public function get methodModel():MethodModel {
			return _methodModel;
		}
		
		public function get previousStatus():IStatus {
			return _previousStatus;
		}
		
		public function get result():Result {
			return _result;
		}
		
		public function get runTime():int {
			return getTimer() - _timeAtStart;
		}
		
		/*
		 * Helper methods
		 */
		
		protected function finalizedAsynchronousAssertion( asynchronousAssertion:AsynchronousAssertion ):void {
			asynchronousAssertion.removeEventListener( ErrorEvent.ERROR, onAsynchronousAssertionError );
			asynchronousAssertion.removeEventListener( Event.COMPLETE, onAsynchronousAssertionComplete );
			
			// Remove model from Array as well.
			for ( var index:int = 0; index < _asynchronousAssertions.length; index++ ) {
				if ( _asynchronousAssertions[ index ] == asynchronousAssertion ) {
					_asynchronousAssertions.splice( index, 1 );
					
					break;
				}
			}
		}
		
		protected function setupTest():void {
			if ( _methodModel.thisObject is ITestCase ) {
				( _methodModel.thisObject as ITestCase ).setupTest();
			}
			
			_numAsserts = 0;
			
			Assert.resetNumAsserts();
			
			TestCase.resetStaticTestVars();
			
			_runNotifier.testStarting( _methodModel );
		}
		
		protected function tearDownTest():void {
			if ( _methodModel.thisObject is ITestCase ) {
				( _methodModel.thisObject as ITestCase ).tearDownTest();
			}
			
			_result.testsRun++;
			
			_runNotifier.testCompleted( _methodModel, _previousStatus );
		}
		
		/*
		 * Error handlers
		 */
		
		private function onAsynchronousAssertionComplete( event:Event ):void {
			var asynchronousAssertion:AsynchronousAssertion = event.currentTarget as AsynchronousAssertion;
			
			finalizedAsynchronousAssertion( asynchronousAssertion );
			
			_numAsserts += asynchronousAssertion.numAsserts;
			
			// If no more asynchronous assertions remain then the test has succeeded; Result should be updated with a Success
			if ( _asynchronousAssertions.length == 0 ) {
				_previousStatus = _result.addSuccess( _methodModel, _numAsserts, runTime );
				
				tearDownTest();
			}
		}
		
		private function onAsynchronousAssertionError( event:ErrorEvent ):void {
			var asynchronousAssertion:AsynchronousAssertion = event.currentTarget as AsynchronousAssertion;
			
			finalizedAsynchronousAssertion( asynchronousAssertion );
			
			_numAsserts += asynchronousAssertion.numAsserts;
			
			if ( asynchronousAssertion.error is AssertFailedError ) {
				
				// At this point, we must decide if the failure was expected.
				// If not then we should store the current failure as a failure a
				if ( !isFailureExpected() ) {
					_previousStatus = _result.addFailure( _methodModel, asynchronousAssertion.error as AssertFailedError, _numAsserts, runTime );
				} else {
					_previousStatus = _result.addSuccess( _methodModel, _numAsserts, runTime );
				}
				
			} else {
				_previousStatus = _result.addError( _methodModel, asynchronousAssertion.error, _numAsserts, runTime );
			}
			
			tearDownTest();
		}
	}
}