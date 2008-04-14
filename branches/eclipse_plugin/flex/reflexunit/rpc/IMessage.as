package reflexunit.rpc {
	
	public interface IMessage {
		
		/**
		 * Globally unique identifier.
		 */
		function get id():String;
		
		/**
		 * 
		 */
		function get messageName():String;
		
		/**
		 * 
		 */
		function get receiverID():String;
	}
}