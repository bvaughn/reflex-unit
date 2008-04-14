package reflexunit.rpc {
	import reflexunit.rpc.IIncomingMessage;
	
	public class IncomingMessageFactory {
		
		private static var _incomingMessageHash:Object = new Object();
		
		public static function createIncomingMessage( xml:XML ):IIncomingMessage {
			var incomingMessageClass:Class = _incomingMessageHash[ xml.@name ] as Class;
			
			if ( incomingMessageClass ) {
				return new incomingMessageClass() as IIncomingMessage;
			}
			
			return null;
		}
		
		public static function registerIncomingMessage( xmlName:String, incomingMessageClass:Class ):void {
			_incomingMessageHash[ xmlName ] = incomingMessageClass;
		}
	}
}