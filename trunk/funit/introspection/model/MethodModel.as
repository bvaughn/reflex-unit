package funit.introspection.model {
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Represents a public instance method.
	 * 
	 * @see funit.introspection.util.IntrospectionUtil
	 */
	public class MethodModel {
		
		private var _method:Function;
		private var _methodDefinedBy:Class;
		private var _name:String;
		private var _parameterModels:Array;
		private var _returnType:Class;
		private var _thisObject:Object;
		
		/*
		 * Initialization
		 */
		
		public function MethodModel( thisObjectIn:Object ) {
			_thisObject = thisObjectIn;
			
			_parameterModels = new Array();
		}
		
		/**
		 * Expects XML in the following format:
		 * <code>
		 *   <method name="expectsArguments" declaredBy="TestClass" returnType="Boolean">
		 *     <parameter index="1" type="String" optional="false"/>
		 *     <parameter index="2" type="Boolean" optional="true"/>
		 *   </method>
		 * </code>
		 */
		public function fromXML( methodXML:XML ):void {
			_methodDefinedBy = getDefinitionByName( methodXML.@declaredBy.toString() ) as Class;
			_method = _thisObject[ methodXML.@name.toString() ] as Function;
			_name = methodXML.@name.toString();
			
			// A return type of 'void' is a special case.
			// It can't be cast to a Class and so must be indicated by 'null'.
			if ( methodXML.@returnType.toString() != 'void' ) {
				_returnType = getDefinitionByName( methodXML.@returnType.toString() ) as Class;
			}
			
			for each ( var parameterXML:XML in methodXML.parameter ) {
				var parameterModel:ParameterModel = new ParameterModel();
				parameterModel.fromXML( parameterXML );
				
				_parameterModels.push( parameterModel );
			}
		}
		
		/**
		 * public function exampleFunction():void {} [SampleClass]
		 */
		public function toString():String {
			var parameters:Array = new Array();
			var parametersString:String;
			
			for each ( var parameterModel:ParameterModel in _parameterModels ) {
				parameters.push( parameterModel.toString() );
			}
			
			parametersString = parameters.length > 0 ?
			                   ' ' + parameters.join( ', ' ) + ' ' : '';
			
			var returnTypeString:String = _returnType ? getQualifiedClassName( _returnType ) : 'void';
			
			return 'public function ' + _name + '(' + parametersString + '):' + returnTypeString + ' {} ' + _methodDefinedBy;
		}
		
		/*
		 * Getter / setter methods
		 */
		
		public function get method():Function {
			return _method;
		}
		
		public function get methodDefinedBy():Class {
			return _methodDefinedBy;
		}
		
		public function get name():String {
			return _name;
		}
		
		/**
		 * Array of <code>ParameterModel</code> objects.
		 */
		public function get parameterModels():Array {
			return _parameterModels;
		}
		
		/**
		 * A <code>null</code> value indicates a <code>returnType</code> of <code>void</code>.
		 */
		public function get returnType():Class {
			return _returnType;
		}
		
		public function get thisObject():Object {
			return _thisObject;
		}
	}
}