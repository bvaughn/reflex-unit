package {
	import reflexunit.framework.statuses.IStatus;
	
	public class PieChartData {
		
		private var _count:int;
		private var _statusName:String;
		
		public function PieChartData( statusName:String ) {
			_statusName = statusName;
			
			_count = 0;
		}
		
		public function get count():int {
			return _count;
		}
		public function set count( value:int ):void {
			_count = value;
		}
		
		public function get statusName():String {
			return _statusName;
		}
	}
}