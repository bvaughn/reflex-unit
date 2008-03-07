package reflexunit.framework {
	import reflexunit.introspection.model.MethodModel;
	
	/**
	 * Defines a collection of methods to be implemented by classes that monitor the progress of an test.
	 */
	public interface ITestWatcher {
		
		// TODO: Add more notify methods.
		// TODO: Add documentation
		
		function allTestsCompleted():void;
		
		function testCompleted( methodModel:MethodModel ):void;
		
		function testStarting( methodModel:MethodModel ):void;
	}
}