package reflexunit.framework.constants {
	
	[ExcludeClass]
	public class TestConstants {
		
		public static const METADATA_ARG_ALLOW_PARALLEL_ASYNCHRONOUS_TESTS:String = 'allowParallelAsynchronousTests';
		
		public static const METADATA_ARG_SHOULD_FAIL:String = 'shouldFail';
		
		public static const METADATA_TEST:String = 'Test';
		
		public static const METADATA_TEST_CASE:String = 'TestCase';
		
		public static const TESTABLE_METHOD_NAME_REGEXP:RegExp = /^test/;
		
		public static const TESTABLE_METHODS_ACCESSOR_NAME:String = 'testableMethods';
	}
}