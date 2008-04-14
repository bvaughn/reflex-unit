package reflexunit.rpc {
	import flash.events.IEventDispatcher;
	
	/**
	 * Redispatches <code>ConnectorErrorEvent</code> events.
	 */
	public interface IRemotingService extends IEventDispatcher {
		
		/**
		 * Used to register remotable objects which can receive <code>IIncomingMessage</code> messages.
		 */
		function registerRemotableObject( id:String, remotableObject:Object ):void;
		
		/**
		 * 
		 */
		function send( outgoingMessage:IOutgoingMessage ):void;
		
		/**
		 * 
		 */
		function unregisterRemotableObject( id:String, remotableObject:Object ):void;
	}
}