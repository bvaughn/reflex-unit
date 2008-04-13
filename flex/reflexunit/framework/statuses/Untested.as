package reflexunit.framework.statuses {
	import reflexunit.introspection.models.MethodModel;
	
	/**
	 * Wrapper class used by some <code>IResultViewer</code> objects to indicate a test method that has not yet been executed.
	 * Once started, an <code>Untested</code> object will be replaced with an <code>InProgress</code>.
	 * 
	 * @see reflexunit.framework.statuses.InProgress
	 */
	public class Untested extends AbstractStatus {
		
		/*
		 * Initialization
		 */
		
		/**
		 * Constructor.
		 */
		public function Untested( methodModelIn:MethodModel ) {
			super( methodModelIn );
		}
		
		/*
		 * Getter / setter methods
		 */
		
		/**
		 * @inheritDoc
		 */
		override public function get status():String {
			return 'new';
		}
	}
}