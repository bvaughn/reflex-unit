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
		 * @inheritDoc
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
		 * @inheritDoc
		 */
		public function get test():* {
			return _methodModel.thisObject;
		}
	}
}