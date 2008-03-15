package reflexunit.framework.events {
	import flash.events.Event;
	
	import reflexunit.framework.TestSuite;
	import reflexunit.framework.models.Description;
	import reflexunit.framework.statuses.IStatus;
	import reflexunit.introspection.models.MethodModel;
	
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
		 * A test case (ie. all of its testable methods) has completed.
		 */
		public static const TEST_CASE_COMPLETED:String = 'TEST_CASE_COMPLETED';
		
		/**
		 * A test case is starting.
		 */
		public static const TEST_CASE_STARTING:String = 'TEST_CASE_COMPLETED';
		
		/**
		 * A single test method has completed.
		 */
		public static const TEST_COMPLETED:String = 'TEST_COMPLETED';
		
		/**
		 * A single test method is about to be run.
		 */
		public static const TEST_STARTING:String = 'TEST_STARTING';
		
		/*
		 * Variables
		 */
		
		private var _description:Description;
		private var _methodModel:MethodModel;
		private var _status:IStatus;
		private var _testSuite:TestSuite;
		
		/*
		 * Initialization
		 */
		
		public function RunEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) {
			super( type, bubbles, cancelable );
		}
		
		/*
		 * Getter / setter methods
		 */
		
		public function get description():Description {
			return _description;
		}
		public function set description( value:Description ):void {
			_description = value;
		}
		
		public function get methodModel():MethodModel {
			return _methodModel;
		}
		public function set methodModel( value:MethodModel ):void {
			_methodModel = value;
		}
		
		public function get status():IStatus {
			return _status;
		}
		public function set status( value:IStatus ):void {
			_status = value;
		}
		
		public function get testSuite():TestSuite {
			return _testSuite;
		}
		public function set testSuite( value:TestSuite ):void {
			_testSuite = value;
		}
		
		/**
		 * Class defining a set of testable methods.
		 * This class may define the <code>ITestCase</code> interface (though it is not required to).
		 */
		public function get test():* {
			if ( _methodModel ) {
				return _methodModel.thisObject;
			} else if ( _description ) {
				return _description.introspectionUtil.classModel.instance;
			} else {
				return null;
			}
		}
	}
}