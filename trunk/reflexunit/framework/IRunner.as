package reflexunit.framework {
	
	/**
	 * Executes an instance of <code>ITest</code> and returns results in the form of a <code>Result</code> object.
	 * <code>Runner</code> should also display/ouput a summary of test results once tests have all been executed.
	 */
	public interface IRunner {
		
		/**
		 * Runs the provided <code>test</code>.
		 * Once test has completed the results will be accessible via the <code>result</code> method.
		 * 
		 * @param test ITest containing test cases to be executed
		 * @param runNotifier RunNotifier to update as test progress is made
		 */
		function run( testToExecute:ITest, runNotifier:RunNotifier ):void;
		
		/*
		 * Getter / setter methods
		 */
		
		/**
		 * <code>Result</code> instance describing outcome of running the <code>ITest</code> provided to the <code>run</code> method.
		 */
		function get result():Result;
		
		/**
		 * Reference to the <code>ITest</code> instance executed by the <code>run>/code> method.
		 */
		function get test():ITest;
	}
}