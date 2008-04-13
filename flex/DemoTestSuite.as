package {
	import reflexunit.async.tests.TestCallLaterUtil;
	import reflexunit.framework.TestSuite;
	import reflexunit.framework.tests.AssertTest;
	import reflexunit.framework.tests.FrameworkTest;
	import reflexunit.framework.tests.TestMethodExecution;
	import reflexunit.framework.tests.metadata.MetaDataTest;
	import reflexunit.introspection.tests.IntrospectionTest;
	
	/**
	 * Built-in <code>TestSuite</code> to be used with demo applications.
	 * It contains the various tests used to test the Reflex Unit frameowkr.
	 */
	[ExcludeClass]
	public class DemoTestSuite extends TestSuite {
		
		public function DemoTestSuite() {
			super( [ AssertTest,
			         FrameworkTest,
			         IntrospectionTest,
			         MetaDataTest,
			         TestCallLaterUtil,
			         TestMethodExecution ] )
		}
	}
}