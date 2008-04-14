package reflexunit.rpc {
	import flash.events.Event;
	
	/**
	 * 
	 */
	public class OutgoingMessageEvent extends Event {
		
		public static const RETURN:String = 'OutgoingMessageEvent.RETURN';
		
		private var _xml:XML;
		
		public function OutgoingMessageEvent( type:String, xmlIn:XML ) {
			super( type );
			
			_xml = xmlIn;
		}
		
		public function get xml():XML {
			return _xml;
		}
	}
}