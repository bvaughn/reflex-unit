package funit.framework {
	import funit.introspection.model.MethodModel;
	
	/**
	 * An <code>IResultViewer</code> parses and displays (or prints) a running summary of the contents within a <code>Result</code> object.
	 * In many cases a viewer should also update its display while testing is still in progress.
	 */
	public interface IResultViewer extends ITestWatcher {
		
		/**
		 * <code>Result</code> containig information pertaining to the related <code>ITest</code>.
		 */
		function set result( value:Result ):void;
		
		/**
		 * <code>ITest</code> this viewer will be displaying information describing.
		 */
		function set test( value:ITest ):void;
	}
}