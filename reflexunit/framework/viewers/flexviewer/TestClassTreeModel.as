package reflexunit.framework.viewers.flexviewer {
	import reflexunit.framework.Description;
	
	[ExcludeClass]
	public class TestClassTreeModel {
		
		private var _description:Description;
		private var _statuses:Array;
		
		public function TestClassTreeModel( descriptionIn:Description ) {
			_description = descriptionIn;
			
			_statuses = new Array();
		}
		
		/**
		 * Convenience method for use with <code>Tree</code>.
		 */
		public function get children():Array {
			return statuses;
		}
		
		public function get description():Description {
			return _description;
		}
		
		public function get statuses():Array {
			return _statuses;
		}
	}
}