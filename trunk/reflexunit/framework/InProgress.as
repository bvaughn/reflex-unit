package reflexunit.framework {
	import reflexunit.introspection.model.MethodModel;
	
	/**
	 * 
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
		public function get status():String {
			return 'in progress';
		}
		
		/**
		 * @inheritDoc
		 */
		public function get testCase():* {
			return _methodModel.thisObject;
		}
	}
}