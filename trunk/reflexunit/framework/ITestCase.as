package reflexunit.framework {
	
	/**
	 * Optional interface to be implemented by any class defining one or mote testable method.
	 * If implemented, an <code>ITestCase</code> will be notified before and after each test method has finished executing. 
	 */
	public interface ITestCase {
		
		/**
		 * Called before each testable method is run.
		 * This method is responsible for initializing all common, pre-test settings.
		 */
		function setupTest():void {
		}
		
		/**
		 * Called after each testable method has run and all asserts have completed.
		 */
		function tearDownTest():void {
		}
	}
}