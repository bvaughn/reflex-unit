package reflexunit.introspection.model {
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Represents a class.
	 * 
	 * @see reflexunit.introspection.util.IntrospectionUtil
	 */
	public class ClassModel {
		
		private var _accessorModels:Array;
		private var _instance:Object;
		private var _isDynamic:Boolean;
		private var _isFinal:Boolean;
		private var _isStatic:Boolean;
		private var _name:String;
		private var _metaDataModel:MetaDataModel;
		private var _methodModels:Array;
		private var _type:Class;
		private var _variableModels:Array;
		
		/*
		 * Initialization
		 */
		
		public function ClassModel( instanceIn:Object ) {
			_instance = instanceIn;
			
			_accessorModels = new Array();
			_methodModels = new Array();
			_variableModels = new Array();
		}
		
		/**
		 * Expects XML in the following format:
		 * <code>
		 *   <type name="::ClassName" base="Object" isDynamic="true" isFinal="false" isStatic="false">
		 *     <metadata name="MetaData">
		 *       <arg key="attribute" value="value"/>
		 *     </metadata>
		 *     <extendsClass type="Object" />
		 *   </type>
		 * </code>
		 */
		public function fromXML( classXML:XML ):void {
			_isDynamic = classXML.@isDynamic.toString() == 'true';
			_isFinal = classXML.@isFinal.toString() == 'true';
			_isStatic = classXML.@isStatic.toString() == 'true';
			_name = classXML.@name.toString();
			_type = getDefinitionByName( getQualifiedClassName( _instance ) ) as Class;
			
			// Not all classes have metadata.
			if ( classXML.metadata.length() > 0 ) {
				_metaDataModel = new MetaDataModel();
				_metaDataModel.fromXML( classXML.metadata[0] as XML );
			}
			
			for each ( var methodXML:XML in classXML.method ) {
				var methodModel:MethodModel = new MethodModel( _instance );
				methodModel.fromXML( methodXML );
				
				_methodModels.push( methodModel );
			}
			
			for each ( var variableXML:XML in classXML.variable ) {
				var variableModel:VariableModel = new VariableModel();
				variableModel.fromXML( variableXML );
				
				_variableModels.push( variableModel );
			}
			
			_methodModels.sortOn( 'name' );
			_variableModels.sortOn( 'name' );
		}
		
		/**
		 * public function exampleFunction():void {} [SampleClass]
		 */
		public function toString():String {
			var strings:Array = [ _name + ' ' + _instance ];
			
			if ( _metaDataModel ) {
				strings.push( _metaDataModel.toString() );
			}
			
			for each ( var variableModel:VariableModel in _variableModels ) {
				strings.push( variableModel.toString() );
			}
			
			for each ( var accessorModel:AccessorModel in _accessorModels ) {
				strings.push( accessorModel.toString() );
			}
			
			for each ( var methodModel:MethodModel in _methodModels ) {
				strings.push( methodModel.toString() );
			}
			
			return strings.join( "\n" );
		}
		
		/*
		 * Getter / setter methods
		 */
		
		public function get accessorModels():Array {
			return _accessorModels;
		}
		
		public function get instance():Object {
			return _instance;
		}
		
		public function get isDynamic():Boolean {
			return _isDynamic;
		}
		
		public function get isFinal():Boolean {
			return _isFinal;
		}
		
		public function get isStatic():Boolean {
			return _isStatic;
		}
		
		public function get name():String {
			return _name;
		}
		
		public function get metaDataModel():MetaDataModel {
			return _metaDataModel;
		}
		
		public function get methodModels():Array {
			return _methodModels;
		}
		
		public function get type():Class {
			return _type;
		}
		
		public function get variableModels():Array {
			return _variableModels;
		}
	}
}