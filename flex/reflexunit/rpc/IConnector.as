package reflexunit.rpc {
	import flash.events.IEventDispatcher;
	
	public interface IConnector extends IEventDispatcher {
		
		/**
		 * Initialize socket connection asynchronously.
		 */
		function connect():void;
		
		/**
		 * Closes socket connection.
		 */
		function disconnect():void;
		
		/**
		 * Unique identifier for service stub points to.
		 */
		function get serviceIdentifier():String;
	}
}