package reflexunit.rpc {
	
	/**
	 * 
	 */
	public interface IStub extends IConnector {
		
		/**
		 * Ensures that the specified target of a message receives the message.
		 * 
		 * @throws IOError if not CONNECTED
		 */
		function sendMessage( xml:XML ):void;
	}
}