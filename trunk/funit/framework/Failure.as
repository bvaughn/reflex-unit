package funit.framework {
	import funit.introspection.model.MethodModel;
	
	/**
	 * Relates a <code>TestCase</code> and an error or failure.
	 * 
	 * The test framework distinguishes between failures and errors.
	 * A failure is anticipated and checked for with assertions.
	 * Errors are unanticipated problems like an RangeError.
	 */
	public class Failure implements IStatus {
		
		private var _error:Error;
		private var _methodModel:MethodModel;
		
		/*
		 * Initialization
		 */
		
		/**
		 * Constructor.
		 */
		public function Failure( methodModelIn:MethodModel, errorIn:Error ) {
			_error = errorIn;
			_methodModel = methodModelIn;
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
		public function get status():String {
			return isFailure ? 'failure' : 'error';
		}
		
		/**
		 * <code>TestCase</code> object running when failure occurred.
		 */
		public function get testCase():TestCase {
			return _methodModel.thisObject as TestCase;
		}
	}
}