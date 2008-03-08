package reflexunit.framework.tests.metadata {
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import reflexunit.framework.TestCase;
	
	public class MetaDataTestSample {
		
		[Test]
		public function shouldBeTest():void {
		}
		
		[Test(shouldFail="true")]
		public function shouldFailTrue():void {
		}
		
		[Test(shouldFail="false")]
		public function shouldFailFalse():void {
		}
		
		[Test(forceSerialExecution="true")]
		public function forceSerialExecutionTrue():void {
			var timer:Timer = new Timer( 10, 1 );
			timer.addEventListener( TimerEvent.TIMER_COMPLETE,
			                        TestCase.addAsync( function():void {}, 1000 ) );
			timer.start();
		}
		
		[Test(forceSerialExecution="true")]
		public function forceSerialExecutionFalseIfNoAsync():void {
		}
		
		[Test(forceSerialExecution="false")]
		public function forceSerialExecutionFalse():void {
		}
	}
}