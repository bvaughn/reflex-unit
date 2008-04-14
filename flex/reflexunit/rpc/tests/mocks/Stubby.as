package reflexunit.rpc.tests.mocks {
	import flash.events.EventDispatcher;
	
	import reflexunit.rpc.ConnectorEvent;
	import reflexunit.rpc.IStub;
	
	public class Stubby extends EventDispatcher implements IStub {
		
		private var _xml:XML;
		
		public function Stubby() {
		}
		
		public function connect():void {
			dispatchEvent( new ConnectorEvent( ConnectorEvent.CONNETED ) );
		}
		
		public function disconnect():void {
		}
		
		public function get serviceIdentifier():String {
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function sendMessage( xmlIn:XML ):void {
			_xml = xmlIn;
		}
		
		public function get xml():XML {
			return _xml;
		}
	}
}