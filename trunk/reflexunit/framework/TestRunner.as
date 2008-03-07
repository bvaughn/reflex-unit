package reflexunit.framework {
	import reflexunit.introspection.model.MethodModel;
	
	/**
	 * Runs a single testable method and translates its output/results to a <code>Result</code> object.
	 * 
	 * 
	 * @internal
	 * TODO: Rename this class to "Runner" and the current "Runner" to "ReflexUnit" (or something).
	 */
	public class TestRunner {
		
		private var _methodModel:MethodModel;
		
		public function TestRunner( methodModelIn:MethodModel ) {
			_methodModel = methodModelIn;
		}
		
		/**
		 * 
		 */
		public function run( result:Result, runNotifier:RunNotifier ):Boolean {
			
		}
		
		public function get methodModel():MethodModel {
			return _methodModel;
		}
	}
}