package reflexunit.rpc {
	
	public class Initialized extends AbstractMessage implements IOutgoingMessage {
		
		private var _receiverID:String;
		
		public function Initialized( receiverIDIn:String ) {
			_receiverID = receiverIDIn;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get messageName():String {
			return 'initialized';
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
			return null;
		}
	}
}