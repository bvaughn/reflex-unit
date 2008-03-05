package reflexunit.introspection.model {
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Represents a public instance variable.
	 * 
	 * @see reflexunit.introspection.util.IntrospectionUtil
	 */
	public class VariableModel {
		
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
		 * A <code>null</code> value for <code>type</code> indicates that the type is unspecified or <code>*</code>.
		 */
		public function get type():Class {
			return _type;
		}
	}
}