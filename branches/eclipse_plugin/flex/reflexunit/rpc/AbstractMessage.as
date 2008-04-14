package reflexunit.rpc {
	
	public class AbstractMessage implements IMessage {
		
		private static var _globalID:int = 0;
		
		private var _currentID:int;
		private var _id:String;
		
		public function AbstractMessage() {
			_currentID = _globalID++;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get id():String {
			return receiverID + ':' + messageName + ':' + _currentID;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get messageName():String {
			throw new Error( 'Must override messageName' );
		}
		
		/**
		 * @inheritDoc
		 */
		public function get receiverID():String {
			throw new Error( 'Must override receiverID' );
		}
	}
}