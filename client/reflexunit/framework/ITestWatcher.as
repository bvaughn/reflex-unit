package reflexunit.framework {
	import reflexunit.framework.statuses.IStatus;
	import reflexunit.introspection.models.MethodModel;
	
	/**
	 * Defines a collection of methods to be implemented by classes that monitor the progress of an test.
	 */
	public interface ITestWatcher {
		
		// TODO: Add more notify methods.
		
		/**
		 * All tests in the current <code>TestSuite</code> have been executed.
		 */
		function allTestsCompleted():void;
		
		/**
		 * The specified test method has completed execution.
		 * 
		 * @param methodModel Test method that has been executed
		 * @param status Resulting IStatus of test method
		 */
		function testCompleted( methodModel:MethodModel, status:IStatus ):void;
		
		/**
		 * The specified test method is about to be run.
		 */
		function testStarting( methodModel:MethodModel ):void;
	}
}