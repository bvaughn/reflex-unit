package reflexunit.introspection.util {
	import flash.utils.describeType;
	
	import reflexunit.introspection.models.ClassModel;
	
	/**
	 * Analyzes an object instance and describes its public instance accessors, methods, and variables.
	 * 
	 * @see flash.utils.describeType
	 * @see reflexunit.introspection.models.MethodModel
	 * @see reflexunit.introspection.models.ParameterModel
	 * @see reflexunit.introspection.models.VariableModel
	 */
	public class IntrospectionUtil {
		
		private var _classModel:ClassModel;
		
		/*
		 * Initialization
		 */
		
		/**
		 * Constructor.
		 * 
		 * @param instance Object to analyze and describe
		 */
		public function IntrospectionUtil( instance:Object ) {
			_classModel = new ClassModel( instance );
			_classModel.fromXML( describeType( instance ) );
		}
		
		/**
		 * ExampleClass exampleInstance
		 * variables
		 * functions
		 */
		public function toString():String {
			return _classModel ? _classModel.toString() : '';
		}
		
		/*
		 * Getter / setter methods
		 */
		
		public function get classModel():ClassModel {
			return _classModel;
		}
	}
}