package reflexunit.rpc {
	import flash.events.DataEvent;
	
	/**
	 * 
	 */
	public class EclipsePluginSkeleton extends EclipsePluginConnector {
		
		public function EclipsePluginSkeleton( host:String, port:int ) {
			super( host, port );
		}
		
		override protected function onSocketDataEvent( event:DataEvent ):void {
			try {
				var xml:XML = new XML( event.data );
						
				dispatchEvent( new SkeletonEvent( SkeletonEvent.MESSAGE_RECEIVED, xml ) );
				
			} catch ( error:Error ) {
				dispatchEvent( new ConnectorErrorEvent( ConnectorErrorEvent.ERROR, error ) );
			}
		}
	}
}