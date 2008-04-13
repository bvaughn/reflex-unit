package reflexunit.framework.display.flexviewer.embedded {
	import flash.display.Bitmap;
	
	/**
	 * Thanks to the following sites for the icons!
	 * <ul>
	 *   <li>http://icojoy.com/articles/19/</li>
	 *   <li>http://www.famfamfam.com/lab/icons/</li>
	 * </ul>
	 */
	[ExcludeClass]
	public class Resources {
		
		// 16 x 16, gif
		[Embed(source="/data/graphics/status_error.gif")]
		public static var statusErrorClass:Class;
		public static function statusError():Bitmap {
			return new statusErrorClass() as Bitmap;
		}
		
		// 16 x 16, gif
		[Embed(source="/data/graphics/status_failure.gif")]
		public static var statusFailureClass:Class;
		public static function statusFailure():Bitmap {
			return new statusFailureClass() as Bitmap;
		}
		
		// 16 x 16, gif
		[Embed(source="/data/graphics/status_in_progress.gif")]
		public static var statusInProgressClass:Class;
		public static function statusInProgress():Bitmap {
			return new statusInProgressClass() as Bitmap;
		}
		
		// 16 x 16, gif
		[Embed(source="/data/graphics/status_success.gif")]
		public static var statusSuccessClass:Class;
		public static function statusSuccess():Bitmap {
			return new statusSuccessClass() as Bitmap;
		}
		
		// 16 x 16, gif
		[Embed(source="/data/graphics/status_untested.gif")]
		public static var statusUntestedClass:Class;
		public static function statusUntested():Bitmap {
			return new statusUntestedClass() as Bitmap;
		}
		
		// 16 x 16, gif
		[Embed(source="/data/graphics/status_warning.gif")]
		public static var statusWarningClass:Class;
		public static function statusWarning():Bitmap {
			return new statusWarningClass() as Bitmap;
		}
		
		// 16 x 16, gif
		[Embed(source="/data/graphics/tree_close.gif")]
		public static var treeCloseClass:Class;
		public static function treeClose():Bitmap {
			return new treeCloseClass() as Bitmap;
		}
		
		// 16 x 16, gif
		[Embed(source="/data/graphics/tree_open.gif")]
		public static var treeOpenClass:Class;
		public static function treeOpen():Bitmap {
			return new treeOpenClass() as Bitmap;
		}
	}
}