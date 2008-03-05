package funit.framework {
	import funit.introspection.model.MethodModel;
	
	/**
	 * Describes the status of a single test method.
	 * Constructor should require a <code>MethodModel</code> reference in addition to any other descriptive info.
	 */
	public interface IStatus {
		
		/**
		 * <code>MethodModel</code> describing the test method represented by this <code>IStatus</code> object.
		 */
		function get methodModel():MethodModel;
		
		/**
		 * Lowercase string defining the status this class represents (e.g. failure, success, error, etc.).
		 */
		function get status():String;
		
		/**
		 * Convenience method.
		 */
		function get testCase():TestCase;
	}
}