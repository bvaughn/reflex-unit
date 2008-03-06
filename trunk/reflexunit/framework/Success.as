package reflexunit.framework {
	import reflexunit.introspection.model.MethodModel;
	
	public class Success implements IStatus {
		
		private var _methodModel:MethodModel;
		private var _numAsserts:int;
		
		/*
		 * Initialization
		 */
		
		/**
		 * Constructor.
		 */
		public function Success( methodModelIn:MethodModel, numAssertsIn:int = 0 ) {
			_methodModel = methodModelIn;
			_numAsserts = numAssertsIn;
		}
		
		/*
		 * Getter / setter methods
		 */
		
		/**
		 * @inheritDoc
		 */
		public function get methodModel():MethodModel {
			return _methodModel;
		}
		
		/**
		 * 
		 */
		public function get numAsserts():int {
			return _numAsserts;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get status():String {
			return 'sucess';
		}
		
		/**
		 * <code>TestCase</code> object running when failure occurred.
		 */
		public function get testCase():TestCase {
			return _methodModel.thisObject as TestCase;
		}
	}
}