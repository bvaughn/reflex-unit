package reflexunit.rpc {
	import flash.events.ErrorEvent;

	public class ConnectorErrorEvent extends ErrorEvent {
		
		public static const ERROR:String = 'ConnectionErrorEvent.ERROR';
		
		private var _error:Error;
		private var _errorEvent:ErrorEvent;
		
		public function ConnectorErrorEvent( type:String, errorIn:Error = null, errorEventIn:ErrorEvent = null ) {
			super( type );
			
			_error = errorIn;
			_errorEvent = errorEventIn;
		}
		
		public function get error():Error {
			return _error;
		}
		
		public function get errorEvent():ErrorEvent {
			return _errorEvent;
		}
		
		public function get message():String {
			if ( error ) {
				return error.message;
			} else if ( errorEvent ) {
				return errorEvent.text;
			} else {
				return null;
			}
		}
	}
}