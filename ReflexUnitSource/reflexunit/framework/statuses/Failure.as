package reflexunit.framework.statuses {
	import reflexunit.framework.errors.AssertFailedError;
	import reflexunit.introspection.models.MethodModel;
	
	/**
	 * The provided test method has failed.
	 * The cause of this could be one of several things:
	 * <ul>
	 *   <li>An invalid test assertion</li>
	 *   <li>An asynchronous method did not execute within the specified timeout</li>
	 *   <li>A runtime error occurred during test execution</li>
	 * </ul>
	 * 
	 * <p>This class contains an <code>isFailure</code> method to differentiate between assertion failures and runtime errors.</p>
	 */
	public class Failure extends AbstractStatus {
		
		private var _error:Error;
		
		/*
		 * Initialization
		 */
		
		/**
		 * Constructor.
		 */
		public function Failure( methodModelIn:MethodModel, errorIn:Error, numAssertsIn:int = 0, time:int = 0 ) {
			super( methodModelIn );
			
			_error = errorIn;
		}
		
		/*
		 * Getter / setter methods
		 */
		
		/**
		 * Error describing the runtime issue encountered by the related <code>TestCase</code>.
		 */
		public function get error():Error {
			return _error;
		}
		
		/**
		 * Error message string.
		 * 
		 * If <code>isFailure</code> is TRUE, this value may be unique to the failed test (or it may be generic).
		 */
		public function get errorMessage():String {
			return _error.message;
		}
		
		/**
		 * Instance contains a <code>failure</code> not an <code>error</code>.
		 * See class comments for more.
		 */
		public function get isFailure():Boolean {
			return _error is AssertFailedError;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get status():String {
			return isFailure ? 'failure' : 'error';
		}
	}
}