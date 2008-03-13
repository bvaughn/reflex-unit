package reflexunit.framework {
	import flash.events.EventDispatcher;
	
	import reflexunit.framework.statuses.IStatus;
	import reflexunit.introspection.models.MethodModel;
	
	/**
	 * A <code>RunNotifier</code> is used by several of the testing framework classes to monitor the status of executing tests.
	 * It is typically passed as a parameter to a <code>run</code> method and listened to by the caller class for events.
	 * 
	 * @see reflexunit.framework.events.RunEvent
	 */
	public class RunNotifier extends EventDispatcher implements ITestWatcher {
		
		private var _testWatchers:Array;
		
		/*
		 * Initialization
		 */
		
		/**
		 * Constructor.
		 * 
		 * @throws TypeError if resultsViewer contains non-ITestWatcher object(s) 
		 */
		public function RunNotifier( testWatchers:Array = null ):void {
			_testWatchers = new Array();
			
			if ( testWatchers ) {
				for each ( var testWatcher:* in testWatchers ) {
					if ( !( testWatcher is ITestWatcher ) ) {
						throw new TypeError( 'Expected ITestWatcher instance' );
					}
					
					addTestWatcher( testWatcher as ITestWatcher );
				}
			}
		}
		
		public function addTestWatcher( testWatcher:ITestWatcher ):void {
			if ( _testWatchers.indexOf( testWatcher ) >= 0 ) {
				return;	// Don't add the same watcher twice.
			}
			
			_testWatchers.push( testWatcher );
		}
		
		/*
		 * ITestWatcher methods
		 */
		
		/**
		 * @inheritDoc
		 */
		public function allTestsCompleted():void {
			for each ( var testWatcher:ITestWatcher in _testWatchers ) {
				testWatcher.allTestsCompleted();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function testCompleted( methodModel:MethodModel, status:IStatus ):void {
			for each ( var testWatcher:ITestWatcher in _testWatchers ) {
				testWatcher.testCompleted( methodModel, status );
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function testStarting( methodModel:MethodModel ):void {
			for each ( var testWatcher:ITestWatcher in _testWatchers ) {
				testWatcher.testStarting( methodModel );
			}
		}
	}
}