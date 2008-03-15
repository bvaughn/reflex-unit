package reflexunit.framework.tests {
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import reflexunit.framework.RunNotifier;
	import reflexunit.framework.Runner;
	import reflexunit.framework.TestCase;
	import reflexunit.framework.TestSuite;
	import reflexunit.framework.events.RunEvent;
	import reflexunit.framework.tests.inner.InnerTestAllMethodNamesGetterMethodsExecuted;
	import reflexunit.framework.tests.inner.InnerTestMetaDataMethodExecution;
	
	/**
	 * Verifies that all (and only) testable methods are executed.
	 * The following method signifying approaches are tested:
	 * <ul>
	 *   <li>Test methods specified w/ the metadata "Test"</li>
	 *   <li>Methods beginning with <code>test*</code></li> 
	 *   <li>Methods explicitly specified in a static <code>testMethodNames</code> getter</li>
	 * </ul>
	 * 
	 * <p>In addition to ensuring that the required methods are executed this class also enforces execution order.
	 * To accomplish this, this class expects all inner tests to use only synchronous assertion methods.</p>
	 */
	[ExcludeClass]
	public class TestMethodExecution extends TestCase {
		
		private var _inProgressTestMethodNames:Array;
		private var _runNotifier:RunNotifier;
		private var _runTimeErrorStrings:Array;
		private var _untestedTestMethodNames:Array;
		
		/*
		 * Initialization
		 */
		
		public function TestMethodExecution() {
			super();
		}
		
		public function testAllMetaDataMethodsExecuted():void {
			var test:InnerTestMetaDataMethodExecution = new InnerTestMetaDataMethodExecution();
			
			_untestedTestMethodNames = test.testMethodNames;
			
			createAndRunTestAfterSettingUntestedMethods( test );
		}
		
		public function testAllNamingConventionMethodsExecuted():void {
			var test:InnerTestMetaDataMethodExecution = new InnerTestMetaDataMethodExecution();
			
			_untestedTestMethodNames = test.testMethodNames;
			
			createAndRunTestAfterSettingUntestedMethods( test );
		}
		
		public function testAllMethodNamesGetterMethodsExecuted():void {
			var test:InnerTestAllMethodNamesGetterMethodsExecuted = new InnerTestAllMethodNamesGetterMethodsExecuted();
			
			_untestedTestMethodNames = InnerTestAllMethodNamesGetterMethodsExecuted.testMethodNames;
			
			createAndRunTestAfterSettingUntestedMethods( test );
		}
		
		/*
		 * Helper methods
		 */
		
		private function createAndRunTestAfterSettingUntestedMethods( test:* ):void {
			_inProgressTestMethodNames = new Array();
			
			// TODO: Assertions cannot be made during "onTestStarting" or "onTestCompleted" methods.
			// There is nothing to catch them currently; (TODO: This should be looked into in the future.)
			// See bug: http://code.google.com/p/reflex-unit/issues/detail?id=1
			_runTimeErrorStrings = new Array();
			
			_runNotifier = new RunNotifier();
			_runNotifier.addEventListener( RunEvent.ALL_TESTS_COMPLETED, addAsync( onAllTestsCompleted ), false, 0, true );
			_runNotifier.addEventListener( RunEvent.TEST_COMPLETED, onTestCompleted, false, 0, true );
			_runNotifier.addEventListener( RunEvent.TEST_STARTING, onTestStarting, false, 0, true );
			
			// TODO: Remove this one Wrapper class is fixed to allow a test to synchronously spawn another test.
			// For more info see comment above.
			var timer:Timer = new Timer( 10, 1 );
			timer.addEventListener( TimerEvent.TIMER_COMPLETE, function( event:TimerEvent ):void {
				Runner.create( new TestSuite( [ test ] ), [], _runNotifier );
			} );
			timer.start();
		}
		
		/*
		 * Event handlers
		 */
		
		// Make sure all expected methods have been "started" and allowed to "complete".
		public function onAllTestsCompleted( event:RunEvent ):void {
			if ( _runTimeErrorStrings.length > 0 ) {
				fail( _runTimeErrorStrings.shift() as String );
			}
			
			assertEquals( _inProgressTestMethodNames.length, 0, 'Not all test methods completed' );
			assertEquals( _untestedTestMethodNames.length, 0, 'Not all test methods have been executed' );
		}
		
		// Make sure that only expected methods are "completed".
		public function onTestCompleted( event:RunEvent ):void {
			var testMethodName:String = _inProgressTestMethodNames.shift() as String;
			
			// TODO: Replace with assertions once bug fixed.
			// For more info see comment in createAndRunTestAfterSettingUntestedMethods().
			if ( _inProgressTestMethodNames.indexOf( event.methodModel.name ) >= 0 ) {
				_runTimeErrorStrings.push( 'Method "' + event.methodModel.name + '" completed out of order' );
			} else if ( testMethodName != event.methodModel.name ) {
				_runTimeErrorStrings.push( 'Unexpected method "' + event.methodModel.name + '" completed' );
			}
		}
		
		// Make sure that only expected methods are "started".
		public function onTestStarting( event:RunEvent ):void {
			var testMethodName:String = _untestedTestMethodNames.shift() as String;
			
			// TODO: Replace with assertions once bug fixed.
			// For more info see comment in createAndRunTestAfterSettingUntestedMethods().
			if ( _untestedTestMethodNames.indexOf( event.methodModel.name ) >= 0 ) {
				_runTimeErrorStrings.push( 'Method "' + event.methodModel.name + '" started out of order' );
			} else if ( testMethodName != event.methodModel.name ) {
				_runTimeErrorStrings.push( 'Unexpected method "' + event.methodModel.name + '" started' );
			}
			
			_inProgressTestMethodNames.push( testMethodName );
		}
	}
}