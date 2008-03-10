package reflexunit.introspection.tests {
	import reflexunit.framework.TestCase;
	import reflexunit.introspection.model.AccessorModel;
	import reflexunit.introspection.model.MethodModel;
	import reflexunit.introspection.model.VariableModel;
	import reflexunit.introspection.tests.mocks.DynamicClass;
	import reflexunit.introspection.tests.mocks.StaticClass;
	import reflexunit.introspection.util.IntrospectionUtil;
	
	/**
	 * Tests the <code>IntrospectionUtil</code> and its models.
	 */
	[ExcludeClass]
	public class IntrospectionTest extends TestCase {
		
		private var _introspectionUtil:IntrospectionUtil;
		
		/*
		 * Helper methods
		 */
		
		private function testNumParameters( methodModel:MethodModel, numParameters:int ):void {
			assertNotNull( methodModel );
			assertEquals( methodModel.parameterModels.length, numParameters );
		}
		
		private function testReadableAndWritable( accessorModel:AccessorModel ):void {
			assertFalse( accessorModel.readOnly );
			assertFalse( accessorModel.writeOnly );
		}
		
		private function testReadOnly( accessorModel:AccessorModel ):void {
			assertNotNull( accessorModel );
			assertTrue( accessorModel.readOnly );
		}
		
		private function testReturnType( methodModel:MethodModel, returnType:Class ):void {
			assertNotNull( methodModel );
			assertEquals( methodModel.returnType, returnType );
		}
		
		private function testVariableType( variableModel:VariableModel, type:Class ):void {
			assertNotNull( variableModel );
			assertEquals( variableModel.type, type );
		}
		
		private function testVariableValue( variableModel:VariableModel, value:* ):void {
			assertNotNull( variableModel );
			assertTrue( _introspectionUtil.classModel.instance.hasOwnProperty( variableModel.name ) );
			assertEquals( _introspectionUtil.classModel.instance[ variableModel.name ], value );
		}
		
		private function testWriteOnly( accessorModel:AccessorModel ):void {
			assertNotNull( accessorModel );
			assertTrue( accessorModel.writeOnly );
		}
		
		/*
		 * Test methods
		 */
		
		public function testAccessors():void {
			_introspectionUtil = new IntrospectionUtil( new StaticClass() );
			
			assertEquals( _introspectionUtil.classModel.accessorModels.length, 3 );
			
			testReadableAndWritable( _introspectionUtil.classModel.accessorModels[0] );
			testReadOnly( _introspectionUtil.classModel.accessorModels[1] );
			testWriteOnly( _introspectionUtil.classModel.accessorModels[2] );
		}
		
		public function testDynamicClass():void {
			_introspectionUtil = new IntrospectionUtil( new DynamicClass() );
			
			assertTrue( _introspectionUtil.classModel.isDynamic );
			
			_introspectionUtil = new IntrospectionUtil( new StaticClass() );
			
			assertFalse( _introspectionUtil.classModel.isDynamic );
		}
		
		public function testMethods():void {
			_introspectionUtil = new IntrospectionUtil( new StaticClass() );
			
			assertEquals( _introspectionUtil.classModel.methodModels.length, 3 );
			
			assertNotNull( ( _introspectionUtil.classModel.methodModels[2] as MethodModel ).metaDataModel );
			
			testNumParameters( _introspectionUtil.classModel.methodModels[0], 2 );
			testNumParameters( _introspectionUtil.classModel.methodModels[1], 0 );
			
			testReturnType( _introspectionUtil.classModel.methodModels[0], Boolean );
			testReturnType( _introspectionUtil.classModel.methodModels[1], MethodModel.RETURN_TYPE_VOID );
		}
		
		public function testVariables():void {
			_introspectionUtil = new IntrospectionUtil( new StaticClass() );
			
			assertEquals( _introspectionUtil.classModel.variableModels.length, 3 );
			
			testVariableType( _introspectionUtil.classModel.variableModels[0], Boolean );
			testVariableType( _introspectionUtil.classModel.variableModels[1], Number );
			testVariableType( _introspectionUtil.classModel.variableModels[2], String );
			
			testVariableValue( _introspectionUtil.classModel.variableModels[0], true );
			testVariableValue( _introspectionUtil.classModel.variableModels[1], 1 );
			testVariableValue( _introspectionUtil.classModel.variableModels[2], VariableModel.RETURN_TYPE_UNSPECIFIED );
		}
	}
}