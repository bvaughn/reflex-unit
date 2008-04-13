package reflexunit.async {
	
	[ExcludeClass]
	
	/**
	 * Temporary storage model used by the <code>CallLaterUtil</code>.
	 * The <code>CallLaterModel</code> is not intended for use by any other classes or objects.
	 */
	public class CallLaterModel {
		
		/**
		 * Name of accessor to assign associated <code>accessorValue</code> to.
		 */
		public var accessorName:String;
		
		/**
		 * Value to assign to associated <code>accessorName</code> attribute (defined by <code>thisObject</code>.
		 */
		public var accessorValue:Object;
		
		/**
		 * 
		 */
		public var frameDelayRemaining:int = 0;
		
		/**
		 * Instance method to execute (defined by <code>thisObject</code>.
		 */
		public var method:Function;
		
		/**
		 * (Optional) array of arguments to pass to associated <code>method</code>.
		 */
		public var methodArgs:Array;
		
		/**
		 * Number of milliseconds to delay before executing the associated <code>method</code> or assigning to the <code>accessorName</code>.
		 */
		public var millisecondsAtCompletion:int = 0;
		
		/**
		 * Instance/object defining the associated <code>method</code> or <code>accessorName</code>.
		 */
		public var thisObject:Object;
	}
}