package funit.framework {
	import funit.introspection.model.MethodModel;
	
	/**
	 * A Test can be run and collect its results.
	 */
	public interface ITest {
		
		/*
		 * Public methods
		 */
		
		/**
		 * Runs a test and collects its result in a <code>Result</code> instance.
		 * The specified <code>RunNotifier</code> is called during various stages of the tests completion.
		 */
		function run( result:Result, runNotifier:RunNotifier ):void;
		
		/*
		 * Getter / setter methods
		 */
		
		/**
		 * <code>MethodModel</code> describing the currently active test method.
		 * 
		 * @see funit.introspection.model.MethodModel
		 */
		function get currentTestMethodModel():MethodModel;
		
		/**
		 * Counts the number of tests that will be run invoking the <code>run</code> method.
		 */
		function get testCount():int;
	}
}