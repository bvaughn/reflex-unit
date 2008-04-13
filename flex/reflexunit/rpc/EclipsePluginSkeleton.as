package reflexunit.rpc {
	import flash.events.ProgressEvent;
	
	/**
	 * 
	 */
	public class EclipsePluginSkeleton extends EclipsePluginConnector {
		
		public function EclipsePluginSkeleton( host:String, port:int ) {
			super( host, port );
		}
		
		override protected function onSocketProgressEvent( event:ProgressEvent ):void {
			if ( event.bytesLoaded < event.bytesTotal ) {
				return;
			}
			
			try {
				var xml:XML = new XML( _socket.readUTF() );
				
				_socket.writeInt( 1 );
				_socket.flush();
				
				dispatchEvent( new SkeletonEvent( SkeletonEvent.MESSAGE_RECEIVED, xml ) );
				
			} catch ( error:Error ) {
				dispatchEvent( new ConnectorErrorEvent( ConnectorErrorEvent.ERROR, error ) );
			}
		}
	}
}