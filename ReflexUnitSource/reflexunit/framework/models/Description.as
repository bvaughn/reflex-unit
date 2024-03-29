package reflexunit.framework.models {
	import reflexunit.framework.constants.TestConstants;
	import reflexunit.introspection.models.ArgModel;
	import reflexunit.introspection.models.MethodModel;
	import reflexunit.introspection.util.IntrospectionUtil;
	
	/**
	 * Describes a single class and the testable methods it defines.
	 * A <code>Description</code> may only be run (ie. tested) once.
	 * Because of this, a <code>Description</code> should in most cases be cloned before being passed to a <code>Runner</code>.
	 * 
	 * <p>A <code>Description</code> analyzes the provided class to determine which methods are considered testable (see below).
	 * Each testable method is bundled into a <code>MethodModel</code> for later use.
	 * There are several possible ways for a method to be determined testable:</p>
	 * 
	 * <p>The first way is for the provided test class to define a static accessor named <code>testMethodNames</code>.
	 * Such a method should return an <code>Array</code> of function names (ie. Strings) defining the complete set of all test methods.</p>
	 * 
	 * <p>If such an accessor is not defined, the provided test will be analyzed using the <code>IntrospectionUtil</code>.
	 * In this case all methods meeting one of the following conditions will be considered testable:
	 * <ul>
	 *   <li>Method name begins with "test", accepts no parameters, and has a return type of <code>void</code></li>
	 *   <li>Method is marked with the <code>metadata</code> tag "Test"</li>
	 * </ul></p>
	 * 
	 * <p>Additional metadata support is also available for the following:
	 * <ul>
	 *   <li><code>allowParallelAsynchronousTests</code>:
	 *       All asynchronous test methods in this class will execute in parallel.
	 *       This tag must be defined at the class-level.
	 *       If not specified all tests will be executed serially.</li>
	 *   <li><code>shouldFail</code>:
	 *       The associated test method is expected to fail, thus a failure will be considered a success.
	 *       By default this value is false.</li>
	 * </p>
	 * 
	 * @see reflexunit.introspection.models.MethodModel
	 * @see reflexunit.introspection.util.IntrospectionUtil
	 */
	public class Description {
		
		private var _introspectionUtil:IntrospectionUtil;
		private var _methodModels:Array;
		
		/*
		 * Initialization
		 */
		
		/**
		 * Constructor.
		 * 
		 * @param testIn Object containing one or more testable methods
		 * @param explicitMethodNamesIn Complete set of test method names (ie. Strings) that define the resulting test
		 */
		public function Description( testIn:*, explicitMethodNamesIn:Array = null ) {
			_introspectionUtil = new IntrospectionUtil( testIn );
			_methodModels = new Array();
			
			initMethodModels( explicitMethodNamesIn );
		}
		
		/**
		 * Creates and returns a duplicate copy of the current <code>Description</code>.
		 */
		public function clone():Description {
			var methodNames:Array = new Array();
			
			for each ( var methodModel:MethodModel in _methodModels ) {
				methodNames.push( methodModel.name );
			}
			
			return new Description( _introspectionUtil.classModel.instance, methodNames );
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
		 * <code>IntrospectionUtil</code> object used to describe the contained test.
		 */
		public function get introspectionUtil():IntrospectionUtil {
			return _introspectionUtil;
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
			return _methodModels ? _methodModels.length : 0;
		}
		
		/**
		 * Convenience method.
		 */
		public function get testName():String {
			return _introspectionUtil && _introspectionUtil.classModel ? _introspectionUtil.classModel.name : null;
		}
		
		/*
		 * Helper methods
		 */
		
		private function initMethodModels( explicitMethodNames:Array = null ):void {
			
			// If no explicit method names have been provided check for a static accessor on the test class. 
			if ( !explicitMethodNames ) {
				if ( _introspectionUtil.classModel.type.hasOwnProperty( TestConstants.TESTABLE_METHODS_ACCESSOR_NAME ) ) {
					if ( _introspectionUtil.classModel.type[ TestConstants.TESTABLE_METHODS_ACCESSOR_NAME ] is Function ) {
						explicitMethodNames = ( _introspectionUtil.classModel.type[ TestConstants.TESTABLE_METHODS_ACCESSOR_NAME ] as Function ).apply( new Object() );
					} else {
						explicitMethodNames = _introspectionUtil.classModel.type[ TestConstants.TESTABLE_METHODS_ACCESSOR_NAME ] as Array;
					}
				}
			}
			
			// If an explicit set of test methods have been defined then use that set only.
			if ( explicitMethodNames ) {
				initMethodModelsFromArray( explicitMethodNames );
			} else {
				initMethodModelsFromNamesAndMetaData();
			}
		}
		
		private function initMethodModelsFromArray( explicitMethodNames:Array ):void {
			for each ( var methodName:String in explicitMethodNames ) {
				for each ( var methodModel:MethodModel in _introspectionUtil.classModel.methodModels ) {
					if ( methodName == methodModel.name ) {
						_methodModels.push( methodModel );
					}
				}
			}
		}
		
		private function initMethodModelsFromNamesAndMetaData():void {
			for each ( var methodModel:MethodModel in _introspectionUtil.classModel.methodModels ) {
				if ( isTestableMethod( methodModel ) ) {
					_methodModels.push( methodModel );
				}
			}
		}
		
		/**
		 * Returns TRUE if the specified method is a testable method.
		 * See class documentation for more information.
		 */
		protected static function isTestableMethod( methodModel:MethodModel ):Boolean {
			
			// Ignore any public methods that require parameters.
			// (This is true despite metadata.)
			if ( methodModel.parameterModels.length > 0 ) {
				return false;
			}
			
			// Ignore any public methods with a non-void return type.
			// (This is true despite metadata.)
			if ( methodModel.returnType != MethodModel.RETURN_TYPE_VOID ) {
				return false;
			}
			
			// If the MetaData keyword 'Test' has been provided, support it.
			if ( methodModel.metaDataModel && methodModel.metaDataModel.name == TestConstants.METADATA_TEST ) {
				return true; 
				
			// Ignore any public methods with names that do not match our required format.
			} else if ( methodModel.name.search( TestConstants.TESTABLE_METHOD_NAME_REGEXP ) >= 0 ) {
				return true;
			}
			
			return false;
		}
	}
}