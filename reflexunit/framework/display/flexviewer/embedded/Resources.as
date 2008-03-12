package reflexunit.framework.display.flexviewer.embedded {
	import flash.display.Bitmap;
	
	/**
	 * Thanks for the icons:
	 * http://icojoy.com/articles/19/
	 */
	[ExcludeClass]
	public class Resources {
		
		// 16 x 16, gif
		[Embed(source="/data/graphics/icon_close.gif")]
		public static var iconCloseClass:Class;
		public static function iconClose():Bitmap {
			return new iconCloseClass() as Bitmap;
		}
		
		// 16 x 16, gif
		[Embed(source="/data/graphics/icon_error.gif")]
		public static var iconErrorClass:Class;
		public static function iconError():Bitmap {
			return new iconErrorClass() as Bitmap;
		}
		
		// 16 x 16, gif
		[Embed(source="/data/graphics/icon_in_progress.gif")]
		public static var iconInProgressClass:Class;
		public static function iconInProgress():Bitmap {
			return new iconInProgressClass() as Bitmap;
		}
		
		// 16 x 16, gif
		[Embed(source="/data/graphics/icon_info.gif")]
		public static var iconInfoClass:Class;
		public static function iconInfo():Bitmap {
			return new iconInfoClass() as Bitmap;
		}
		
		// 16 x 16, gif
		[Embed(source="/data/graphics/icon_new.gif")]
		public static var iconNewClass:Class;
		public static function iconNew():Bitmap {
			return new iconNewClass() as Bitmap;
		}
		
		// 16 x 16, gif
		[Embed(source="/data/graphics/icon_open.gif")]
		public static var iconOpenClass:Class;
		public static function iconOpen():Bitmap {
			return new iconOpenClass() as Bitmap;
		}
		
		// 16 x 16, gif
		[Embed(source="/data/graphics/icon_success.gif")]
		public static var iconSuccessClass:Class;
		public static function iconSuccess():Bitmap {
			return new iconSuccessClass() as Bitmap;
		}
		
		// 16 x 15, gif
		[Embed(source="/data/graphics/icon_warning.gif")]
		public static var iconWarningClass:Class;
		public static function iconWarning():Bitmap {
			return new iconWarningClass() as Bitmap;
		}
	}
}