package reflexunit.framework {
	
	/**
	 * 
	 */
	public class TestCase extends Assert implements ITestCase {
		
		public static const METADATA_ARG_FORCE_SERIAL_EXECUTION:String = 'forceSerialExecution';
		public static const METADATA_ARG_SHOULD_FAIL:String = 'shouldFail';
		public static const METADATA_TEST:String = 'Test';
		public static const METADATA_TEST_CASE:String = 'TestCase';
		
		private static var _asynchronousAssertions:Array;
		
		/*
		 * Initialization
		 */
		
		public function TestCase() {
			_asynchronousAssertions = new Array();
		}
		
		/*
		 * Public methods
		 */
		
		/**
		 * Add an asynchronous check point to the test.
		 * This method will return an event handler function.
		 * 
		 * @param eventHandler The Function to execute once the related event has successfully occurred
		 * @param timeout The maximum allowable time (in ms) the event may not fire before it is considered a failure
		 * @param failureMessageFunction Optional method to provide a custom error message in the event of a failure
		 * @param failureMessageFunctionArgs Optional argumetns to pass to the failureMessageFunction
		 */
		public final function addAsync( eventHandler:Function,
		                                timeout:int = 1000,
		                                failureMessageFunction:Function = null,
		                                failureMessageFunctionArgs:Array = null ):Function {
			
			var asyncronousAssertion:AsynchronousAssertion =
				new AsynchronousAssertion( this, eventHandler, timeout, failureMessageFunction, failureMessageFunctionArgs );
			
			_asynchronousAssertions.push( asyncronousAssertion );
			
			return asyncronousAssertion.wrapperFunction;
		}
		
		/**
		 * Resets the value stored in <code>numAsyncAssertions</code> as well as the value returned by <code>asyncAssertion.
		 * This method should be explicitly called before each test method is run.
		 */
		public static function resetStaticTestVars():void {
			_asynchronousAssertions = new Array();
		}
		
		/*
		 * Getter / setter methods
		 */
		
		/**
		 * Returns an <code>AsyncronousAssertion</code> representing each call to <code>addAsync</code> made by the previous executed test method.
		 */
		public static function get asynchronousAssertions():Array {
			return _asynchronousAssertions;
		}
		
		/**
		 * Convenience method.
		 */
		public static function get asynchronousAssertionsCount():int {
			return _asynchronousAssertions.length;
		}
		
		/*
		 * ITestCase interface methods
		 */
		
		/**
		 * @inheritDoc
		 */
		public function setupTest():void {
		}
		
		/**
		 * @inheritDoc
		 */
		public function tearDownTest():void {
		}
		
		/*
		 * Helper methods
		 */
		
		/**
		 * Causes the current test to intentionally fail with an optional message.
		 */
		protected final function fail( message:String = null ):void {
			throw new AssertFailedError( message ? message : 'Test was instructed to fail.' );
		}
	}
}