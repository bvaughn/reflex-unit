package reflexunit.framework {
	
	/**
	 * Classes defining testable methods may extend this class for convenience but are not required to do so.
	 * 
	 * <p>Since <code>TestCase</code> extends <code>Assert</code> it automatically provides access to all of the related assertion methods.
	 * This calss also defines a method for testing asynchronous code (see <code>addAsync</code> for more).</p>
	 * 
	 * @see reflexunit.framework.Assert
	 */
	public class TestCase extends Assert implements ITestCase {
		
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
		 * <p>An example of using this method is as follows:</p>
		 * <p><code>
		 * var timer:Timer = new Timer( 100, 1 );
		 * timer.addEventListener( TimerEvent.TIMER_COMPLETE, addAsync( function( event:TimerEvent ):void {}, 10 ) );
		 * timer.start();
		 * </code></p>
		 * 
		 * @param eventHandler The Function to execute once the related event has successfully occurred
		 * @param timeout The maximum allowable time (in ms) the event may not fire before it is considered a failure
		 * @param failureMessageFunction Optional method to provide a custom error message in the event of a failure
		 * @param failureMessageFunctionArgs Optional argumetns to pass to the failureMessageFunction
		 * @param failureThisObject Optional scope to execute failureMessageFunction within
		 */
		public static function addAsync( eventHandler:Function,
		                                 timeout:int = 1000,
		                                 failureMessageFunction:Function = null,
		                                 failureMessageFunctionArgs:Array = null,
		                                 failureThisObject:* = null ):Function {
			
			var asyncronousAssertion:AsynchronousAssertion =
				new AsynchronousAssertion( failureThisObject, eventHandler, timeout, failureMessageFunction, failureMessageFunctionArgs );
			
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