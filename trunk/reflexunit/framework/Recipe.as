package reflexunit.framework {
	
	/**
	 * Contains a set of all available/runnable test classes and methods.
	 * Each runnable method is defined by a <code>Description</code> object.
	 * 
	 * 
	 * @see reflexunit.framework.Description
	 */
	public class Recipe {
		
		private var _descriptions:Array;
		
		/*
		 * Initialization
		 */
		
		/**
		 * Constructor.
		 * 
		 * @testSuite TestSuite from which all runnable test information is retrieved
		 */
		public function Recipe( testSuite:TestSuite ) {
			_descriptions = new Array();
			
			initDescriptions( testSuite );
		}
		
		/*
		 * Getter / setter methods
		 */
		
		/**
		 * Array of <code>Description</code> models.
		 * 
		 * @see reflexunit.framework.Description
		 */
		public function get descriptions():Array {
			return _descriptions;
		}
		
		/*
		 * Helper methods
		 */
		
		/**
		 * Recursively explores a <code>TestSuite</code> and creates a <code>Description</code> object for each test found.
		 */
		private function initDescriptions( testSuite:TestSuite ):void {
			for each ( var test:* in testSuite.tests ) {
				_descriptions.push( new Description( test ) );
			}
		}
	}
}