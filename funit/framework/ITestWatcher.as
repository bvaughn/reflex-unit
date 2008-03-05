package funit.framework {
	import funit.introspection.model.MethodModel;
	
	/**
	 * Defines a collection of methods to be implemented by classes that monitor the progress of an <code>ITest</code>.
	 */
	public interface ITestWatcher {
		
		// TODO: Add more notify methods.
		
		function allTestsCompleted():void;
		
		function testCompleted( methodModel:MethodModel ):void;
		
		function testStarting( methodModel:MethodModel ):void;
	}
}