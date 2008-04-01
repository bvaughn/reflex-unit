package {
	import reflexunit.framework.statuses.Failure;
	import reflexunit.framework.statuses.IStatus;
	import reflexunit.framework.statuses.Success;
	import reflexunit.introspection.models.ClassModel;
	
	public class IndividualTestStatusesData {
		
		private var _classModel:ClassModel;
		private var _errorCount:int;
		private var _failureCount:int;
		private var _successCount:int;
		
		public function IndividualTestStatusesData( classModel:ClassModel ) {
			_classModel = classModel;
			
			_errorCount = 0;
			_failureCount = 0;
			_successCount = 0;
		}
		
		public function addStatus( status:IStatus ):void {
			if ( status is Failure ) {
				var failure:Failure = status as Failure;
				
				if ( failure.isFailure ) {
					_failureCount++;
				} else {
					_errorCount++;
				}
				
			} else if ( status is Success ) {
				_successCount++;
			}
		}
		
		public function get errorCount():int {
			return _errorCount;
		}
		
		public function get failureCount():int {
			return _failureCount;
		}
		
		public function get successCount():int {
			return _successCount;
		}
		
		public function get testCaseName():String {
			return _classModel.name;
		}
	}
}