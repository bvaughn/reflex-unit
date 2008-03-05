package funit.framework {
	
	/**
	 * Dispatched by an instance of <code>Assert</codEe> to indicate assertion failures.
	 * 
	 * @see funit.framework.Assert
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