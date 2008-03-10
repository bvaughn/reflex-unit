package reflexunit.framework {
	import reflexunit.framework.constants.TestConstants;
	import reflexunit.introspection.models.ArgModel;
	import reflexunit.introspection.models.MethodModel;
	import reflexunit.introspection.util.IntrospectionUtil;
	
	/**
	 * Describes a single class and the testable methods it defines.
	 * 
	 * A <code>Description</code> analyzes the provided class to determine which methods are considered testable (see below).
	 * Each testable method is bundled into a <code>MethodModel</code> for later use.
	 * 
	 * There are several possible ways for a method to be determined testable:
	 * 
	 * The first way is for the provided test class to define a static accessor named <code>testableMethods</code>.
	 * Such a method should return an <code>Array</code> of <code>Function</code> references.
	 * That <code>Array</code> then defines the entire set of testable methods.
	 * 
	 * If such an accessor is not defined, the provided test will be analyzed using the <code>IntrospectionUtil</code>.
	 * In this case all methods meeting one of the following conditions will be considered testable:
	 * <ul>
	 *   <li>Method name begins with "test", accepts no parameters, and has a return type of <code>void</code></li>
	 *   <li>Method is markd with the <code>metadata</code> tag "Test"</li>
	 * </ul>
	 * 
	 * @see reflexunit.introspection.models.MethodModel
	 */
	public class Description {
		
		private var _introspectionUtil:IntrospectionUtil;
		private var _methodModels:Array;
		
		/*
		 * Initialization
		 */
		
		/**
		 * Constructor.
		 */
		public function Description( testIn:* ) {
			_introspectionUtil = new IntrospectionUtil( testIn );
			_methodModels = new Array();
			
			initMethodModels();
		}
		
		/*
		 * Getter / setter methods
		 */
		
		/**
		 * Current test has elected to allow parallel execution of its asynchronous test methods.
		 * 
		 * If FALSE, no other tests should be run until this method has completed its assertions.
		 * (In that event all previously executed asynchronous tests should be allowed to complete before this method is started.)
		 */
		public function get allowParallelAsynchronousTests():Boolean {
			if ( _introspectionUtil.classModel.metaDataModel ) {
				for each ( var argModel:ArgModel in _introspectionUtil.classModel.metaDataModel.argModels ) {
					if ( argModel.key == TestConstants.METADATA_ARG_ALLOW_PARALLEL_ASYNCHRONOUS_TESTS ) {
						return ( argModel.value == 'true' );
					}
				}
			}
			
			return false;
		}
		
		/**
		 * Array containing <code>MethodModel</code> objects describing all testable functions for the provided test class.
		 */
		public function get methodModels():Array {
			return _methodModels;
		}
		
		/**
		 * Convenience method.
		 */
		public function get testCount():int {
			return _methodModels.length;
		}
		
		/*
		 * Helper methods
		 */
		
		private function initMethodModels():void {
			var explicitTestMethods:Array;
			
			// If an explicit set of test methods have been defined then use that set only.
			if ( _introspectionUtil.classModel.type.hasOwnProperty( TestConstants.TESTABLE_METHODS_ACCESSOR_NAME ) ) {
				if ( _introspectionUtil.classModel.type[ TestConstants.TESTABLE_METHODS_ACCESSOR_NAME ] is Function ) {
					explicitTestMethods = ( _introspectionUtil.classModel.type[ TestConstants.TESTABLE_METHODS_ACCESSOR_NAME ] as Function ).apply( new Object() );
				} else {
					explicitTestMethods = _introspectionUtil.classModel.type[ TestConstants.TESTABLE_METHODS_ACCESSOR_NAME ] as Array;
				}
			}
			
			for each ( var methodModel:MethodModel in _introspectionUtil.classModel.methodModels ) {
				if ( explicitTestMethods ) {
					if ( explicitTestMethods.indexOf( methodModel.method ) >= 0 ) {
						_methodModels.push( methodModel );
					}
					
				} else if ( isTestableMethod( methodModel ) ) {
					_methodModels.push( methodModel );
				}
			}
		}
		
		/**
		 * Returns TRUE if the specified method is a testable method.
		 * See class documentation for more information.
		 */
		protected static function isTestableMethod( methodModel:MethodModel ):Boolean {
			
			// If the MetaData keyword 'Test' has been provided, support it.
			if ( methodModel.metaDataModel && methodModel.metaDataModel.name == TestConstants.METADATA_TEST ) {
				return true;
			}
			
			// Ignore any public methods with names that do not match our required format.
			if ( methodModel.name.search( TestConstants.TESTABLE_METHOD_NAME_REGEXP ) < 0 ) {
				return false;
			}
			
			// Ignore any public methods that require parameters.
			if ( methodModel.parameterModels.length > 0 ) {
				return false;
			}
			
			// Ignore any public methods with a non-void return type.
			if ( methodModel.returnType != MethodModel.RETURN_TYPE_VOID ) {
				return false;
			}
			
			return true;
		}
	}
}