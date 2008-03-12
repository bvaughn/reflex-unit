package reflexunit.framework.tests.metadata {
	import reflexunit.framework.RunNotifier;
	import reflexunit.framework.TestCase;
	import reflexunit.framework.TestSuite;
	import reflexunit.framework.models.Recipe;
	import reflexunit.framework.models.Result;
	import reflexunit.framework.models.Wrapper;
	import reflexunit.introspection.models.MethodModel;
	import reflexunit.introspection.util.IntrospectionUtil;
	
	[ExcludeClass]
	public class MetaDataTest extends TestCase {
		
		private var _introspectionUtil:IntrospectionUtil;
		
		public function MetaDataTest() {
			_introspectionUtil = new IntrospectionUtil( new MetaDataTestSample() );
		}
		
		private function createAndRunWrapperForMethod( methodName:String ):Wrapper {
			var methodModel:MethodModel = _introspectionUtil.classModel.getMethodModelByName( methodName );
			
			var wrapper:Wrapper = new Wrapper( methodModel, new Result() );
			wrapper.run( new RunNotifier() );
			
			return wrapper;
		}
		
		public function testIncludesTestMetaDataMethods():void {
			var recipe:Recipe = new Recipe( new TestSuite( [ MetaDataTestSample ] ) );
			var methodFound:Boolean;
			
			for each ( var methodModel:MethodModel in _introspectionUtil.classModel.methodModels ) {
				if ( methodModel.name == 'shouldBeTest' ) {
					methodFound = true;
					
					break;
				}
			}
			
			assertTrue( methodFound );
		}
		
		public function testShouldFailTrue():void {
			assertTrue( createAndRunWrapperForMethod( 'shouldFailTrue' ).isFailureExpected() );
		}
		
		public function testShouldFailFalse():void {
			assertFalse( createAndRunWrapperForMethod( 'shouldFailFalse' ).isFailureExpected() );
		}
	}
}