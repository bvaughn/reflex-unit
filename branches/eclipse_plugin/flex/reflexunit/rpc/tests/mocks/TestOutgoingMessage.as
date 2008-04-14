package reflexunit.rpc.tests.mocks {
	import reflexunit.rpc.AbstractMessage;
	import reflexunit.rpc.IOutgoingMessage;
	
	public class TestOutgoingMessage extends AbstractMessage implements IOutgoingMessage {
		
		private var _messageName:String;
		private var _receiverID:String;
		private var _xml:XML;
		
		public function TestOutgoingMessage( receiverIDIn:String, messageNameIn:String, xmlIn:XML ) {
			_messageName = messageNameIn;
			_receiverID = receiverIDIn;
			_xml = xmlIn;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get messageName():String {
			return _messageName;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get receiverID():String {
			return _receiverID;
		}
		
		/**
		 * @inheritDoc
		 */
		public function toXML():XML {
			return _xml;
		}
	}
}