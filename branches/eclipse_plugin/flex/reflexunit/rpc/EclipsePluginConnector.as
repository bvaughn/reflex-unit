package reflexunit.rpc {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	
	/**
	 * 
	 */
	public class EclipsePluginConnector extends EventDispatcher implements IConnector {
		
		public static const CONNECTED:int = 1;
		public static const DISCONNECTED:int = 2;
		
		private var _host:String;
		private var _port:int;
		protected var _socket:Socket;
		private var _state:int;
		
		/**
		 * Constructor.
		 */
		public function EclipsePluginConnector( host:String, port:int ) {
			_host = host;
			_port = port;
			
			_socket = new Socket();
        	_socket.addEventListener( Event.CLOSE, onSocketClose );
        	_socket.addEventListener( Event.CONNECT, onSocketConnect );
        	_socket.addEventListener( IOErrorEvent.IO_ERROR, onSocketIOError );
        	_socket.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSocketSecurityError );
        	_socket.addEventListener( ProgressEvent.SOCKET_DATA, onSocketProgressEvent );
        	
        	_state = DISCONNECTED;
		}
		
		/**
		 * @inheritDoc
		 */
		public function connect():void {
			try {
				_socket.connect( _host, _port );
			} catch ( error:Error ) {
				dispatchEvent( new ConnectorErrorEvent( ConnectorErrorEvent.ERROR, error ) );
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function disconnect():void {
			_socket.close();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get serviceIdentifier():String {
			return _host + ':' + _port;
		}
		
		/**
		 * 
		 */
		public function get state():int {
			return _state;
		}
		
		/*
		 * Event handlers
		 */
		
		private function onSocketClose( event:Event ):void {
        	_state = DISCONNECTED;
        	
        	dispatchEvent( new ConnectorEvent( ConnectorEvent.DISCONNETED ) );
		}
		
		private function onSocketConnect( event:Event ):void {
        	_state = CONNECTED;
        	
        	dispatchEvent( new ConnectorEvent( ConnectorEvent.CONNETED ) );
		}
		
		private function onSocketIOError( event:IOErrorEvent ):void {
			dispatchEvent( new ConnectorErrorEvent( ConnectorErrorEvent.ERROR, null, event ) );
		}
		
		private function onSocketSecurityError( event:SecurityErrorEvent ):void {
			dispatchEvent( new ConnectorErrorEvent( ConnectorErrorEvent.ERROR, null, event ) );
		}
		
		protected function onSocketProgressEvent( event:ProgressEvent ):void {
		}
	}
}