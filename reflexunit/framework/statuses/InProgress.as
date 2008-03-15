package reflexunit.framework.statuses {
	import reflexunit.introspection.models.MethodModel;
	
	/**
	 * Wrapper class used by some <code>IResultViewer</code> objects to indicate a test method that has not completed execution.
	 * Once completed, an <code>InProgress</code> object will be replaced with a <code>Success</code> or a <code>Failure</code>.
	 * 
	 * @see reflexunit.framework.statuses.Failure
	 * @see reflexunit.framework.statuses.Success
	 */
	public class InProgress extends AbstractStatus {
		
		/*
		 * Initialization
		 */
		
		/**
		 * Constructor.
		 */
		public function InProgress( methodModelIn:MethodModel ) {
			super( methodModelIn );
		}
		
		/*
		 * Getter / setter methods
		 */
		
		/**
		 * @inheritDoc
		 */
		override public function get status():String {
			return 'in progress';
		}
	}
}