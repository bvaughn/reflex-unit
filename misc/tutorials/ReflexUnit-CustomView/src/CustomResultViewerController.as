package {
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;
	
	import reflexunit.framework.RunNotifier;
	import reflexunit.framework.Runner;
	import reflexunit.framework.display.ConsoleViewer;
	import reflexunit.framework.events.RunEvent;
	import reflexunit.framework.models.Description;
	import reflexunit.framework.models.Recipe;
	import reflexunit.framework.models.Result;
	
	/**
	 * Manages the visual state of the <code>FlexViewer</code> viewer.
	 * 
	 * @see reflexunit.framework.display.flexviewer.FlexViewer
	 */
	public class CustomResultViewerController {
		
		private var _initialized:Boolean;
		private var _recipe:Recipe;
		private var _result:Result;
		private var _runNotifier:RunNotifier;
		private var _timer:Timer;
		private var _view:CustomResultViewer;
		
		/*
		 * Initialization
		 */
		
		public function CustomResultViewerController( view:CustomResultViewer ) {
			_view = view;
			
			_runNotifier = new RunNotifier();
			_runNotifier.addEventListener( RunEvent.ALL_TESTS_COMPLETED, onAllTestsCompleted, false, 0, true );
			_runNotifier.addEventListener( RunEvent.TEST_COMPLETED, onTestCompleted, false, 0, true );
			_runNotifier.addEventListener( RunEvent.TEST_STARTING, onTestStarting, false, 0, true );
			
			_timer = new Timer( 500 );
			_timer.addEventListener( TimerEvent.TIMER, onTimer, false, 0, true );
		}
		
		public function initialize():void {
			_initialized = true;
			
			runRecipeWhenReady();
		}
		
		/*
		 * Getter / setter methods
		 */
		
		public function set recipe( value:Recipe ):void {
			_recipe = value;
			
			runRecipeWhenReady();
		}
		
		/*
		 * Helper methods
		 */
		
		private function runRecipeWhenReady():void {
			if ( !_initialized || !_recipe ) {
				return;
			}
			
			_result = new Result();
			
			_view.individualTestStatuses.dataProvider.removeAll();
			
			for each ( var description:Description in _recipe.descriptions ) {
				_view.individualTestStatuses.dataProvider.addItem(
					new ChartData( description.introspectionUtil.classModel ) );		
			}
			
			// These display names must match IStatus "status" fields. 
			_view.overallTestStatuses.dataProvider.removeAll();
			_view.overallTestStatuses.dataProvider.addItem( new OverallTestStatusesData( 'error' ) );
			_view.overallTestStatuses.dataProvider.addItem( new OverallTestStatusesData( 'failure' ) );
			_view.overallTestStatuses.dataProvider.addItem( new OverallTestStatusesData( 'success' ) );
			
			_view.testsAndAssertionsOverTime.dataProvider.removeAll();
			
			// TODO: Should the Recipe be cloned?
			Runner.create( _recipe.clone(), [ new ConsoleViewer() ], _runNotifier, _result );
			
			_timer.start();
		}
		
		/*
		 * Event handlers
		 */
		
		public function onAllTestsCompleted( event:RunEvent ):void {
			_timer.stop();
		}
		
		public function onTestCompleted( event:RunEvent ):void {
			for each ( var chartData:ChartData in _view.individualTestStatuses.dataProvider.source ) {
				if ( chartData.testCaseName == getQualifiedClassName( event.methodModel.thisObject ) ) {
					chartData.addStatus( event.status );
				}
			}
			
			for each ( var pieChartData:OverallTestStatusesData in _view.overallTestStatuses.dataProvider.source ) {
				if ( pieChartData.statusName == event.status.status ) {
					pieChartData.count++;
				}
			}
			
			_view.individualTestStatuses.dataProvider.refresh();
			_view.overallTestStatuses.dataProvider.refresh();
		}
		
		public function onTestStarting( event:RunEvent ):void {
		}
		
		private function onTimer( event:TimerEvent ):void {
			var timeInSeconds:Number = ( _timer.currentCount * _timer.delay ) / 1000;
			
			_view.testsAndAssertionsOverTime.dataProvider.addItem(
				new TestsAndAssertionsOverTimeData( timeInSeconds, _result.testsRun, _result.numAsserts ) );
			
			_view.testsAndAssertionsOverTime.dataProvider.refresh();
		}
	}
}