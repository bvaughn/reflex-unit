package funit.framework {
	import funit.introspection.model.MethodModel;
	
	/**
	 * Used to collect and describe the results of running an <code>ITest</code>.
	 * 
	 * The test framework distinguishes between failures and errors.
	 * A failure is anticipated and checked for with assertions.
	 * Errors are unanticipated problems like an RangeError.
	 */
	public class Result {
		
		private var _errors:Array;
		private var _failures:Array;
		private var _testsRun:int;
		
		/*
		 * Initialization
		 */
		
		public function Result() {
			_errors = new Array();
			_failures = new Array();
			_testsRun = 0;
		}
		
		/*
		 * Public methods
		 */
		
		/**
		 * Adds an error to the list of errors.
		 */
		public function addError( methodModel:MethodModel, error:Error ):void {
			_errors.push( new Failure( methodModel, error ) );
		}
		
		/**
		 * Adds a failure to the list of failures.
		 */
		public function addFailure( methodModel:MethodModel, error:AssertFailedError ):void {
			_failures.push( new Failure( methodModel, error ) );
		}
		
		/*
		 * Getter / setter methods
		 */
		
		/**
		 * Gets the number of detected errors.
		 */
		public function get errorCount():int {
			return _errors.length;
		}
		
		/**
		 * Array of test <code>Failure</code> objects.
		 */
		public function get errors():Array {
			return _errors;
		}
		
		/**
		 * Gets the number of detected failures.
		 */
		public function get failureCount():int {
			return failures.length;
		}
		
		/**
		 * Array of test <code>Failure</code> objects.
		 */
		public function get failures():Array {
			return _failures;
		}
		
		/**
		 * Number of <code>ITest</code> instances that were run and are described by this result.
		 */
		public function get testsRun():int {
			return _testsRun;
		}
		public function set testsRun( value:int ):void {
			_testsRun = value;
		}
		
		/**
		 * Returns whether the entire test was successful or not.
		 */
		public function get wasSuccessful():Boolean {
			return errorCount == 0 && failureCount == 0;
		}
	}
}