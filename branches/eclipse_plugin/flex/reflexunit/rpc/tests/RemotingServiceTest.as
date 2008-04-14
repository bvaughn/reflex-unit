package reflexunit.rpc.tests {
	import reflexunit.framework.TestCase;
	import reflexunit.rpc.RemotingService;
	import reflexunit.rpc.tests.mocks.Skeletor;
	import reflexunit.rpc.tests.mocks.Stubby;
	import reflexunit.rpc.tests.mocks.TestOutgoingMessage;
	
	public class RemotingServiceTest extends TestCase {
		
		private var _remotingService:RemotingService;
		private var _stubby:Stubby;
		
		public function RemotingServiceTest() {
			_stubby = new Stubby();
			_remotingService = new RemotingService( _stubby, new Skeletor() );
		}
		
		public function testStubReceivesCorrectOutgoingMessage():void {
			_remotingService.send( new TestOutgoingMessage( 'TEST_RECEIVER_ID', 'TEST_MESSAGE_NAME', <greeting>Hello World!</greeting> ) );
			
			assertEquals( 'TEST_RECEIVER_ID', _stubby.xml.@receiverID );
			assertEquals( 'TEST_MESSAGE_NAME', _stubby.xml.@name );
			assertEquals( _stubby.xml.data.greeting.length(), 1 );
			assertEquals( 'Hello World!', _stubby.xml.data.greeting.toString() );
		}
	}
}