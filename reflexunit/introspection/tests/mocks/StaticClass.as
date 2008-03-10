package reflexunit.introspection.tests.mocks {
	
	/**
	 * Mock class used by the <code>IntrospectionTest</code> to testing the <code>IntrospectionUtil</code>.
	 */
	[ExcludeClass]
	public class StaticClass {
		
		/*
		 * Variables
		 */
		
		public var boolean:Boolean = true;
		public var number:Number = 1;
		public var string:String;
		
		/*
		 * Methods
		 */
		
		public function expectsTwoArgumentsAndReturnsABoolean( a:Object, b:Array ):Boolean {
			return true;
		}
		
		public function returnsVoid():void {
		}
		
		[TestCase]
		public function usesCustomTestCaseMetaData():void {
		}
		
		/*
		 * Accessors
		 */
		
		public function get readAndWriteArray():Array {
			return new Array();
		}
		public function set readAndWriteArray( value:Array ):void {
		}
		
		public function get readOnlyBoolean():Boolean {
			return true;
		}
		
		public function set writeOnlyString( value:String ):void {
		}
	}
}