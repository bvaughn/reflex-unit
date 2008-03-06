package reflexunit.introspection.model {
	
	/**
	 * Represents an (optional) metadata argument.
	 * 
	 * @see reflexunit.introspection.util.IntrospectionUtil
	 */
	public class ArgModel {
		
		private var _key:String;
		private var _value:String;
		
		/*
		 * Initialization
		 */
		
		public function ArgModel() {
		}
		
		/**
		 * Expects XML in the following format:
		 * <code>
		 *   <arg key="attribute" value="value" />
		 * </code>
		 */
		public function fromXML( argXML:XML ):void {
			_key = argXML.@key.toString();
			_value = argXML.@value.toString();
		}
		
		/**
		 * key="value"
		 */
		public function toString():String {
			return _key + '="' + _value + '"';
		}
		
		/*
		 * Getter / setter methods
		 */
		
		public function get key():String {
			return _key;
		}
		
		public function get value():String {
			return _value;
		}
	}
}