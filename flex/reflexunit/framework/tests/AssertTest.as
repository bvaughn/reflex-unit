package reflexunit.framework.tests {
	import reflexunit.framework.TestCase;
	
	import reflexunit.framework.TestCase;
	
	[ExcludeClass]
	public class AssertTest extends TestCase {
		
		/*
		 * Test that all assertion methods work.
		 */
		
		public function testAssertEquals():void {
			assertEquals( 1, 1 );
		}
		
		public function testAssertFalse():void {
			assertFalse( false );
		}
		
		public function testAssertNotEquals():void {
			assertNotEquals( 1, 2 );
		}
		
		public function testAssertNotNull():void {
			assertNotNull(  new Object() );
		}
		
		public function testAssertNull():void {
			assertNull( null );
		}
		
		public function testAssertTrue():void {
			assertTrue( true );
		}
		
		/*
		 * Test that invalid values make our assert methods fail.
		 */
		
		[Test(shouldFail="true")]
		public function testAssertEqualsFails():void {
			assertEquals( 1, 2 );
		}
		
		[Test(shouldFail="true")]
		public function testAssertFalseFails():void {
			assertFalse( true );
		}
		
		[Test(shouldFail="true")]
		public function testAssertNotEqualsFails():void {
			assertNotEquals( 1, 1 );
		}
		
		[Test(shouldFail="true")]
		public function testAssertNotNullFails():void {
			assertNotNull(  null );
		}
		
		[Test(shouldFail="true")]
		public function testAssertNullFails():void {
			assertNull( new Object() );
		}
		
		[Test(shouldFail="true")]
		public function testAssertTrueFails():void {
			assertTrue( false );
		}
	}
}