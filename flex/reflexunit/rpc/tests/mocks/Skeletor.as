package reflexunit.rpc.tests.mocks {
	import flash.events.EventDispatcher;
	
	import reflexunit.rpc.ConnectorEvent;
	import reflexunit.rpc.ISkeleton;
	
	public class Skeletor extends EventDispatcher implements ISkeleton {
		
		public function Skeletor() {
		}
		
		public function connect():void {
			dispatchEvent( new ConnectorEvent( ConnectorEvent.CONNETED ) );
		}
		
		public function disconnect():void {
		}
		
		public function get serviceIdentifier():String {
			return null;
		}
	}
}