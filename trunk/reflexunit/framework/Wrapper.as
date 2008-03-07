package reflexunit.framework {
	import flash.events.ErrorEvent;
	import flash.events.Event;
	
	import reflexunit.introspection.model.ArgModel;
	import reflexunit.introspection.model.MethodModel;
	
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
	 *   <li>Failure: one or more tests defined in this method failed due to a runtime <code>Error</code> or an invalid assertion</li>
	 *   <li>Success: all tests defined in this method have executed successfully</li>
	 * </ul>
	 *
	 * @see reflexunit.framework.Failure
	 * @see reflexunit.framework.Success
	 */
	public class Wrapper {
		
		private var _asynchronousAssertions:Array;
		private var _methodModel:MethodModel;
		private var _numAsserts:int;
		private var _result:Result;
		private var _runNotifier:RunNotifier;
		
		/*
		 * Initialization
		 */
		
		public function Wrapper( methodModelIn:MethodModel, resultIn:Result ) {
			_methodModel = methodModelIn;
			_result = resultIn;
			
			_asynchronousAssertions = new Array();
			_numAsserts = 0;
			
			// TODO: Should we be using a brand new instance of the test-class for each test?
		}
		
		/**
		 * Executes the test method wrapped by this class.
		 */
		public function run( runNotifier:RunNotifier ):void {
			_runNotifier = runNotifier;
			
			setupTest();
			
			// Be sure to catch Errors (including AssertionFailedErrors) that occur synchronously.
			try {
				_methodModel.method.call( methodModel.thisObject );
				
				// Grab these values now; they're static and if another test is begun while this one is executing their values will be reset.
				_asynchronousAssertions = TestCase.asynchronousAssertions;
				_numAsserts = Assert.numAsserts;
				
			} catch ( error:Error ) {
				if ( error is AssertFailedError ) {
					
					// At this point, we must decide if the failure was expected.
					// If not then we should store the current failure as a failure a
					if ( !isFailureExpected() ) {
						_result.addFailure( _methodModel, error as AssertFailedError );
					}
					
				} else {
					_result.addError( _methodModel, error );
				}
				
				tearDownTest();
			}
			
			// If no AsynchronousAssertions were defined and no Error thrown then our test has succeeded.
			if ( !isAsync ) {
				_result.addSuccess( _methodModel, _numAsserts );
				
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
		 * Method defined in the provided <code>MethodModel</code> has elected to force serial execution.
		 * 
		 * No other tests should be run until this method has completed its assertions.
		 * All previously executed asynchronous tests should be allowed to complete before this method is started.
		 */
		public function get forceSerialExecution():Boolean {
			if ( _methodModel.metaDataModel ) {
				for each ( var argModel:ArgModel in _methodModel.metaDataModel.argModels ) {
					if ( argModel.key == '' ) {
						if ( argModel.value == '' ) {
							
							// Even if the test has specified that it must execute in isolation, this only holds if it is asynchronous.
							return isAsync;
						}
						
						break;
					}
				}
			}
			
			return false;
		}
		
		/**
		 * Method currently executing has made one or more asynchronous assertions. 
		 */
		public function get isAsync():Boolean {
			return _asynchronousAssertions.length > 0;
		}
		
		public function get methodModel():MethodModel {
			return _methodModel;
		}
		
		public function get result():Result {
			return _result;
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
		
		protected function isFailureExpected():Boolean {
			if ( _methodModel.metaDataModel ) {
				for each ( var argModel:ArgModel in _methodModel.metaDataModel.argModels ) {
					if ( argModel.key == TestCase.METADATA_ARG_SHOULD_FAIL && argModel.value.toString() == 'true' ) {
						return true;
					}
				}
			}
			
			return false;
		}
		
		protected function setupTest():void {
			if ( _methodModel.thisObject is ITestCase ) {
				( _methodModel.thisObject as ITestCase ).setupTest();
			}
			
			Assert.resetNumAsserts();
			
			TestCase.resetStaticTestVars();
			
			_runNotifier.testStarting( _methodModel );
		}
		
		protected function tearDownTest():void {
			if ( _methodModel.thisObject is ITestCase ) {
				( _methodModel.thisObject as ITestCase ).tearDownTest();
			}
			
			_result.testsRun++;
			
			_runNotifier.testCompleted( _methodModel );
		}
		
		/*
		 * Error handlers
		 */
		
		private function onAsynchronousAssertionComplete( event:Event ):void {
			finalizedAsynchronousAssertion( event.currentTarget as AsynchronousAssertion );
			
			// If no more asynchronous assertions remain then the test has succeeded; Result should be updated with a Success
			if ( _asynchronousAssertions.length == 0 ) {
				_result.addSuccess( _methodModel, _numAsserts );
				
				tearDownTest();
			}
		}
		
		private function onAsynchronousAssertionError( event:ErrorEvent ):void {
			var asynchronousAssertion:AsynchronousAssertion = event.currentTarget as AsynchronousAssertion;
			
			finalizedAsynchronousAssertion( asynchronousAssertion );
			
			if ( asynchronousAssertion.error is AssertFailedError ) {
				
				// At this point, we must decide if the failure was expected.
				// If not then we should store the current failure as a failure a
				if ( !isFailureExpected() ) {
					_result.addFailure( _methodModel, asynchronousAssertion.error as AssertFailedError );
				} else {
					_result.addSuccess( _methodModel, _numAsserts );
				}
				
			} else {
				_result.addError( _methodModel, asynchronousAssertion.error );
			}
			
			tearDownTest();
		}
	}
}