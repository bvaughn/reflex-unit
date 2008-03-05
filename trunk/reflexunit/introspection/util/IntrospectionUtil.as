package reflexunit.introspection.util {
	import reflexunit.introspection.model.MethodModel;
	import reflexunit.introspection.model.VariableModel;
	
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Analyzes an instance object and describes its public instance variables and methods.
	 * 
	 * @see reflexunit.introspection.model.MethodModel
	 * @see reflexunit.introspection.model.ParameterModel
	 * @see reflexunit.introspection.model.VariableModel
	 */
	public class IntrospectionUtil {
		
		private var _describeTypeXML:XML;
		private var _instance:Object;
		private var _instanceClass:Class;
		private var _methodModels:Array;
		private var _variableModels:Array;
		
		/*
		 * Initialization
		 */
		
		public function IntrospectionUtil( instance:Object ) {
			_instance = instance;
			_instanceClass = getDefinitionByName( getQualifiedClassName( instance ) ) as Class;
			
			_methodModels = new Array();
			_variableModels = new Array();
			
			initClassInformation();
		}
		
		/**
		 * ExampleClass exampleInstance
		 * variables
		 * functions
		 */
		public function toString():String {
			var strings:Array = [ _instanceClass + ' ' + _instance ];
			
			for each ( var variableModel:VariableModel in _variableModels ) {
				strings.push( variableModel.toString() );
			}
			
			for each ( var methodModel:MethodModel in _methodModels ) {
				strings.push( methodModel.toString() );
			}
			
			return strings.join( "\n" );
		}
		
		/*
		 * Helper methods
		 */
		
		private function initClassInformation():void {
			_describeTypeXML = describeType( _instance );
			
			for each ( var methodXML:XML in _describeTypeXML.method ) {
				var methodModel:MethodModel = new MethodModel( _instance );
				methodModel.fromXML( methodXML );
				
				_methodModels.push( methodModel );
			}
			
			for each ( var variableXML:XML in _describeTypeXML.variable ) {
				var variableModel:VariableModel = new VariableModel();
				variableModel.fromXML( variableXML );
				
				_variableModels.push( variableModel );
			}
			
			_methodModels.sortOn( 'name' );
			_variableModels.sortOn( 'name' );
		}
		
		/*
		 * Getter / setter methods
		 */
		
		public function get instance():Object {
			return _instance;
		}
		
		public function get instanceClass():Class {
			return _instanceClass;
		}
		
		public function get methodModels():Array {
			return _methodModels;
		}
		
		public function get variableModels():Array {
			return _variableModels;
		}
	}
}