package reflexunit.framework {
	import reflexunit.introspection.model.MethodModel;
	
	public class Success implements IStatus {
		
		private var _methodModel:MethodModel;
		
		/*
		 * Initialization
		 */
		
		/**
		 * Constructor.
		 */
		public function Success( methodModelIn:MethodModel ) {
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