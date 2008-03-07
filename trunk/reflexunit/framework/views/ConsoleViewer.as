package reflexunit.framework.views {
	import reflexunit.framework.Failure;
	import reflexunit.framework.IResultViewer;
	import reflexunit.framework.Recipe;
	import reflexunit.framework.Result;
	import reflexunit.framework.Success;
	import reflexunit.introspection.model.MethodModel;
	
	/**
	 * Used to log summary test statistics to the console.
	 */
	public class ConsoleViewer implements IResultViewer {
		
		private var _recipe:Recipe;
		private var _result:Result;
		
		/*
		 * Initialization
		 */
		
		/**
		 * Constructor.
		 */
		public function ConsoleViewer() {
			trace( '>>> Beginning Test --------------' );
		}
		
		/**
		 * @inheritDoc
		 */
		public function allTestsCompleted():void {
			trace( '>>> Final Stats -----------------' );
			trace( '+ testsRun: ' + _result.testsRun );
			trace( '+ errorCount: ' + _result.errorCount );
			trace( '+ failureCount: ' + _result.failureCount );
			
			var failure:Failure;
			
			if ( _result.errorCount > 0 ) {
				trace( '>>> Errors ----------------------' );
			}
			
			for each ( failure in _result.errors ) {
				trace( '+ ' + failure.methodModel + ' => ' + failure.errorMessage );
				//trace( failure.error.getStackTrace() );
			}
			
			if ( _result.failureCount > 0 ) {
				trace( '>>> Failures --------------------' );
			}
			
			for each ( failure in _result.failures ) {
				trace( '+ ' + failure.methodModel + ' => ' + failure.errorMessage );
				//trace( failure.error.getStackTrace() );
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function testCompleted( methodModel:MethodModel ):void {
			trace( '+ completed: ' + methodModel.name + ' => ' + getTestStatus( methodModel ) );
		}
		
		/**
		 * @inheritDoc
		 */
		public function testStarting( methodModel:MethodModel ):void {
			trace( '+ starting: ' + methodModel.name );
		}
		
		/*
		 * Getter / setter methods
		 */
		
		/**
		 * @inheritDoc
		 */
		public function set recipe( value:Recipe ):void {
			_recipe = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set result( value:Result ):void {
			_result = value;
		}
		
		/*
		 * Helper methods
		 */
		
		private function getTestStatus( methodModel:MethodModel ):String {
			var failure:Failure;
			
			for each ( failure in _result.errors ) {
				if ( failure.methodModel == methodModel ) {
					return failure.status;
				}
			}
			
			for each ( failure in _result.failures ) {
				if ( failure.methodModel == methodModel ) {
					return failure.status;
				}
			}
			
			for each ( var success:Success in _result.successes ) {
				if ( success.methodModel == methodModel ) {
					return success.status;
				}
			}
			
			return 'unknown';
		}
	}
}