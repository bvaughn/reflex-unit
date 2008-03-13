package {
	import reflexunit.framework.ITestWatcher;
	import reflexunit.framework.RunNotifier;
	import reflexunit.framework.Runner;
	import reflexunit.framework.TestCase;
	import reflexunit.framework.TestSuite;
	import reflexunit.framework.models.Recipe;
	import reflexunit.framework.models.Result;
	import reflexunit.framework.statuses.IStatus;
	import reflexunit.introspection.models.MethodModel;
	
	public class ErrorTest extends TestCase implements ITestWatcher {
		
		private var _recipe:Recipe;
		private var _result:Result;
		private var _runNotifier:RunNotifier;
		
		public function testMe():void {
			_recipe = new Recipe( new TestSuite( [ InnerErrorTest ] ) );
			
			_result = new Result();
			
			_runNotifier = new RunNotifier( [ this ] );
			
			Runner.create( _recipe, [], _runNotifier, _result );
		}
		
		/*
		 * Event handlers
		 */
		
		public function allTestsCompleted():void {
		}
		
		public function testCompleted( methodModel:MethodModel, status:IStatus ):void {
		}
		
		public function testStarting( methodModel:MethodModel ):void {
			fail( 'Outer test failure' );
		}
	}
}