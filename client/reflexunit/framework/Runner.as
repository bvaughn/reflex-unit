package reflexunit.framework {
	import flash.events.EventDispatcher;
	
	import reflexunit.framework.display.IResultViewer;
	import reflexunit.framework.events.RunEvent;
	import reflexunit.framework.models.Description;
	import reflexunit.framework.models.Recipe;
	import reflexunit.framework.models.Result;
	import reflexunit.framework.models.Wrapper;
	import reflexunit.framework.statuses.IStatus;
	import reflexunit.introspection.models.MethodModel;
	
	/**
	 * This class is responsible for the high-level management of test execution.
	 * That includes the following actions:
	 * <ol>
	 *   <li>Convert a <code>TestSuite</code>, if provided, into a <code>Recipe</code> of testable methods</li>
	 *   <li>Execute each of those methods and store their outcome in a <code>Result</code> object</li>
	 *   <li>Inform a given set of <code>ITestWatcher</code> or <code>IResultViewer</code> objects of progress</li>
	 * </ol>
	 * 
	 * @see reflexunit.framework.display.IResultViewer
	 * @see reflexunit.framework.display.ITestWatcher
	 * @see reflexunit.framework.models.Recipe
	 * @see reflexunit.framework.RunNotifier
	 * @see reflexunit.framework.TestSuite
	 */
	public class Runner extends EventDispatcher implements ITestWatcher {
		
		private var _currentDescription:Description;
		private var _currentMethodModels:Array;
		private var _recipe:Recipe;
		private var _result:Result;
		private var _runNotifier:RunNotifier;
		private var _testingInProgress:Boolean;
		
		/*
		 * Initialization
		 */
		
		/**
		 * Construcor.
		 * 
		 * @param testSuiteOrRecipeIn TestSuite or custom/pre-built Recipe defining all testable methods to be executed
		 * 
		 * @throws ArgumentError if incoming testSuiteOrRecipeIn is neither a TestSuite nor a Recipe
		 */
		public function Runner( testSuiteOrRecipeIn:* ) {
			if ( testSuiteOrRecipeIn is TestSuite ) {
				_recipe = new Recipe( testSuiteOrRecipeIn as TestSuite );
			} else if ( testSuiteOrRecipeIn is Recipe ) {
				_recipe = testSuiteOrRecipeIn as Recipe;
			} else {
				throw ArgumentError( 'Parameter expected to be of type TestSuite or Recipe' );
			}
			
			_currentMethodModels = new Array();
		}
		
		/**
		 * Convenience method for creating and executing a <code>Runner</code> instance.
		 * This method will automatically run the newly created <code>Runner</code> and return its <code>Result</code> object.
		 * 
		 * @param testSuiteOrRecipeIn TestSuite or Recipe containing tests to be run
		 * @param testWatchers Array containing ITestWatcher or IResultViewer instances to be notified of test progress
		 * @param runNotifier (Optional) RunNotifier to use if caller wishes to be informed of progress
		 * @param resultIn (Optional) Result to store progress in; if no value is supplied a new Result will be created
		 * 
		 * @return Result object in which test outcomes will be stored
		 * 
		 * @throws TypeError if resultsViewer contains non-ITestWatcher object(s) 
		 */
		public static function create( testSuiteOrRecipeIn:*,
		                               testWatchers:Array,
		                               runNotifier:RunNotifier = null,
		                               resultIn:Result = null ):Result {
			
			var runner:Runner = new Runner( testSuiteOrRecipeIn );
			
			return runner.run( testWatchers, runNotifier, resultIn );
		}
		
		/**
		 * Executes the current test <code>Recipe</code> and returns a <code>Result</code> object.
		 * 
		 * @param testWatchers Array containing IResultViewer or ITestWatcher instances to be notified of test progress
		 * @param runNotifier (Optional) RunNotifier to use if caller wishes to be informed of progress
		 * @param resultIn (Optional) Result to store progress in; if no value is supplied a new Result will be created
		 * 
		 * @return Result object in which test outcomes will be stored
		 * 
		 * @throws TypeError if resultsViewer contains non-ITestWatcher object(s) 
		 */
		public function run( testWatchers:Array,
		                     runNotifier:RunNotifier = null,
		                     resultIn:Result = null ):Result {
			
			_result = resultIn ? resultIn : new Result();
			_runNotifier = runNotifier ? runNotifier : new RunNotifier();
			
			if ( testWatchers ) {
				for each ( var testWatcher:* in testWatchers ) {
					if ( !( testWatcher is ITestWatcher ) ) {
						throw new TypeError( 'Expected ITestWatcher instance' );
					}
					
					_runNotifier.addTestWatcher( testWatcher as ITestWatcher );
					
					if ( testWatcher is IResultViewer ) {
						var resultViewer:IResultViewer = testWatcher as IResultViewer;
						
						resultViewer.recipe = _recipe;
						resultViewer.result = _result;
					}
				}
			}
			
			runNextSeriesOfTests();
			
			return _result;
		}
		
		/*
		 * Getter / setter methods
		 */
		
		public function get result():Result {
			return _result;
		}
		
		/*
		 * Helper methods
		 */
		
		private function alertAllTestsCompleted():void {
			_runNotifier.allTestsCompleted();
			
			var event:RunEvent = new RunEvent( RunEvent.ALL_TESTS_COMPLETED );
			
			dispatchEvent( event );
		}
		
		private function alertTestStarting( methodModel:MethodModel ):void {
			_runNotifier.testStarting( methodModel );
			
			var event:RunEvent = new RunEvent( RunEvent.ALL_TESTS_COMPLETED );
			event.methodModel = methodModel;
			
			dispatchEvent( event );
		}
		
		private function alertTestCompleted( methodModel:MethodModel, status:IStatus ):void {
			_runNotifier.testCompleted( methodModel, status );
			
			var event:RunEvent = new RunEvent( RunEvent.ALL_TESTS_COMPLETED );
			event.methodModel = methodModel;
			event.status = status;
			
			dispatchEvent( event );
		}
		
		private function finalizeMethodModel( methodModel:MethodModel ):void {
			for ( var index:int = 0; index < _currentMethodModels.length; index++ ) {
				if ( methodModel.method == ( _currentMethodModels[ index ] as MethodModel ).method ) {
					_currentMethodModels.splice( index, 1 );
					
					break;
				}
			}
		}
		
		private function runNextSeriesOfTests():void {
			if ( _testingInProgress ) {
				return;
			}
			
			// If we do not have a current Description this means: (a) we should get the next one or (b) tests are all done. 
			if ( !_currentDescription ) {
				if ( _recipe.descriptions.length > 0 ) {
					_currentDescription = _recipe.descriptions.shift() as Description;
				} else {
					alertAllTestsCompleted();
					
					return;
				}
			}
			
			// If the current Description contains no more MethodModel objects, then it's time to run the next Description.
			if ( _currentDescription.methodModels.length == 0 ) {
				_currentDescription = null;
				
				return runNextSeriesOfTests();
			}
			
			// TRICKY: If the last MethodModel is being run for its given Description and it contains only synchronous tests, it will trigger testCompleted().
			// The testCompleted() method will check the remaining MethodModels, see that there are none, and re-trigger runNextSeriesOfTests().
			// For this one case only we need to set a blocking condition to prevent the second, concurrent execution.
			// Once the while loop has completed, it will check for the empty MethodModels and re-trigger runNextSeriesOfTests() anyway.
			_testingInProgress = true;
			
			// Run tests until: (a) we run out of them for this Description or (b) we reach a blocking test
			while ( _currentDescription.methodModels.length > 0 ) {
				var methodModel:MethodModel = _currentDescription.methodModels.shift() as MethodModel;
				var wrapper:Wrapper = new Wrapper( methodModel, _result );
				
				// No need to listen for a starting event; we are starting the test explicitly
				alertTestStarting( methodModel );
				
				var runNotifier:RunNotifier = new RunNotifier( [ this ] );
				
				wrapper.run( runNotifier );
				
				if ( wrapper.isAsync ) {
					_currentMethodModels.push( methodModel );
					
					// By default, test methods are not run in parallel.
					// If our test has not enabled this feature then we should pause until the current method has completed execution.
					if ( ! _currentDescription.allowParallelAsynchronousTests ) {
						break;
					}
					
				} else {
					alertTestCompleted( methodModel, wrapper.previousStatus );
				}
			}
			
			_testingInProgress = false;
			
			// If all tests in the current Description were synchronous then immediately run the next Description's tests.
			if ( _currentMethodModels.length == 0 ) {
				runNextSeriesOfTests();
			}
		}
		
		/*
		 * Error handlers
		 */
		
		
		public function allTestsCompleted():void {
		}
		
		public function testCompleted( methodModel:MethodModel, status:IStatus ):void {
			alertTestCompleted( methodModel, status );
			
			finalizeMethodModel( methodModel );
			
			if ( _currentMethodModels.length == 0 ) {
				runNextSeriesOfTests();
			}
		}
		
		public function testStarting( methodModel:MethodModel ):void {
		}
	}
}