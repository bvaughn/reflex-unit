package reflexunit.rpc {
	
	/**
	 * 
	 */
	public interface IIncomingMessage extends IMessage {
		
		/**
		 * 
		 */
		function execute( remotableObject:Object ):void;
		
		/**
		 * 
		 */
		function set xml( value:XML ):void;
	}
}