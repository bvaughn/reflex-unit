package reflexunit.framework.statuses {
	import reflexunit.introspection.models.MethodModel;
	
	/**
	 * Indicates that all assertions made by the assocated test method were accurate and no runtime errors occured.
	 * (This class may also be used to indicate that an assertion failed if metadata was present to specify that a failure was expected.)
	 */
	public class Success implements IStatus {
		
		private var _methodModel:MethodModel;
		private var _numAsserts:int;
		private var _time:int;
		
		/*
		 * Initialization
		 */
		
		/**
		 * Constructor.
		 */
		public function Success( methodModelIn:MethodModel, numAssertsIn:int = 0, time:int = 0 ) {
			_methodModel = methodModelIn;
			_numAsserts = numAssertsIn;
			_time = time;
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
		
		/**
		 * @inheritDoc
		 */
		public function get time():int {
			return _time;
		}
	}
}