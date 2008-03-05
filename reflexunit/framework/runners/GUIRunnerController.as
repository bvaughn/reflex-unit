package funit.framework.runners {
	import flash.utils.getQualifiedClassName;
	
	import funit.framework.Failure;
	import funit.framework.GUIRunner;
	import funit.framework.IStatus;
	import funit.framework.ITest;
	import funit.framework.InProgress;
	import funit.framework.Result;
	import funit.framework.RunEvent;
	import funit.framework.RunNotifier;
	import funit.framework.Success;
	import funit.introspection.model.MethodModel;
	
	import mx.controls.dataGridClasses.DataGridColumn;
	
	public class GUIRunnerController {
		
		private var _currentStatus:IStatus;
		private var _initialized:Boolean;
		private var _test:ITest;
		private var _result:Result;
		private var _view:GUIRunner;
		
		/*
		 * Initialization
		 */
		
		public function GUIRunnerController( view:GUIRunner ) {
			_view = view;
		}
		
		public function initialize():void {
			_initialized = true;
		}
		
		/**
		 * @see funit.framework.IResultViewer#allTestsCompleted
		 */
		public function allTestsCompleted():void {
			// TODO
		}
		
		/**
		 * @see funit.framework.IResultViewer#testCompleted
		 */
		public function testCompleted( methodModel:MethodModel ):void {
			
			// Remove the InProgress status and add the completed status.
			_view.dataProvider.removeItemAt( _view.dataProvider.length - 1 );
			
			if ( _result.errorCount > 0 && ( _result.errors[ _result.errorCount - 1 ] as Failure ).methodModel.method == methodModel.method ) {
				_view.dataProvider.addItem( _result.errors[ _result.errorCount - 1 ] as Failure );
			} else if ( _result.failureCount > 0 && ( _result.failures[ _result.failureCount - 1 ] as Failure ).methodModel.method == methodModel.method ) {
				_view.dataProvider.addItem( _result.failures[ _result.failureCount - 1 ] as Failure );
			} else {
				_view.dataProvider.addItem( new Success( _currentStatus.methodModel ) );
			}
		}
		
		/**
		 * @see funit.framework.IResultViewer#testStarting
		 */
		public function testStarting( methodModel:MethodModel ):void {
			_currentStatus = new InProgress( methodModel );
			
			_view.dataProvider.addItem( _currentStatus );
		}
		
		/*
		 * Getter / setter methods
		 */
		
		/**
		 * @see funit.framework.IResultViewer#result
		 */
		public function set result( value:Result ):void {
			_result = value;
		}
		
		/**
		 * @see funit.framework.IResultViewer#test
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
trace( 'getTestName(): ' + ( data as IStatus ).methodModel.name + ' => ' + ( data as IStatus ).methodModel.thisObject );
			return ( data as IStatus ).methodModel.name;
		}
	}
}