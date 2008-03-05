package reflexunit.framework {
	import reflexunit.introspection.model.MethodModel;
	import reflexunit.introspection.util.IntrospectionUtil;
	
	/**
	 * Parses a <code>TestCase</code> instance for its test methods.
	 * 
	 * @see reflexunit.framework.TestCase
	 */
	public class Description {
		
		private static const TEST_METHOD_NAME_REGEXP:RegExp = /^test/;
		
		private var _introspectionUtil:IntrospectionUtil;
		private var _methodModels:Array;
		
		/**
		 * Constructor.
		 */
		public function Description( testCaseIn:TestCase ) {
			_introspectionUtil = new IntrospectionUtil( testCaseIn );
			_methodModels = new Array();
			
			collectTestCaseInfo();
		}
		
		/*
		 * Getter / setter methods
		 */
		
		/**
		 * Array containing <code>MethodModel</code> objects describing all test functions for the related <code>testCase</code>.
		 */
		public function get methodModels():Array {
			return _methodModels;
		}
		
		public function get testCase():TestCase {
			return _introspectionUtil.instance as TestCase;
		}
		
		public function get testCount():int {
			return _methodModels.length;
		}
		
		/*
		 * Helper methods
		 */
		
		private function collectTestCaseInfo():void {
			var explicitTestMethods:Array;
			
			// If an explicit set of test methods have been defined then use that set only.
			if ( _introspectionUtil.instanceClass.hasOwnProperty( 'testMethods' ) ) {
				explicitTestMethods = ( _introspectionUtil.instanceClass['testMethods'] as Function ).apply( new Object() );
			}
			
			for each ( var methodModel:MethodModel in _introspectionUtil.methodModels ) {
				if ( explicitTestMethods ) {
					if ( explicitTestMethods.indexOf( methodModel.method ) >= 0 ) {
						_methodModels.push( methodModel );
					}
				} else if ( isTestMethod( methodModel ) ) {
					_methodModels.push( methodModel );
				}
			}
		}
		
		/**
		 * Returns TRUE if the specified method is a valid test method.
		 * 
		 * A method is considered valid if:
		 * <ul>
		 *   <li>name starts with "test"</li>
		 *   <li>accepts no parameters</li>
		 *   <li>return type of "void"</li>
		 * </ul>
		 */
		protected static function isTestMethod( methodModel:MethodModel ):Boolean {
			
			// Ignore any public methods with names not beginning with "test".
			if ( methodModel.name.search( TEST_METHOD_NAME_REGEXP ) < 0 ) {
				return false;
			}
			
			// Ignore any public methods that require parameters.
			if ( methodModel.parameterModels.length > 0 ) {
				return false;
			}
			
			// Ignore any public methods with a non-void return type.
			// (Remember that a MethodModel.returnType value of 'null' is the same as 'void'.)
			if ( methodModel.returnType ) {
				return false;
			}
			
			return true;
		}
	}
}