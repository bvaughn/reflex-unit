package reflexunit.rpc {
	import flash.events.EventDispatcher;
	
	/**
	 * 
	 */
	public class RemotingService extends EventDispatcher implements IRemotingService {
		
		private var _outgoingMessageWithReturnHash:Object;
		private var _remotableObjectHash:Object;
		private var _skeleton:ISkeleton;
		private var _stub:IStub;
		
		public function RemotingService( stub:IStub, skeleton:ISkeleton ) {
			_skeleton = skeleton;
			_stub = stub;
			
			_skeleton.addEventListener( SkeletonEvent.MESSAGE_RECEIVED, onMessagedReceived );
			
			_outgoingMessageWithReturnHash = new Object();
			_remotableObjectHash = new Object();
		}
		
		/**
		 * @inheritDoc
		 */
		public function registerRemotableObject( id:String, remotableObject:Object ):void {
			_remotableObjectHash[ id ] = remotableObject;
		}
		
		/**
		 * @inheritDoc
		 */
		public function send( outgoingMessage:IOutgoingMessage ):void {
			var xml:XML = <message />;
			xml.@id = outgoingMessage.id;
			xml.@name = outgoingMessage.messageName;
			xml.@receiverID = outgoingMessage.receiverID;
			
			xml.data = <data />;
			
			var data:XML = outgoingMessage.toXML();
			
			if ( data ) {
				( xml.data[0] as XML ).appendChild( data );
			}
			
			if ( outgoingMessage is IOutgoingMessageWithReturn ) {
				_outgoingMessageWithReturnHash[ outgoingMessage.id ] = outgoingMessage;
			}
			
			_stub.sendMessage( xml );
		}
		
		/**
		 * @inheritDoc
		 */
		public function unregisterRemotableObject( id:String, remotableObject:Object ):void {
			_remotableObjectHash[ id ] = null;
		}
		
		/*
		 * Event handlers
		 */
		
		private function onMessagedReceived( event:SkeletonEvent ):void {
			switch ( event.xml.name() ) {
				case 'message':
					var remotableObject:Object = _remotableObjectHash[ event.xml.@receiverID ];
					
					if ( remotableObject ) {
						var incomingMessage:IIncomingMessage = IncomingMessageFactory.createIncomingMessage( event.xml );
						
						if ( incomingMessage ) {
							incomingMessage.xml = event.xml.data[0] as XML;
							
							incomingMessage.execute( remotableObject );
							
							return;
						}
					}
					
					// TODO: Dispatch ErrorEvent of some sort if no remotable object can be found.
					
					break;
				case 'return':
					var outgoingMessage:IOutgoingMessageWithReturn = _outgoingMessageWithReturnHash[ event.xml.@messageID ] as IOutgoingMessageWithReturn;
					
					if ( outgoingMessage ) {
						outgoingMessage.returnXML = event.xml.data[0] as XML;
						
						return;
					}
					
					// TODO: Dispatch ErrorEvent of some sort if no IOutgoingMessageWithReturn can be found.
					
					break;
			}
		}
	}
}