package reflexunit.framework {
	import flash.events.EventDispatcher;
	
	import reflexunit.introspection.model.MethodModel;
	
	/**
	 * Used to signify certain <code>ITest</code> events or actions.
	 */
	public class RunNotifier extends EventDispatcher implements ITestWatcher {
		
		/**
		 * @inheritDoc
		 */
		public function allTestsCompleted():void {
			dispatchEvent( new RunEvent( RunEvent.ALL_TESTS_COMPLETED ) );
		}
		
		/**
		 * @inheritDoc
		 */
		public function testCompleted( methodModel:MethodModel ):void {
			var event:RunEvent = new RunEvent( RunEvent.TEST_COMPLETED );
			event.methodModel = methodModel;
			
			dispatchEvent( event );
		}
		
		/**
		 * @inheritDoc
		 */
		public function testStarting( methodModel:MethodModel ):void {
			var event:RunEvent = new RunEvent( RunEvent.TEST_STARTING );
			event.methodModel = methodModel;
			
			dispatchEvent( event );
		}
	}
}