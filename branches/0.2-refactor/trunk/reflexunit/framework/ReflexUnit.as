package reflexunit.framework {
	import reflexunit.introspection.model.MethodModel;
	
	
	/**
	 * This class is responsible for the high-level management of test execution.
	 * This includes the following actions:
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
	 * 
	 * @internal
	 * TODO: Consider renaming this class; it's kind of a crappy/generic name.
	 */
	public class ReflexUnit {
		
		private var _currentDescriptionIndex:int;
		private var _currentMethodModelIndex:int;
		private var _recipe:Recipe;
		private var _result:Result;
		private var _runNotifier:RunNotifier;
		private var _testSuite:TestSuite;
		
		/*
		 * Initialization
		 */
		
		public function ReflexUnit( testSuiteIn:TestSuite ) {
			_recipe = new Recipe( testSuiteIn );
			_testSuite = testSuiteIn;
			
			_result = new Result();
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
			_runNotifier = runNotifier ? runNotifier : new RunNotifier();
			
			_currentDescriptionIndex = 0;
			_currentMethodModelIndex = 0;
			
			for ( var index:int = 0; index < resultViewers; index++ ) {
				var resultViewer:IResultViewer = resultViewers[ index ] as IResultViewer;
				
				if ( !resultViewer ) {
					throw new TypeError( 'Expected IResultViewer instance' );
				}
				
				resultViewer.runNotifier = _runNotifier;
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
		
		private function runNextSeriesOfTests():void {
			if ( _currentMethodModelIndex >= description.methodModels.length ) {
				_currentMethodModelIndex = 0;
				
				_currentDescriptionIndex++;
			}
			
			if ( _currentDescriptionIndex >= _recipe.descriptions.length ) {
				// TODO: Mark as completed (provided no tests are pending).
			}
			
			var description:Description = _recipe.descriptions[ _currentDescriptionIndex ] as Description;
			var methodModel:MethodModel = description.methodModels[ _currentMethodModelIndex ] as MethodModel;
			
			var wrapper:Wrapper = new Wrapper( methodModel );
			wrapper.run( _result );
			
			// TODO: Check for serialization.
			
			// TODO: Check for completion. (This should be factored into helper methods).
		}
	}
}