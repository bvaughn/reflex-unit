package reflexunit.framework.tests.inner {
	import reflexunit.framework.Assert;
	
	/**
	 * Inner test class used by <code>TestMethodExecution</code>.
	 * 
	 * @see reflexunit.framework.tests.TestMethodExecution
	 */
	[ExcludeClass]
	public class InnerTestNamingConventionMethodExecution {
		
		public function get testMethod():Array {
			return [ 'testMethod' ];
		}
		
		public function testMethod():void {
			Assert.assertTrue( true );
		}
		
		public function testMethodHasParameters( boolean:Boolean ):void {
		}
		
		public function testMethodHasReturnType():Boolean {
			return true;
		}
		
		public function testMethodHasParametersAndReturnType( boolean:Boolean ):Boolean {
			return true;
		}
	}
}