package reflexunit.framework {
	import flash.events.EventDispatcher;
	
	import reflexunit.introspection.models.MethodModel;
	
	/**
	 * A <code>RunNotifier</code> is used by several of the testing framework classes to monitor the status of executing tests.
	 * It is typically passed as a parameter to a <code>run</code> method and listened to by the caller class for events.
	 * 
	 * @see reflexunit.framework.RunEvent
	 */
	public class RunNotifier extends EventDispatcher implements ITestWatcher {
		
		/*
		 * ITestWatcher methods
		 */
		
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