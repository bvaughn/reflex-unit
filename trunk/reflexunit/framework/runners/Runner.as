package reflexunit.framework.runners {
	import reflexunit.framework.IResultViewer;
	import reflexunit.framework.IRunner;
	import reflexunit.framework.ITest;
	import reflexunit.framework.Result;
	import reflexunit.framework.RunEvent;
	import reflexunit.framework.RunNotifier;
	
	/**
	 * Basic implementation of <code>IRunner</code> used to run tests and convey results to one or more <code>ResultViewer</code> objects.
	 */
	public class Runner implements IRunner {
		
		private var _test:ITest;
		private var _result:Result;
		private var _resultViewers:Array;
		private var _runNotifier:RunNotifier;
		
		/*
		 * Initialization
		 */
		
		/**
		 * Constructor.
		 * 
		 * @param resultViewers Array of ResultViewer objects responsible for outputting the result of running the specified ITest
		 */
		public function Runner( resultViewers:Array ) {
			_result = new Result();
			_resultViewers = resultViewers;
		}
		
		/**
		 * @inheritDoc
		 */
		public function run( testToExecute:ITest, runNotifier:RunNotifier ):void {
			_runNotifier = runNotifier;
			_test = testToExecute;
			
			for each ( var resultViewer:IResultViewer in _resultViewers ) {
				resultViewer.result = _result;
				resultViewer.test = _test;
			}
			
			var runNotifier:RunNotifier = new RunNotifier();
			runNotifier.addEventListener( RunEvent.ALL_TESTS_COMPLETED, onAllTestsCompleted, false, 0, true );
			runNotifier.addEventListener( RunEvent.TEST_COMPLETED, onTestCompleted, false, 0, true );
			runNotifier.addEventListener( RunEvent.TEST_STARTING, onTestStarting, false, 0, true );
			
			_test.run( _result, runNotifier );
		}
		
		/*
		 * Getter / setter methods
		 */
		
		/**
		 * @inheritDoc
		 */
		public function get result():Result {
			return _result;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get test():ITest {
			return _test;
		}
		
		/*
		 * Event handlers
		 */
		
		private function onAllTestsCompleted( event:RunEvent ):void {
			_runNotifier.allTestsCompleted();
			
			for each ( var resultViewer:IResultViewer in _resultViewers ) {
				resultViewer.allTestsCompleted();
			}
		}
		
		private function onTestCompleted( event:RunEvent ):void {
			_runNotifier.testCompleted( event.methodModel );
			
			for each ( var resultViewer:IResultViewer in _resultViewers ) {
				resultViewer.testCompleted( event.methodModel );
			}
		}
		
		private function onTestStarting( event:RunEvent ):void {
			_runNotifier.testStarting( event.methodModel );
			
			for each ( var resultViewer:IResultViewer in _resultViewers ) {
				resultViewer.testStarting( event.methodModel );
			}
		}
	}
}