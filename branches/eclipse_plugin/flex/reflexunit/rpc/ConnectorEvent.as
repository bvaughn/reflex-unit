package reflexunit.rpc {
	import flash.events.Event;
	
	public class ConnectorEvent extends Event {
		
		public static const CONNETED:String = 'ConnectorEvent.CONNETED';
		public static const DISCONNETED:String = 'ConnectorEvent.DISCONNETED';
		
		public function ConnectorEvent( type:String ) {
			super( type );
		}
	}
}