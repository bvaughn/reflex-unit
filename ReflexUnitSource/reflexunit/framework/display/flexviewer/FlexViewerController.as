package reflexunit.framework.display.flexviewer {
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	import mx.controls.ProgressBarMode;
	import mx.events.ListEvent;
	
	import reflexunit.framework.RunNotifier;
	import reflexunit.framework.Runner;
	import reflexunit.framework.display.ConsoleViewer;
	import reflexunit.framework.display.flexviewer.embedded.Resources;
	import reflexunit.framework.events.RunEvent;
	import reflexunit.framework.models.Recipe;
	import reflexunit.framework.models.Result;
	import reflexunit.framework.statuses.Failure;
	import reflexunit.framework.statuses.IStatus;
	import reflexunit.framework.statuses.Success;
	import reflexunit.framework.statuses.Untested;
	import mx.controls.ProgressBar;
	
	[ExcludeClass]
	public class FlexViewerController {
		
		private var _activeRecipe:Recipe;
		private var _initialized:Boolean;
		private var _recipe:Recipe;
		private var _result:Result;
		private var _runNotifier:RunNotifier;
		private var _testInProgress:Boolean;
		private var _view:FlexViewer;
		
		/*
		 * Initialization
		 */
		
		public function FlexViewerController( view:FlexViewer ) {
			_view = view;
			
			_runNotifier = new RunNotifier();
			_runNotifier.addEventListener( RunEvent.ALL_TESTS_COMPLETED, onAllTestsCompleted, false, 0, true );
			_runNotifier.addEventListener( RunEvent.TEST_COMPLETED, onTestCompleted, false, 0, true );
			_runNotifier.addEventListener( RunEvent.TEST_STARTING, onTestStarting, false, 0, true );
		}
		
		public function initialize():void {
			_initialized = true;
			
			recipe = _recipe;
			
			_view.runAllButton.addEventListener( MouseEvent.CLICK, onRunAllButtonClick, false, 0, true );
			_view.runSelectedButton.addEventListener( MouseEvent.CLICK, onRunSelectedButtonClick, false, 0, true );
			_view.tree.addEventListener( ListEvent.ITEM_CLICK, onTreeItemClick, false, 0, true );
			
			_view.errorIconContainer.addChild( Resources.statusError() );
			_view.failureIconContainer.addChild( Resources.statusFailure() );
			_view.successIconContainer.addChild( Resources.statusSuccess() );
			_view.warningIconContainer.addChild( Resources.statusWarning() );
			
			_view.progressBar.mode = ProgressBarMode.MANUAL;
		}
		
		/*
		 * Getter / setter methods
		 */
		
		public function set recipe( value:Recipe ):void {
			_recipe = value;
			
			if ( _initialized ) {
				_view.tree.recipe = _recipe ? _recipe.clone() : null;
			}
		}
		
		/*
		 * Helper methods
		 */
		
		private function runCurrentRecipe():void {
			_testInProgress = true;
			
			_result = new Result();
			_view.tree.result = _result;
			
			_view.tree.recipe = _recipe.clone();
			
			// Reset the progress bar to 0% before starting the test.
			updateProgressBar();
			
			Runner.create( _activeRecipe, [], _runNotifier, _result );
		}
		
		private function showSummaryStats( data:* ):void {
			var status:IStatus = data as IStatus;
			var testClassTreeModel:TestClassTreeModel = data as TestClassTreeModel;
			
			_view.messageTextArea.text = '';
			_view.methodLabel.text = '';
			_view.stackTraceTextArea.text = '';
			_view.testCaseLabel.text = '';
			
			if ( status ) {
				_view.methodLabel.text = status.methodModel.name;
				_view.testCaseLabel.text = getQualifiedClassName( status.methodModel.methodDefinedBy ).toString();
				
				if ( status is Failure ) {
					var failure:Failure = status as Failure;
					
					_view.messageTextArea.text = failure.errorMessage;
					_view.stackTraceTextArea.text = failure.error.getStackTrace();
				} else if ( status is Success ) {
					var success:Success = status as Success;
					
					_view.messageTextArea.text = success.numAsserts + ' asserts made';
				} else if ( status is Untested ) {
					_view.messageTextArea.text = 'Not tested';
				}
				
			} else if ( testClassTreeModel ) {
				_view.messageTextArea.text = 'Contains ' + testClassTreeModel.description.testCount + ' test methods';
				_view.methodLabel.text = 'N/A';
				_view.testCaseLabel.text = testClassTreeModel.description.introspectionUtil.classModel.name;
			}
		}
		
		private function updateProgressBar():void {
			_view.progressBar.label = 'LOADING ' + Math.round( ( _result.testsRun / _activeRecipe.testCount ) * 100 ) + '% - ' +
			                          _result.testsRun.toString() + '/' + _activeRecipe.testCount;
			
			_view.progressBar.setProgress( _result.testsRun, _activeRecipe.testCount );
			
			if ( _result.errorCount > 0 ) {
				_view.progressBar.styleName = 'progressBarError';
			} else if ( _result.failureCount > 0 ) {
				_view.progressBar.styleName = 'progressBarFailure';
			} else {
				_view.progressBar.styleName = 'progressBarSuccess';
			}
		}
		
		/*
		 * Event handlers
		 */
		
		public function onAllTestsCompleted( event:RunEvent ):void {
			_testInProgress = false;
			
			_view.tree.allTestsCompleted();
		}
		
		private function onRunAllButtonClick( event:MouseEvent ):void {
			_activeRecipe = _recipe.clone();
			
			runCurrentRecipe();
		}
		
		private function onRunSelectedButtonClick( event:MouseEvent ):void {
			_activeRecipe = _view.tree.selectedItemsRecipe;
			
			runCurrentRecipe();
		}
		
		public function onTestCompleted( event:RunEvent ):void {
			_view.tree.testCompleted( event.methodModel, event.status );
			
			_view.errorsLabel.text = _result.errorCount.toString();
			_view.failuresLabel.text = _result.failureCount.toString();
			_view.assertsLabel.text = _result.numAsserts.toString();
			_view.successesLabel.text = _result.successCount.toString();	// TODO: Check for warnings.
			_view.testProgressLabel.text = _result.testsRun.toString() + '/' + _activeRecipe.testCount;
			_view.timeLabel.text = ( Math.round( _result.testTimes / 10 ) / 100 ) + ' secs';
			
			updateProgressBar();
		}
		
		public function onTestStarting( event:RunEvent ):void {
			_view.tree.testStarting( event.methodModel );
		}
		
		private function onTreeItemClick( event:ListEvent ):void {
			showSummaryStats( event.itemRenderer.data );
		}
	}
}