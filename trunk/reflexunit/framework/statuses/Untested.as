package reflexunit.framework.statuses {
	import reflexunit.introspection.models.MethodModel;
	
	/**
	 * Wrapper class used by some <code>IResultViewer</code> objects to indicate a test method that has not yet been executed.
	 * Once started, an <code>Untested</code> object will be replaced with an <code>InProgress</code>.
	 * 
	 * @see reflexunit.framework.statuses.InProgress
	 */
	public class Untested implements IStatus {
		
		private var _methodModel:MethodModel;
		
		/*
		 * Initialization
		 */
		
		/**
		 * Constructor.
		 */
		public function Untested( methodModelIn:MethodModel ) {
			_methodModel = methodModelIn;
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
			return 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get status():String {
			return 'new';
		}
		
		/**
		 * @inheritDoc
		 */
		public function get test():* {
			return _methodModel.thisObject;
		}
	}
}