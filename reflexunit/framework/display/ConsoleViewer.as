package reflexunit.framework.display {
	import reflexunit.framework.models.Recipe;
	import reflexunit.framework.models.Result;
	import reflexunit.framework.statuses.Failure;
	import reflexunit.framework.statuses.IStatus;
	import reflexunit.introspection.models.MethodModel;
	
	/**
	 * Used to log summary test statistics to the console.
	 * This <code>IResultViewer</code> is mostly useful for debugging purposes.
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
		public function testCompleted( methodModel:MethodModel, status:IStatus ):void {
			trace( '+ completed: ' + methodModel.name + ' => ' + status.status );
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
	}
}