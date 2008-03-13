package reflexunit.framework.tests.inner {
	import reflexunit.framework.Assert;
	
	/**
	 * Inner test class used by <code>TestMethodExecution</code>.
	 * 
	 * @see reflexunit.framework.tests.TestMethodExecution
	 */
	[ExcludeClass]
	public class InnerTestAllMethodNamesGetterMethodsExecuted {
		
		public static function get testMethodNames():Array {
			return [ 'methodOne', 'methodTwo', 'methodThree' ];
		}
		
		public function testMethod():void {
		}
		
		public function methodOne():void {
			Assert.assertTrue( true );
		}
		
		public function methodTwo():void {
			Assert.assertTrue( true );
		}
		
		public function methodThree():void {
			Assert.assertTrue( true );
		}
	}
}