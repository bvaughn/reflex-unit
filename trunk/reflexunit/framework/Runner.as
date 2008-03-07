package reflexunit.framework {
	import flash.events.EventDispatcher;
	
	import reflexunit.introspection.model.MethodModel;
	
	/**
	 * This class is responsible for the high-level management of test execution.
	 * That includes the following actions:
	 * <ol>
	 *   <li>Convert a <code>TestSuite</code> into a <code>Recipe</code> of testable methods</li>
	 *   <li>Execute each of those methods and store their outcome in a <code>Result</code> object</li>
	 *   <li>Inform a given set of <code>IResultViewer</code> objects of its progress by way of a <code>RunNotifier</code> method</li>
	 * </ol>
	 * 
	 * @see reflexunit.framework.IResultViewer
	 * @see reflexunit.framework.Recipe
	 * @see reflexunit.framework.RunNotifier
	 * @see reflexunit.framework.TestSuite
	 */
	public class Runner {
		
		private var _currentDescription:Description;
		private var _currentMethodModels:Array;
		private var _recipe:Recipe;
		private var _result:Result;
		private var _resultViewers:Array;
		private var _runNotifier:RunNotifier;
		private var _testSuite:TestSuite;
		
		/*
		 * Initialization
		 */
		
		public function Runner( testSuiteIn:TestSuite ) {
			_testSuite = testSuiteIn;
			
			_currentMethodModels = new Array();
			_recipe = new Recipe( _testSuite );
			_result = new Result();
		}
		
		public static function create( testSuiteIn:TestSuite, resultViewers:Array, runNotifier:RunNotifier = null ):Result {
			var runner:Runner = new Runner( testSuiteIn );
			
			return runner.run( resultViewers, runNotifier );
		}
		
		/**
		 * Executes the current test <code>Recipe</code> and returns a <code>Result</code> object.
		 * 
		 * @param resultViewers Array containing IResultViewer instances to be notified of test progress
		 * @param runNotifier (Optional) RunNotifier to use if caller wishes to be informed of progress
		 * 
		 * @return Result object in which test outcomes will be stored
		 * 
		 * @throws TypeError if resultsViewer contains non-IResultViewer object(s) 
		 */
		public function run( resultViewers:Array, runNotifier:RunNotifier = null ):Result {
			_resultViewers = resultViewers;
			_runNotifier = runNotifier ? runNotifier : new RunNotifier();
			
			for ( var index:int = 0; index < _resultViewers.length; index++ ) {
				var resultViewer:IResultViewer = resultViewers[ index ] as IResultViewer;
				
				if ( !resultViewer ) {
					throw new TypeError( 'Expected IResultViewer instance' );
				}
				
				resultViewer.recipe = _recipe;
				resultViewer.result = _result;
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
		
		public function get testSuite():TestSuite {
			return _testSuite;
		}
		
		/*
		 * Helper methods
		 */
		
		private function alertAllTestsCompleted():void {
			_runNotifier.allTestsCompleted();
			
			for each ( var resultViewer:IResultViewer in _resultViewers ) {
				resultViewer.allTestsCompleted();
			}
		}
		
		private function alertTestStarting( methodModel:MethodModel ):void {
			_runNotifier.testStarting( methodModel );
			
			for each ( var resultViewer:IResultViewer in _resultViewers ) {
				resultViewer.testStarting( methodModel );
			}
		}
		
		private function alertTestCompleted( methodModel:MethodModel ):void {
			_runNotifier.testCompleted( methodModel );
			
			for each ( var resultViewer:IResultViewer in _resultViewers ) {
				resultViewer.testCompleted( methodModel );
			}
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
			
			// Run tests until: (a) we run out of them for this Description or (b) we reach a blocking test
			while ( _currentDescription.methodModels.length > 0 ) {
				var methodModel:MethodModel = _currentDescription.methodModels.shift() as MethodModel;
				
				var wrapper:Wrapper = new Wrapper( methodModel, _result );
				
				// If current test has asked to run in isolation, do not run it if other tests are executing.
				if ( wrapper.forceSerialExecution && _currentMethodModels.length > 0 ) {
					_currentDescription.methodModels.unshift( methodModel );
					
					break;
				}
				
				var runNotifier:RunNotifier = new RunNotifier();
				runNotifier.addEventListener( RunEvent.TEST_COMPLETED, onTestCompleted );
				runNotifier.addEventListener( RunEvent.TEST_STARTING, onTestStarting );
				
				wrapper.run( runNotifier );
				
				_currentMethodModels.push( methodModel );
				
				// If current test has asked to run in isolation, prevent other tests from running until it has completed.
				if ( wrapper.forceSerialExecution ) {
					break;
				}
			}
		}
		
		/*
		 * Error handlers
		 */
		
		private function onTestCompleted( event:RunEvent ):void {
			( event.currentTarget as EventDispatcher ).removeEventListener( RunEvent.TEST_COMPLETED, onTestCompleted );
			
			alertTestCompleted( event.methodModel );
			
			finalizeMethodModel( event.methodModel );
			
			if ( _currentMethodModels.length == 0 ) {
				runNextSeriesOfTests();
			}
		}
		
		private function onTestStarting( event:RunEvent ):void {
			( event.currentTarget as EventDispatcher ).removeEventListener( RunEvent.TEST_STARTING, onTestStarting );
			
			alertTestStarting( event.methodModel );
		}
	}
}