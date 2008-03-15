package reflexunit.framework.models {
	import reflexunit.framework.errors.AssertFailedError;
	import reflexunit.framework.statuses.Failure;
	import reflexunit.framework.statuses.IStatus;
	import reflexunit.framework.statuses.Success;
	import reflexunit.introspection.models.MethodModel;
	
	/**
	 * Used to collect and describe the results of running a test.
	 * In most cases, a <code>Result</code> object should only be used (ie. run) once and then discared.
	 * 
	 * <p>The test framework distinguishes between failures and errors.
	 * A failure is anticipated and checked for with assertions.
	 * Errors are unanticipated problems like an RangeError.</p>
	 */
	public class Result {
		
		private var _errors:Array;
		private var _failures:Array;
		private var _numAsserts:int;
		private var _successes:Array;
		private var _testsRun:int;
		private var _testTimes:int;
		
		/*
		 * Initialization
		 */
		
		public function Result() {
			_errors = new Array();
			_failures = new Array();
			_successes = new Array();
			
			_numAsserts = 0;
			_testsRun = 0;
			_testTimes = 0;
		}
		
		/*
		 * Public methods
		 */
		
		/**
		 * Adds an error to the list of errors.
		 */
		public function addError( methodModel:MethodModel, error:Error, numAsserts:int, time:int ):IStatus {
			var failure:Failure = new Failure( methodModel, error, numAsserts, time );
			
			_errors.push( failure );
			_numAsserts += numAsserts;
			_testTimes += time;
			
			return failure;
		}
		
		/**
		 * Adds a failure to the list of failures.
		 */
		public function addFailure( methodModel:MethodModel, error:AssertFailedError, numAsserts:int, time:int ):IStatus {
			var failure:Failure = new Failure( methodModel, error, numAsserts, time );
			
			_failures.push( failure );
			_numAsserts += numAsserts;
			_testTimes += time;
			
			return failure;
		}
		
		/**
		 * Adds a failure to the list of failures.
		 */
		public function addSuccess( methodModel:MethodModel, numAsserts:int, time:int ):IStatus {
			var success:Success = new Success( methodModel, numAsserts, time );
			
			_successes.push( success );
			_numAsserts += numAsserts;
			_testTimes += time;
			
			return success;
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
		 * Total number of assertions made by all test methods run so far.
		 */
		public function get numAsserts():int {
			return _numAsserts;
		}
		
		/**
		 * Gets the number of detected successful tests.
		 */
		public function get successCount():int {
			return successes.length;
		}
		
		/**
		 * Array of test <code>Success</code> objects.
		 */
		public function get successes():Array {
			return _successes;
		}
		
		/**
		 * Number of test instances that were run and are described by this result.
		 */
		public function get testsRun():int {
			return _testsRun;
		}
		public function set testsRun( value:int ):void {
			_testsRun = value;
		}
		
		/**
		 * Total execution time for all test instances that were run and are described by this result.
		 * 
		 * @see reflexunit.framework.statuses.IStatus#time
		 */
		public function get testTimes():int {
			return _testTimes;
		}
		public function set testTimes( value:int ):void {
			_testTimes = value;
		}
		
		/**
		 * Returns whether the entire test was successful or not.
		 */
		public function get wasSuccessful():Boolean {
			return errorCount == 0 && failureCount == 0;
		}
	}
}