package reflexunit.framework {
	import reflexunit.introspection.model.MethodModel;
	
	/**
	 * The provided test method has failed.
	 * The cause of this could be one of several things:
	 * <ul>
	 *   <li>An invalid test assertion</li>
	 *   <li>An asynchronous method did not execute within the specified timeout</li>
	 *   <li>A runtime error occurred during test execution</li>
	 * </ul>
	 */
	public class Failure implements IStatus {
		
		private var _error:Error;
		private var _methodModel:MethodModel;
		private var _numAsserts:int;
		
		/*
		 * Initialization
		 */
		
		/**
		 * Constructor.
		 */
		public function Failure( methodModelIn:MethodModel, errorIn:Error, numAssertsIn:int = 0 ) {
			_error = errorIn;
			_methodModel = methodModelIn;
			_numAsserts = numAssertsIn;
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
			return isFailure ? 'failure' : 'error';
		}
		
		/**
		 * @inheritDoc
		 */
		public function get test():* {
			return _methodModel.thisObject;
		}
	}
}