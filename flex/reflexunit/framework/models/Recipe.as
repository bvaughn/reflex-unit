package reflexunit.framework.models {
	import reflexunit.framework.TestSuite;
	
	/**
	 * Contains a set of all available/runnable test classes and methods.
	 * Each runnable method is defined by a <code>Description</code> object.
	 * 
	 * <p>A <code>Recipe</code> and its contained <code>Description</code> objects may only be run (ie. tested) once.
	 * Because of this, a <code>Recipe</code> should in most cases be cloned before being passed to a <code>Runner</code>.</p>
	 * 
	 * @see reflexunit.framework.models.Description
	 */
	public class Recipe {
		
		private var _descriptions:Array;
		private var _testCount:int;
		
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
			_testCount = 0;
			
			initDescriptions( testSuite );
		}
		
		/**
		 * Creates and returns a duplicate copy of the current <code>Recipe</code>.
		 */
		public function clone():Recipe {
			var descriptionClones:Array = new Array;
			
			for each ( var description:Description in _descriptions ) {
				descriptionClones.push( description.clone() );
			}
			
			return createFromDescriptions( descriptionClones );
		}
		
		/**
		 * Convenience method for constructing a <code>Recipe</code> of custom, manually-specified <code>Description</code> objects.
		 * 
		 * @param descriptionsIn Array containing Description arguments
		 */
		public static function createFromDescriptions( descriptionsIn:Array ):Recipe {
			var recipe:Recipe = new Recipe( new TestSuite() );
			
			if ( descriptionsIn ) {
				for each ( var description:Description in descriptionsIn ) {
					recipe.descriptions.push( description );
					recipe.testCount += description.testCount;
				}
			}
			
			return recipe;
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
		
		/**
		 * Number of testable methods contained within the current <code>Recipe</code>.
		 */
		public function get testCount():int {
			return _testCount;
		}
		public function set testCount( value:int ):void {
			_testCount = value;
		}
		
		/*
		 * Helper methods
		 */
		
		/**
		 * Recursively explores a <code>TestSuite</code> and creates a <code>Description</code> object for each test found.
		 */
		private function initDescriptions( testSuite:TestSuite ):void {
			for each ( var test:* in testSuite.tests ) {
				var description:Description = new Description( test );
				
				_descriptions.push( description );
				
				_testCount += description.testCount;
			}
			
			_descriptions.sortOn( 'testName' );
		}
	}
}