package reflexunit.framework.statuses {
	import reflexunit.introspection.models.MethodModel;
	
	/**
	 * Indicates that all assertions made by the assocated test method were accurate and no runtime errors occured.
	 * (This class may also be used to indicate that an assertion failed if metadata was present to specify that a failure was expected.)
	 */
	public class Success extends AbstractStatus {
		
		/*
		 * Initialization
		 */
		
		/**
		 * Constructor.
		 */
		public function Success( methodModelIn:MethodModel, numAssertsIn:int = 0, timeIn:int = 0 ) {
			super( methodModelIn, numAssertsIn, timeIn );
		}
		
		/*
		 * Getter / setter methods
		 */
		
		/**
		 * @inheritDoc
		 */
		override public function get status():String {
			return 'success';
		}
	}
}