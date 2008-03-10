package reflexunit.framework {
	import reflexunit.introspection.models.MethodModel;
	
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
		 * Number of assertions (including those that failed) made by the associated <code>test</code>.
		 */
		function get numAsserts():int;
		
		/**
		 * Lowercase string defining the status this class represents (e.g. failure, success, error, etc.).
		 */
		function get status():String;
		
		/**
		 * Convenience method.
		 */
		function get test():*;
	}
}