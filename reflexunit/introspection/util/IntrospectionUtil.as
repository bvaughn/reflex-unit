package reflexunit.introspection.util {
	import flash.utils.describeType;
	
	import reflexunit.introspection.model.ClassModel;
	
	/**
	 * Analyzes an instance object and describes its public instance variables and methods.
	 * 
	 * @see reflexunit.introspection.model.MethodModel
	 * @see reflexunit.introspection.model.ParameterModel
	 * @see reflexunit.introspection.model.VariableModel
	 */
	public class IntrospectionUtil {
		
		private var _classModel:ClassModel;
		
		/*
		 * Initialization
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