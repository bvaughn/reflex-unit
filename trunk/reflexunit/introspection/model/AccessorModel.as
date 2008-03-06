package reflexunit.introspection.model {
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Represents a public getter, setter, or getter/setter pair.
	 * 
	 * @see reflexunit.introspection.util.IntrospectionUtil
	 */
	public class AccessorModel {
		
		/**
		 * Since the <code>void</code> type is not a Class, this constant represents it.
		 */
		public static const RETURN_TYPE_VOID:* = null;
		
		private var _metaDataModel:MetaDataModel;
		private var _methodDefinedBy:Class;
		private var _name:String;
		private var _readOnly:Boolean;
		private var _thisObject:Object;
		private var _type:Class;
		private var _writeOnly:Boolean;
		
		/*
		 * Initialization
		 */
		
		public function AccessorModel( thisObjectIn:Object ) {
			_thisObject = thisObjectIn;
		}
		
		/**
		 * Expects XML in the following format:
		 * <code>
		 *   <accessor name="description" access="readonly" type="reflexunit.framework::Description" declaredBy="reflexunit.framework::TestCase" />
		 * </code>
		 */
		public function fromXML( methodXML:XML ):void {
			_methodDefinedBy = getDefinitionByName( methodXML.@declaredBy.toString() ) as Class;
			_name = methodXML.@name.toString();
			_readOnly = methodXML.@access.toString() == 'readonly';
			_writeOnly = methodXML.@access.toString() == 'writeonly';
			
			// Not all accessors have metadata.
			if ( methodXML.metadata.length() > 0 ) {
				_metaDataModel = new MetaDataModel();
				_metaDataModel.fromXML( methodXML.metadata[0] as XML );
			}
			
			// A return type of 'void' is a special case.
			// It can't be cast to a Class and so must be indicated by 'null'.
			if ( methodXML.@type.toString() != 'void' ) {
				_type = getDefinitionByName( methodXML.@type.toString() ) as Class;
			}
		}
		
		/**
		 * public function exampleFunction():void {} [SampleClass]
		 */
		public function toString():String {
			var typeString:String = _type ? getQualifiedClassName( _type ) : 'void';
			
			var metaDataString:String = '';
			
			if ( _metaDataModel ) {
				metaDataString = _metaDataModel.toString() + "\n";
			}
			
			var getSetString:String = _readOnly ? 'get' : ( _writeOnly ? 'set' : 'get/set' );
			
			return metaDataString + 'public function ' + getSetString + ' ' + _name + ':' + typeString + ' {} ' + _methodDefinedBy;
		}
		
		/*
		 * Getter / setter methods
		 */
		
		public function get metaDataModel():MetaDataModel {
			return _metaDataModel;
		}
		
		public function get methodDefinedBy():Class {
			return _methodDefinedBy;
		}
		
		public function get name():String {
			return _name;
		}
		
		public function get readOnly():Boolean {
			return _readOnly;
		}
		
		public function get thisObject():Object {
			return _thisObject;
		}
		
		/**
		 * A <code>RETURN_TYPE_VOID</code> value indicates a <code>type</code> of <code>void</code>.
		 */
		public function get type():Class {
			return _type;
		}
		
		public function get writeOnly():Boolean {
			return _writeOnly;
		}
	}
}