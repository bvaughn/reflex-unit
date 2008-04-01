package {
	public class TimeChartData {
		
		private var _testsRemaining:int;
		private var _testsRun:int;
		private var _time:Number;
		
		public function TimeChartData( time:Number, testsRun:int = 0, testsRemaining:int = 0 ) {
			_time = time;
			
			_testsRemaining = testsRemaining;
			_testsRun = testsRun;
		}
		
		public function get testsRemaining():int {
			return _testsRemaining;
		}
		
		public function get testsRun():int {
			return _testsRun;
		}
		
		public function get time():Number {
			return _time;
		}
	}
}