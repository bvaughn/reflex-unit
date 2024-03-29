package reflexunit.framework {
	import reflexunit.framework.errors.AssertFailedError;
	
	
	/**
	 * Defines various assertions that may be used to compare one or more values.
	 * Throws <code>AssertFailedError</code> to indicate a failed assertion.
	 * 
	 * @see reflexunit.framework.errors.AssertFailedError
	 */
	public class Assert {
		
		private static var _numAsserts:int = 0;
		
		/*
		 * Assert methods
		 */
		
		/**
		 * Asserts that two values are equal.
		 * 
		 * @throws reflexunit.framework.AssertFailedError if two values are not equal
		 */
		public static function assertEquals( expected:*, actual:*, message:String = null ):void {
			_numAsserts++;
			
			if ( expected != actual ) {
				throw new AssertFailedError( message ? message : 'Expected "' + expected + '" but was "' + actual + '".' );
			}
		}
		
		/**
		 * Asserts that the value specified is FALSE.
		 * 
		 * @throws reflexunit.framework.AssertFailedError if expression is true
		 */
		public static function assertFalse( expression:*, message:String = null ):void {
			_numAsserts++;
			
			if ( expression == true ) {
				throw new AssertFailedError( message ? message : 'False expected but was true.' );
			}
		}
		
		/**
		 * Asserts that the two values specified are not equal.
		 * 
		 * @throws reflexunit.framework.AssertFailedError if two values are equal
		 */
		public static function assertNotEquals( expected:*, actual:*, message:String = null ):void {
			_numAsserts++;
			
			if ( expected == actual ) {
				throw new AssertFailedError( message ? message : 'Values expected to be different but were equal.' );
			}
		}
		
		/**
		 * Asserts that the value specified is not NULL.
		 * 
		 * @throws reflexunit.framework.AssertFailedError if expression is null
		 */
		public static function assertNotNull( expression:*, message:String = null ):void {
			_numAsserts++;
			
			if ( expression == null ) {
				throw new AssertFailedError( message ? message : 'Non-null value expected but was null.' );
			}
		}
		
		/**
		 * Asserts that the value specified is NULL.
		 * 
		 * @throws reflexunit.framework.AssertFailedError if expression is not null
		 */
		public static function assertNull( expression:*, message:String = null ):void {
			_numAsserts++;
			
			if ( expression != null ) {
				throw new AssertFailedError( message ? message : 'Null expected but was not null.' );
			}
		}
		
		/**
		 * Asserts that the value specified is TRUE.
		 * 
		 * @throws reflexunit.framework.AssertFailedError if expression is false
		 */
		public static function assertTrue( expression:*, message:String = null ):void {
			_numAsserts++;
			
			if ( expression == false ) {
				throw new AssertFailedError( message ? message : 'True expected but was false.' );
			}
		}
		
		/*
		 * Public methods
		 */
		 
		/**
		 * Resets the value of <code>numAsserts</code>.
		 * Should be explicitly called before each test method is run.
		 */
		 public static function resetNumAsserts():void {
		 	_numAsserts = 0;
		 }
		
		/*
		 * Getter / setter methods
		 */
		 
		/**
		 * Number of assertions made by the most recently executed test method.
		 */
		 public static function get numAsserts():int {
		 	return _numAsserts;
		 }
	}
}