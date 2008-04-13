package reflexunit.rpc {
	import flash.errors.IOError;
	
	/**
	 * 
	 */
	public class EclipsePluginStub extends EclipsePluginConnector {
		
		public function EclipsePluginStub( host:String, port:int ) {
			super( host, port );
		}
		
		/**
		 * @inheritDoc
		 */
		public function sendMessage( xml:XML ):void {
			if ( state != CONNECTED ) {
				throw IOError( 'Must be connected to send message' );
			}
			
			try {
				_socket.writeUTF( xml.toString() );
				_socket.flush();
				
				var ack:int = _socket.readInt();
			} catch ( error:Error ) {
				dispatchEvent( new ConnectorErrorEvent( ConnectorErrorEvent.ERROR, error ) );
			}
		}
	}
}