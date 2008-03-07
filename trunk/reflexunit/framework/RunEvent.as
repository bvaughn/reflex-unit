package reflexunit.framework {
	import flash.events.Event;
	
	import reflexunit.introspection.model.MethodModel;
	
	public class RunEvent extends Event {
		
		public static const ALL_TESTS_COMPLETED:String = 'ALL_TESTS_COMPLETED';
		
		public static const TEST_COMPLETED:String = 'TEST_COMPLETED';
		
		public static const TEST_STARTING:String = 'TEST_STARTING';
		
		// TODO: Add more notify events.
		
		private var _methodModel:MethodModel;
		
		public function RunEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) {
			super( type, bubbles, cancelable );
		}
		
		public function get methodModel():MethodModel {
			return _methodModel;
		}
		public function set methodModel( value:MethodModel ):void {
			_methodModel = value;
		}
		
		public function get test():* {
			return _methodModel ? _methodModel.thisObject : null;
		}
	}
}