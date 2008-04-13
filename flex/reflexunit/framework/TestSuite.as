package reflexunit.framework {
	
	/**
	 * Contains a collection of test classes and/or other <code>TestSuite</code> objects.
	 * A <code>TestSuite</code> is passed to a <code>Runner</code> in order to execute the tests contained.
	 * It is safe to use a single <code>TestSuite</code> for more than one test.
	 * 
	 * @see reflexunit.framework.Runner
	 */
	public class TestSuite {
		
		private var _tests:Array;
		
		/*
		 * Initialization
		 */
		
		/**
		 * Constructor.
		 * 
		 * @param testsIn Array of tests or TestSuites; tests may be instantiated objects or Class objects
		 */
		public function TestSuite( testsAndTestSuites:Array = null ) {
			_tests = new Array();
			
			initTests( testsAndTestSuites );
		}
		
		/*
		 * Public methods
		 */
		
		/**
		 * Adds a test instance to the current suite.
		 * 
		 * @param test Any class defining testable methods
		 */
		public function addTest( test:* ):void {
			_tests.push( test );
		}
		
        /**
         * Adds all tests within a <code>TestSuite</code> to the current suite.
         *
         * @param testSuite TestSuite containing tests and/or other TestSuites
         */
        public function addTestSuite( testSuite:TestSuite ):void {
            for ( var index:int = 0; index < testSuite.testCount; index++ ) {
                var test:* = testSuite.getTestAt( index );
                
                if ( test is Class ) {
                    addTest( new test() );
                } else {
                    addTest( test );
                }
            }
        }
		
		/**
		 * Returns the test at the given index.
		 * 
		 * @throws RangeError if index provided is invalid
		 */
		public function getTestAt( index:uint ):* {
			if ( index >= testCount ) {
				throw new RangeError( 'Invalid index specified for getTestAt' );
			}
			
			return _tests[ index ];
		}
		
		/*
		 * Getter / setter methods
		 */
		
		/**
		 * Convenience method.
		 */
		public function get testCount():int {
			return _tests.length;
		}
		
		/**
		 * Array of objects defining testable methods.
		 */
		public function get tests():Array {
			return _tests;
		}
		
		/*
		 * Helper methods
		 */
		
		private function initTests( testsAndTestSuites:Array ):void {
			
			// TODO: Don't collapse TestSuites until runtime; this way we can display/notify of them uniquely.
			if ( testsAndTestSuites ) {
				for ( var index:int = 0; index < testsAndTestSuites.length; index++ ) {
					var testOrTestSuite:* = testsAndTestSuites[ index ];
					
					if ( testOrTestSuite is TestSuite ) {
						addTestSuite( testOrTestSuite as TestSuite );
					} else if ( testOrTestSuite is Class ) {
						addTest( new testOrTestSuite() );
					} else {
						addTest( testOrTestSuite );
					}
				}
			}
		}
	}
}