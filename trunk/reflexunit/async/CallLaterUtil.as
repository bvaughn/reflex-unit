package reflexunit.async {
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import mx.core.Application;
	
	/**
	 * Contains helper methods for non-<code>UIComponent</code> classes to asynchronously delay code execution.
	 * This class allows for delayed execution of instance methods as well as delayed assignments to accessors.
	 * 
	 * <p>Methods may be <code>public</code>, <code>private</code>, <code>protected</code> or declared inline.
	 * Accessors must be <code>public</code>.</p>
	 * 
	 * <p>The most basic usage example of this class is as follows:</p>
	 * 
	 * <code>
	 * CallLaterUtil.functionFrameDelay( this, function():void {
	 *   tace( 'Method executed!' );
	 * } );
	 * </code>
	 */
	public class CallLaterUtil {
		
		private static var _callLaterModels:Array = new Array();
		
		/*
		 * Public methods
		 */
		
		/**
		 * Delays assignment to the specified accessor by a fixed number of frames.
		 * (A single <code>Event.ENTER_FRAME</code> event defines a frame.)
		 * 
		 * @param thisObject Object defining the specified public instance accessor
		 * @param accessorName Name of accessor to assign value to
		 * @param value Value to assign to specified accessor
		 * @param frames Number of frames to delay before performing assignment
		 */
		public static function accessorFrameDelay( thisObject:Object, accessorName:String, value:Object, frames:int = 3 ):void {
			var callLaterModel:CallLaterModel = initCallLaterModelForAccessor( thisObject, accessorName, value );
			addFrameDelayInformationToCallLaterModel( callLaterModel, frames );
			
			_callLaterModels.unshift( callLaterModel );	// See onEnterFrame() for why we use unshift() instead of push().
			
			lazySetupEnterFrameListener();
		}
		
		/**
		 * Delays assignment to the specified accessor by a fixed number of milliseconds.
		 * (The shortest delay supported will be the time ellapsed between <code>Event.ENTER_FRAME</code> events.)
		 * 
		 * @param thisObject Object defining the specified public instance accessor
		 * @param accessorName Name of accessor to assign value to
		 * @param value Value to assign to specified accessor
		 * @param frames Number of milliseconds to delay before performing assignment
		 */
		public static function accessorTimeDelay( thisObject:Object, accessorName:String, value:Object, milliseconds:int = 1000 ):void {
			var callLaterModel:CallLaterModel = initCallLaterModelForAccessor( thisObject, accessorName, value );
			addTimeDelayInformationToCallLaterModel( callLaterModel, milliseconds );
			
			_callLaterModels.unshift( callLaterModel );	// See onEnterFrame() for why we use unshift() instead of push().
			
			lazySetupEnterFrameListener();
		}
		
		/**
		 * Delays execution of the specified instance method by a fixed number of frames.
		 * (A single <code>Event.ENTER_FRAME</code> event defines a frame.)
		 * 
		 * @param thisObject Object defining the specified public instance accessor
		 * @param method Method to execute after delay; defined by the associated object
		 * @param methodArgs (Optional) array of arguments to pass to supplied methods
		 * @param frames Number of frames to delay before performing assignment
		 */
		public static function functionFrameDelay( thisObject:Object, method:Function, methodArgs:Array = null, frames:int = 3 ):void {
			var callLaterModel:CallLaterModel = initCallLaterModelForFunction( thisObject, method, methodArgs );
			addFrameDelayInformationToCallLaterModel( callLaterModel, frames );
			
			_callLaterModels.unshift( callLaterModel );	// See onEnterFrame() for why we use unshift() instead of push().
			
			lazySetupEnterFrameListener();
		}
		
		/**
		 * Delays execution of the specified instance method by a fixed number of milliseconds.
		 * (The shortest delay supported will be the time ellapsed between <code>Event.ENTER_FRAME</code> events.)
		 * 
		 * @param thisObject Object defining the specified public instance accessor
		 * @param method Method to execute after delay; defined by the associated object
		 * @param methodArgs (Optional) array of arguments to pass to supplied methods
		 * @param frames Number of milliseconds to delay before performing assignment
		 */
		public static function functionTimeDelay( thisObject:Object, method:Function, methodArgs:Array = null, milliseconds:int = 1000 ):void {
			var callLaterModel:CallLaterModel = initCallLaterModelForFunction( thisObject, method, methodArgs );
			addTimeDelayInformationToCallLaterModel( callLaterModel, milliseconds );
			
			_callLaterModels.unshift( callLaterModel );	// See onEnterFrame() for why we use unshift() instead of push().
			
			lazySetupEnterFrameListener();
		}
		
		/*
		 * Helper methods
		 */
		
		private static function addFrameDelayInformationToCallLaterModel( callLaterModel:CallLaterModel, frames:int ):void {
			callLaterModel.frameDelayRemaining = frames;
		}
		
		private static function addTimeDelayInformationToCallLaterModel( callLaterModel:CallLaterModel, milliseconds:int ):void {
			callLaterModel.millisecondsAtCompletion = getTimer() + milliseconds;
		}
		
		private static function executeCallLaterModel( callLaterModel:CallLaterModel ):void {
			if ( callLaterModel.method != null ) {
				callLaterModel.method.apply( callLaterModel.thisObject, callLaterModel.methodArgs );
			} else if ( callLaterModel.thisObject.hasOwnProperty( callLaterModel.accessorName ) ) {
				callLaterModel.thisObject[ callLaterModel.accessorName ] = callLaterModel.accessorValue;
			}
			
			_callLaterModels.splice( _callLaterModels.indexOf( callLaterModel ), 1 );
		}
		
		private static function initCallLaterModelForAccessor( thisObject:*, accessorName:String, value:* ):CallLaterModel {
			var callLaterModel:CallLaterModel = new CallLaterModel();
			callLaterModel.accessorName = accessorName;
			callLaterModel.accessorValue = value;
			callLaterModel.thisObject = thisObject;
			
			return callLaterModel;
		}
		
		private static function initCallLaterModelForFunction( thisObject:*, method:Function, methodArgs:Array ):CallLaterModel {
			var callLaterModel:CallLaterModel = new CallLaterModel();
			callLaterModel.method = method;
			callLaterModel.methodArgs = methodArgs;
			callLaterModel.thisObject = thisObject;
			
			return callLaterModel;
		}
		
		private static function lazyDestroyEnterFrameListener():void {
			if ( _callLaterModels.length == 0 ) {
				mx.core.Application.application.removeEventListener( Event.ENTER_FRAME, onEnterFrame );
			}
		}
		
		private static function lazySetupEnterFrameListener():void {
			mx.core.Application.application.addEventListener( Event.ENTER_FRAME, onEnterFrame );
		}
		
		/*
		 * Event listeners.
		 */
		
		/**
		 * Responsible for executing any delayed methods or accessors that are due as of this current <code>Event.ENTER_FRAME</code> event.
		 */
		private static function onEnterFrame( event:Event ):void {
			if ( _callLaterModels.length > 0 ) {
				
				// Step backwards through Array so items can be safely spliced out.
				for ( var index:int = _callLaterModels.length - 1; index >= 0; index-- ) {
					var callLaterModel:CallLaterModel = _callLaterModels[ index ] as CallLaterModel;
					
					if ( callLaterModel.millisecondsAtCompletion > 0 ) {
						if ( callLaterModel.millisecondsAtCompletion <= getTimer() ) {
							executeCallLaterModel( callLaterModel );
						}
					} else if ( --callLaterModel.frameDelayRemaining <= 0 ) {
						executeCallLaterModel( callLaterModel );
					}
				}
			}
			
			lazyDestroyEnterFrameListener();
		}
	}
}