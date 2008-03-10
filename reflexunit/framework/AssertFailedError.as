package reflexunit.framework {
	
	/**
	 * Dispatched by the <code>Assert</code> class to indicate assertion failures.
	 * 
	 * @see reflexunit.framework.Assert
	 */
	public class AssertFailedError extends Error {
		
		/**
		 * @inheritDoc
		 */
		public function AssertFailedError( message:String, id:int = 0 ) {
			super( message, id );
		}
	}
}