package reflexunit.introspection.model {
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Represents a function parameter.
	 * This type of object belongs to a <code>MethodModel</code>.
	 * 
	 * @see reflexunit.introspection.model.MethodModel
	 * @see reflexunit.introspection.util.IntrospectionUtil
	 */
	public class ParameterModel {
		
		/**
		 * Since the <code>*</code> (unspecified) type is not a Class, this constant represents it.
		 */
		public static const RETURN_TYPE_UNSPECIFIED:* = null;
		
		private var _index:int;
		private var _optional:Boolean;
		private var _type:Class;
		
		/*
		 * Initialization
		 */
		
		public function ParameterModel() {
		}
		
		/**
		 * Expects XML in the following format:
		 * <code>
		 *   <parameter index="2" type="Boolean" optional="true"/>
		 * </code>
		 */
		public function fromXML( parameterXML:XML ):void {
			_index = int( parameterXML.@index );
			_optional = parameterXML.@optional.toString() == 'true';
			
			// The parameter type of '*' is a special case.
			if ( parameterXML.@type.toString() != '*' ) {
				_type = getDefinitionByName( parameterXML.@type.toString() ) as Class;
			}
		}
		
		/**
		 * 1:Boolean = null
		 */
		public function toString():String {
			if ( _optional ) {
				return _index + ':' + getQualifiedClassName( _type ) + ' = null';
			} else {
				return _index + ':' + getQualifiedClassName( _type );
			}
		}
		
		/*
		 * Getter / setter methods
		 */
		
		public function get index():int {
			return _index;
		}
		
		public function get optional():Boolean {
			return _optional;
		}
		
		/**
		 * A <code>RETURN_TYPE_UNSPECIFIED</code> value for <code>type</code> indicates that the type is unspecified or <code>*</code>.
		 */
		public function get type():Class {
			return _type;
		}
	}
}