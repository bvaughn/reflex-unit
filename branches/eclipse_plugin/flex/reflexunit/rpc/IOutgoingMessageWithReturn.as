package reflexunit.rpc {
	import flash.events.IEventDispatcher;
	
	/**
	 * This type of command should not be considered complete until it receives response data.
	 * This data will be assigned to <code>returnXML</code>.
	 */
	public interface IOutgoingMessageWithReturn extends IOutgoingMessage, IEventDispatcher {
		
		/**
		 * Dispatches an <code>OutgoingMessageEvent.RETURN</code>. 
		 */
		function get returnXML():XML;
		function set returnXML( value:XML ):void;
	}
}