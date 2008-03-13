package {
	import reflexunit.framework.TestCase;
	
	public class InnerErrorTest extends TestCase {
		public function testMe():void {
			fail( 'Inner test failure' );
		}
	}
}