package reflexunit.framework.display {
	import reflexunit.framework.ITestWatcher;
	import reflexunit.framework.models.Recipe;
	import reflexunit.framework.models.Result;
	
	/**
	 * An <code>IResultViewer</code> relates the status of a test as it is executed.
	 * This is often done using a graphical interface but may also be done using plain text, XML, sockets, etc.
	 */
	public interface IResultViewer extends ITestWatcher {
		
		/**
		 * @see reflexunit.framework.Recipe
		 */
		function set recipe( value:Recipe ):void;
		
		/**
		 * <code>Result</code> containig information pertaining to the related test.
		 */
		function set result( value:Result ):void;
	}
}