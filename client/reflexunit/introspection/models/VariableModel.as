package reflexunit.introspection.models {
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Represents a public instance variable.
	 * A <code>VariableModel</code> belongs to a <code>ClassModel</code>.
	 * 
	 * @see reflexunit.introspection.models.ClassModel
	 * @see reflexunit.introspection.util.IntrospectionUtil
	 */
	public class VariableModel {
		
		/**
		 * Since the <code>void</code> type is not a Class, this constant represents it.
		 */
		public static const RETURN_TYPE_UNSPECIFIED:* = null;
		
		private var _name:String;
		private var _type:Class;
		
		/*
		 * Initialization
		 */
		
		public function VariableModel() {
		}
		
		/**
		 * Expects XML in the following format:
		 * <code>
		 *   <variable name="boolean" type="Boolean"/>
		 * </code>
		 *  
		 * @see flash.utils.describeType
		 */
		public function fromXML( variableXML:XML ):void {
			_name = variableXML.@name.toString();
			
			
			// The parameter type of '*' is a special case.
			if ( variableXML.@type.toString() != '*' ) {
				_type = getDefinitionByName( variableXML.@type.toString() ) as Class;
			}
		}
		
		/**
		 * public var exampleVariable():Object;
		 */
		public function toString():String {
			return 'public var ' + _name + ':' + getQualifiedClassName( _type ) + ';';
		}
		
		/*
		 * Getter / setter methods
		 */
		
		public function get name():String {
			return _name;
		}
		
		/**
		 * A <code>RETURN_TYPE_UNSPECIFIED</code> value for <code>type</code> indicates that the type is unspecified or <code>*</code>.
		 */
		public function get type():Class {
			return _type;
		}
	}
}