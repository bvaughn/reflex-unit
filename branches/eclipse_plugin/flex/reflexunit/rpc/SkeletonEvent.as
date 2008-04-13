package reflexunit.rpc {
	import flash.events.Event;
	
	public class SkeletonEvent extends Event {
		
		public static const MESSAGE_RECEIVED:String = 'SkeletonEvent.MESSAGE_RECEIVED';
		
		private var _xml:XML;
		
		public function SkeletonEvent( type:String, xmlIn:XML ) {
			super( type );
			
			_xml = xmlIn;
		}
		
		public function get xml():XML {
			return _xml;
		}
	}
}