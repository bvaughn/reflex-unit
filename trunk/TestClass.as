package {
	
	[TestCase]
	public dynamic class TestClass {
		public function TestClass() {
		}
		
		public function bob():void {
		}
		
		[Test]
		public function sue():void {
		}
		
		[Test(shouldFail=true)]
		public function mary():void {
		}
		
		public function get attA():Boolean {
			return null;
		}
		
		public function get attB():Boolean {
			return null;
		}
		
		[Bindable]
		public function get attC():Boolean {
			return null;
		}
		public function set attC( value:Boolean ):void {
		}
		
		public function set attD( value:Boolean ):void {
		}
	}
}