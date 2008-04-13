package reflexunit.framework.tests.inner {
	import reflexunit.framework.Assert;
	
	/**
	 * Inner test class used by <code>TestMethodExecution</code>.
	 * 
	 * @see reflexunit.framework.tests.TestMethodExecution
	 */
	[ExcludeClass]
	public class InnerTestMetaDataMethodExecution {
		
		public function get testMethodNames():Array {
			return [ 'method' ];
		}
		
		[Test]
		public function method():void {
			Assert.assertTrue( true );
		}
		
		[Test]
		public function methodHasParameters( boolean:Boolean ):void {
		}
		
		[Test]
		public function methodHasReturnType():Boolean {
			return true;
		}
		
		[Test]
		public function methodHasParametersAndReturnType( boolean:Boolean ):Boolean {
			return true;
		}
	}
}