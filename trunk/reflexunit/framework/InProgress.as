package reflexunit.framework {
	import reflexunit.introspection.model.MethodModel;
	
	/**
	 * Wrapper class used by some <code>IResultViewer</code> objects to indicate a test method that has not completed execution.
	 * Once completed, an <code>InProgress</code> object will be replaced with a <code>Success</code> or a <code>Failure</code>.
	 * 
	 * @see reflexunit.framework.Failure
	 * @see reflexunit.framework.Success
	 */
	public class InProgress implements IStatus {
		
		private var _methodModel:MethodModel;
		
		/*
		 * Initialization
		 */
		
		/**
		 * Constructor.
		 */
		public function InProgress( methodModelIn:MethodModel ) {
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
			return 'in progress';
		}
		
		/**
		 * @inheritDoc
		 */
		public function get test():* {
			return _methodModel.thisObject;
		}
	}
}