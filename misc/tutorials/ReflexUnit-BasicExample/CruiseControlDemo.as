package {
	import flash.display.Sprite;
	
	import reflexunit.framework.Runner;
	import reflexunit.framework.TestSuite;
	import reflexunit.framework.display.CruiseControlLogger;
	
	public class CruiseControlDemo extends Sprite {
		public function CruiseControlDemo() {
			Runner.create( new TestSuite( [ TimerTest ] ), [ new CruiseControlLogger() ] );
		}
	}
}