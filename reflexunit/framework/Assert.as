package reflexunit.framework {
	
	/**
	 * Defines various assertion-methods that may be used to compare one or more values.
	 * Dispatches <code>AssertFailedError</code> to indicate a failed assertion.
	 * 
	 * @see AssertFailedError
	 */
	public class Assert {
		
		/**
		 * Asserts that two values are equal.
		 */
		public static function assertEquals( expected:*, actual:*, message:String = null ):void {
			if ( expected != actual ) {
				throw new AssertFailedError( message ? message : 'Values expected to be equal but were different.' );
			}
		}
		
		/**
		 * Asserts that the value specified is FALSE.
		 */
		public static function assertFalse( expression:*, message:String = null ):void {
			if ( expression == true ) {
				throw new AssertFailedError( message ? message : 'False expected but was true.' );
			}
		}
		
		/**
		 * Asserts that the value specified is not NULL.
		 */
		public static function assertNotNull( expression:*, message:String = null ):void {
			if ( expression == null ) {
				throw new AssertFailedError( message ? message : 'Non-null value expected but was null.' );
			}
		}
		
		/**
		 * Asserts that the value specified is NULL.
		 */
		public static function assertNull( expression:*, message:String = null ):void {
			if ( expression != null ) {
				throw new AssertFailedError( message ? message : 'Null expected but was not null.' );
			}
		}
		
		/**
		 * Asserts that the value specified is TRUE.
		 */
		public static function assertTrue( expression:*, message:String = null ):void {
			if ( expression == false ) {
				throw new AssertFailedError( message ? message : 'True expected but was false.' );
			}
		}
	}
}