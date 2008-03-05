package reflexunit.framework.runners {
	import flash.utils.getQualifiedClassName;
	
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.events.ListEvent;
	
	import reflexunit.framework.Failure;
	import reflexunit.framework.GUIRunner;
	import reflexunit.framework.IStatus;
	import reflexunit.framework.ITest;
	import reflexunit.framework.InProgress;
	import reflexunit.framework.Result;
	import reflexunit.framework.Success;
	import reflexunit.introspection.model.MethodModel;
	
	public class GUIRunnerController {
		
		private var _currentStatus:IStatus;
		private var _currentTestNum:int;
		private var _initialized:Boolean;
		private var _test:ITest;
		private var _result:Result;
		private var _view:GUIRunner;
		
		/*
		 * Initialization
		 */
		
		public function GUIRunnerController( view:GUIRunner ) {
			_view = view;
			
			_currentTestNum = 0;
		}
		
		public function initialize():void {
			_initialized = true;
			
			_view.dataGrid.addEventListener( ListEvent.ITEM_CLICK, onDataGridItemClick, false, 0, true );
		}
		
		/**
		 * @see reflexunit.framework.IResultViewer#allTestsCompleted
		 */
		public function allTestsCompleted():void {
			// TODO
		}
		
		/**
		 * @see reflexunit.framework.IResultViewer#testCompleted
		 */
		public function testCompleted( methodModel:MethodModel ):void {
			
			// Remove the InProgress status and add the completed status.
			_view.dataProvider.removeItemAt( _view.dataProvider.length - 1 );
			
			_view.numErrorsLabel.text = _result.errorCount.toString();
			_view.numFailuresLabel.text = _result.failureCount.toString();
			_view.numTestsLabel.text = _currentTestNum + '/' + _test.testCount;
			
			_view.progressBar.width = ( _view.progressBarContainer.width * ( _currentTestNum / _test.testCount ) );
			
			if ( _result.errorCount > 0 && ( _result.errors[ _result.errorCount - 1 ] as Failure ).methodModel.method == methodModel.method ) {
				_view.dataProvider.addItem( _result.errors[ _result.errorCount - 1 ] as Failure );
			} else if ( _result.failureCount > 0 && ( _result.failures[ _result.failureCount - 1 ] as Failure ).methodModel.method == methodModel.method ) {
				_view.dataProvider.addItem( _result.failures[ _result.failureCount - 1 ] as Failure );
			} else {
				_view.dataProvider.addItem( new Success( _currentStatus.methodModel ) );
			}
		}
		
		/**
		 * @see reflexunit.framework.IResultViewer#testStarting
		 */
		public function testStarting( methodModel:MethodModel ):void {
			_currentStatus = new InProgress( methodModel );
			
			_view.dataProvider.addItem( _currentStatus );
			
			_currentTestNum++;
		}
		
		/*
		 * Getter / setter methods
		 */
		
		/**
		 * @see reflexunit.framework.IResultViewer#result
		 */
		public function set result( value:Result ):void {
			_result = value;
		}
		
		/**
		 * @see reflexunit.framework.IResultViewer#test
		 */
		public function set test( value:ITest ):void {
			_test = value;
		}
		
		/*
		 * Helper methods
		 */
		
		public static function getMessage( data:Object, dataGridColumn:DataGridColumn ):String {
			if ( data is Failure ) {
				return ( data as Failure ).errorMessage;
			} else {
				return '';
			}
		}
		
		public static function getTestCaseName( data:Object, dataGridColumn:DataGridColumn ):String {
			return getQualifiedClassName( ( data as IStatus ).methodModel.thisObject );
		}
		
		public static function getTestName( data:Object, dataGridColumn:DataGridColumn ):String {
			return ( data as IStatus ).methodModel.name;
		}
		
		/*
		 * Event handlers
		 */
		
		private function onDataGridItemClick( event:ListEvent ):void {
			var message:String;
			var stackTraceText:String;
			var test:String;
			var testCase:String;
			
			if ( event.itemRenderer.data is Failure ) {
				var failure:Failure = event.itemRenderer.data as Failure;
				
				message = failure.errorMessage; 
				stackTraceText = failure.error.getStackTrace();
				test = failure.methodModel.name;
				testCase = getQualifiedClassName( failure.methodModel.methodDefinedBy );
				
			} else if ( event.itemRenderer.data is Success ) {
				var success:Success = event.itemRenderer.data as Success;
				
				message = ''; 
				stackTraceText = ''; 
				test = success.methodModel.name;
				testCase = getQualifiedClassName( success.methodModel.methodDefinedBy );
				
			} else {
				message = ''; 
				stackTraceText = '';
				test = '';
				testCase = '';
			}
			
			_view.messageLabel.text = message;
			_view.stackTraceTextArea.text = stackTraceText;
			_view.testCaseLabel.text = testCase;
			_view.testLabel.text = test;
		}
	}
}