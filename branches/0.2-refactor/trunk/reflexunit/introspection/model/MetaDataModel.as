package reflexunit.introspection.model {
	
	/**
	 * Represents additional descriptive/behavioral data related to a <code>ClassModel</code>, <code>MethodModel</code>, or <code>AccessorModel</code>.
	 * 
	 * @see reflexunit.introspection.util.IntrospectionUtil
	 */
	public class MetaDataModel {
		
		private var _argModels:Array;
		private var _name:String;
		
		/*
		 * Initialization
		 */
		
		public function MetaDataModel() {
			_argModels = new Array();
		}
		
		/**
		 * Expects XML in the following format:
		 * <code>
		 *   <metadata name="MetaData">
		 *     <arg key="attribute" value="value" />
		 *   </metadata>
		 * </code>
		 */
		public function fromXML( metaDataXML:XML ):void {
			_name = metaDataXML.@name.toString();
			
			for each ( var argXML:XML in metaDataXML.arg ) {
				var argModel:ArgModel = new ArgModel();
				argModel.fromXML( argXML );
				
				_argModels.push( argModel );
			}
			
			_argModels.sortOn( 'key' );
		}
		
		/**
		 * [MetaData(arg1="value", arg2="value")]
		 */
		public function toString():String {
			var argsStringArray:Array = new Array();
			
			for each ( var argModel:ArgModel in _argModels ) {
				argsStringArray.push( argModel.toString() );
			}
			
			var argsString:String = ( argsStringArray.length > 0 ) ? argsStringArray.join( ', ' ) : '';
			
			return '[' + _name + argsString + ']';
		}
		
		/*
		 * Getter / setter methods
		 */
		
		/**
		 * Array of <code>ArgModel</code> objects, sorted in ascending order by <code>key</code>.
		 * 
		 * @see reflexunit.introspection.model.ArgModel
		 */
		public function get argModels():Array {
			return _argModels;
		}
		
		public function get name():String {
			return _name;
		}
	}
}