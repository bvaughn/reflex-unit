package reflexunit.framework {
	import flash.events.Event;
	
	import reflexunit.introspection.model.MethodModel;
	
	/**
	 * Dispatched by a <code>RunNotifier</code> to indicate a significant test event.
	 * 
	 * @see reflexunit.framework.RunNotifier
	 */
	public class RunEvent extends Event {
		
		/**
		 * All tests in the current <code>TestSuite</code> have finished executing.
		 */
		public static const ALL_TESTS_COMPLETED:String = 'ALL_TESTS_COMPLETED';
		
		/**
		 * A single test method has completed.
		 */
		public static const TEST_COMPLETED:String = 'TEST_COMPLETED';
		
		/**
		 * A single test method is about to be run.
		 */
		public static const TEST_STARTING:String = 'TEST_STARTING';
		
		// TODO: Add more notify events.
		
		/*
		 * Variables
		 */
		
		private var _methodModel:MethodModel;
		
		/*
		 * Initialization
		 */
		
		public function RunEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) {
			super( type, bubbles, cancelable );
		}
		
		/*
		 * Getter / setter methods
		 */
		
		public function get methodModel():MethodModel {
			return _methodModel;
		}
		public function set methodModel( value:MethodModel ):void {
			_methodModel = value;
		}
		
		/**
		 * Class defining a set of testable methods.
		 * This class may define the <code>ITestCase</code> interface (though it is not required to).
		 */
		public function get test():* {
			return _methodModel ? _methodModel.thisObject : null;
		}
	}
}