package reflexunit.introspection.models {
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Represents a class.
	 * A <code>ClassModel</code> may contain objects of the following type:
	 * <ul>
	 *   <li><code>AccessorModel</code></li>
	 *   <li><code>MetaDataModel</code></li>
	 *   <li><code>MethodModel</code></li>
	 *   <li><code>VariableModel</code></li>
	 * </ul>
	 * 
	 * @see reflexunit.introspection.models.AccessorModel
	 * @see reflexunit.introspection.models.MetaDataModel
	 * @see reflexunit.introspection.models.MethodModel
	 * @see reflexunit.introspection.models.VariableModel
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
		 * <pre>
		 *   &lt;type name="::ClassName" base="Object" isDynamic="true" isFinal="false" isStatic="false"&gt;
		 *     &lt;metadata name="MetaData"&gt;
		 *       &lt;arg key="attribute" value="value" /&gt;
		 *     &lt;/metadata&gt;
		 *     &lt;extendsClass type="Object" /&gt;
		 *   &lt;/type&gt;
		 * </pre>
		 *  
		 * @see flash.utils.describeType
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
			
			for each ( var accessorXML:XML in classXML.accessor ) {
				var accessorModel:AccessorModel = new AccessorModel( _instance );
				accessorModel.fromXML( accessorXML );
				
				_accessorModels.push( accessorModel );
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
			
			_accessorModels.sortOn( 'name' );
			_methodModels.sortOn( 'name' );
			_variableModels.sortOn( 'name' );
		}
		
		/**
		 * Returns a <code>MethodModel</code> for the method specified.
		 * If no such method is defined (or <code>public</code>) then null is returned.
		 */
		public function getMethodModelByName( methodName:String ):MethodModel {
			for each ( var methodModel:MethodModel in _methodModels ) {
				if ( methodModel.name == methodName ) {
					return methodModel;
				}
			}
			
			return null;
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
		
		/**
		 * Array of <code>AccessorModel</code> objects, sorted in ascending order by <code>name</code>.
		 * 
		 * @see reflexunit.introspection.models.AccessorModel
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
		
		/**
		 * Array of <code>MethodModel</code> objects, sorted in ascending order by <code>name</code>.
		 * 
		 * @see reflexunit.introspection.models.MethodModel
		 */
		public function get methodModels():Array {
			return _methodModels;
		}
		
		public function get type():Class {
			return _type;
		}
		
		/**
		 * Array of <code>VariableModel</code> objects, sorted in ascending order by <code>name</code>.
		 * 
		 * @see reflexunit.introspection.models.VariableModel
		 */
		public function get variableModels():Array {
			return _variableModels;
		}
	}
}