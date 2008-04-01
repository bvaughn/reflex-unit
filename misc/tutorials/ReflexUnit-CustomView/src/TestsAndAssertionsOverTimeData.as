package {
	public class TestsAndAssertionsOverTimeData {
		
		private var _assertionCount:int;
		private var _testCount:int;
		private var _time:Number;
		
		public function TestsAndAssertionsOverTimeData( time:Number, testCount:int = 0, assertionCount:int = 0 ) {
			_time = time;
			
			_assertionCount = assertionCount;
			_testCount = testCount;
		}
		
		public function get assertionCount():int {
			return _assertionCount;
		}
		
		public function get testCount():int {
			return _testCount;
		}
		
		public function get time():Number {
			return _time;
		}
	}
}