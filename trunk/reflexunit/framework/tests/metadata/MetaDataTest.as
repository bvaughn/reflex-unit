package reflexunit.framework.tests.metadata {
	import reflexunit.framework.Recipe;
	import reflexunit.framework.Result;
	import reflexunit.framework.RunNotifier;
	import reflexunit.framework.TestCase;
	import reflexunit.framework.TestSuite;
	import reflexunit.framework.Wrapper;
	import reflexunit.introspection.model.MethodModel;
	import reflexunit.introspection.util.IntrospectionUtil;
	
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
		
		public function testForceSerialExecutionTrue():void {
			assertTrue( createAndRunWrapperForMethod( 'forceSerialExecutionTrue' ).forceSerialExecution );
		}
		
		public function testForceSerialExecutionFalseIfNoAsync():void {
			assertFalse( createAndRunWrapperForMethod( 'forceSerialExecutionFalseIfNoAsync' ).forceSerialExecution );
		}
		
		public function testForceSerialExecutionFalse():void {
			assertFalse( createAndRunWrapperForMethod( 'forceSerialExecutionFalse' ).forceSerialExecution );
		}
	}
}