package reflexunit.framework {
	import reflexunit.introspection.model.MethodModel;
	
	/**
	 * Contains a collection of other <code>ITest</code> objects.
	 */
	public class TestSuite implements ITest {
		
		private var _nextTestIndex:int;
		private var _result:Result;
		private var _runNotifier:RunNotifier;
		private var _testCount:int;
		private var _tests:Array;
		
		/*
		 * Initialization
		 */
		
		/**
		 * Constructor.
		 * 
		 * @param testClassesIn Array of ITest instances or Class objects comprising a test
		 */
		public function TestSuite( testsIn:Array = null ) {
			_testCount = 0;
			_tests = new Array();
			
			if ( testsIn ) {
				for ( var index:int = 0; index < testsIn.length; index++ ) {
					var test:* = testsIn[ index ];
					
					if ( test is ITest ) {
						addTest( test as ITest );
					} else {
						addTest( new test() as ITest );
					}
				}
			}
		}
		
		/*
		 * Public methods
		 */
		
		/**
		 * Adds a test to the suite.
		 * 
		 * @param test Instance of ITest
		 */
		public function addTest( test:ITest ):void {
			_testCount += test.testCount;
			_tests.push( test );
		}
		
		/**
		 * Adds the tests from the given class to the suite.
		 */
		public function addTestSuite( testSuite:TestSuite ):void {
			for ( var index:int = 0; index < testSuite.testCount; index++ ) {
				addTest( testSuite.getTestAt( index ) );
			}
		}
		
		/**
		 * Returns the test at the given index.
		 * 
		 * @throws RangeError if index provided is invalid
		 */
		public function getTestAt( index:uint ):ITest {
			if ( index >= testCount ) {
				throw new RangeError( 'Invalid index specified for getTestAt' );
			}
			
			return _tests[ index ] as ITest;
		}
		
		/**
		 * @inheritDoc
		 */
		public function run( result:Result, runNotifier:RunNotifier ):void {
			_result = result;
			_runNotifier = runNotifier;
			
			_nextTestIndex = 0;
			
			runNextTest();
		}
		
		/*
		 * Getter / setter methods
		 */
		
		/**
		 * Reference to the <code>ITest</code> currently being executed.
		 */
		public function get currentTest():ITest {
			if ( _nextTestIndex >= _tests.length ) {
				return null;
			}
			
			return _nextTestIndex[ _nextTestIndex ] as ITest;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get currentTestMethodModel():MethodModel {
			if ( currentTest is TestSuite ) {
				return ( currentTest as TestSuite ).currentTestMethodModel;
			} else if ( currentTest is TestCase ) {
				return ( currentTest as TestCase ).currentTestMethodModel;
			} else {
				return null;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get testCount():int {
			return _testCount;
		}
		
		/**
		 * Returns all <code>ITest</code> objects in this suite.
		 */
		public function get tests():Array {
			return _tests;
		}
		
		/*
		 * Helper methods
		 */
		
		private function runNextTest():void {
			
			// Once no more tests are left to run, alert the RunNotifier and return.
			// The container ITest (or Runner) will take things from here.
			if ( _nextTestIndex >= _tests.length ) {
				_runNotifier.allTestsCompleted();
				
				return;
			}
			
			var runNotifier:RunNotifier = new RunNotifier();
			runNotifier.addEventListener( RunEvent.ALL_TESTS_COMPLETED, onAllTestsCompleted, false, 0, true );
			runNotifier.addEventListener( RunEvent.TEST_COMPLETED, onTestCompleted, false, 0, true );
			runNotifier.addEventListener( RunEvent.TEST_STARTING, onTestStarting, false, 0, true );
			
			var test:ITest = _tests[ _nextTestIndex ] as ITest;
			
			// Increment before calling run() (in case the current ITest is completely synchronous).
			_nextTestIndex++;
			
			test.run( _result, runNotifier );
			
		}
		
		/*
		 * Event handlers
		 */
		
		private function onAllTestsCompleted( event:RunEvent ):void {
			runNextTest();
		}
		
		private function onTestCompleted( event:RunEvent ):void {
			_runNotifier.testCompleted( event.methodModel );
		}
		
		private function onTestStarting( event:RunEvent ):void {
			_runNotifier.testStarting( event.methodModel );
		}
	}
}