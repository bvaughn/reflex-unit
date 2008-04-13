package reflexunit.framework.statuses {
	import reflexunit.introspection.models.MethodModel;
	
	/**
	 * Base implementation of <code>IStatus</code> meant to be overridden by specific status types.
	 */
	[ExcludeClass]
	public class AbstractStatus implements IStatus {
		
		private var _methodModel:MethodModel;
		private var _numAsserts:int;
		private var _time:int;
		
		/*
		 * Initialization
		 */
		
		/**
		 * Constructor.
		 */
		public function AbstractStatus( methodModelIn:MethodModel, numAssertsIn:int = 0, timeIn:int = 0 ) {
			_methodModel = methodModelIn;
			_numAsserts = numAssertsIn;
			_time = timeIn;
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
			throw new Error( 'AbstractStatus "status" method must be overriden' );
		}
		
		/**
		 * @inheritDoc
		 */
		public function get test():* {
			return _methodModel ? _methodModel.thisObject : null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get time():int {
			return _time;
		}
	}
}