# Part 2: Creating the Basic Stub Classes #

In order for a component to monitor the status of a Reflex Unit testing suite it must:
  * Implement [IResultViewer](http://reflex-unit.googlecode.com/svn/trunk/ReflexUnitSource/docs/reflexunit/framework/display/IResultViewer.html), or...
  * Listen to a [RunNotifier](http://reflex-unit.googlecode.com/svn/trunk/ReflexUnitSource/docs/reflexunit/framework/RunNotifier.html) for [RunEvents](http://reflex-unit.googlecode.com/svn/trunk/ReflexUnitSource/docs/reflexunit/framework/events/RunEvent.html)

Either option would work, but for our example application we will do the latter. Let's begin by creating a few stub classes. First, create a new MXML component named `CustomResultViewer` and a new ActionScript class named `CustomResultViewerController`. For now they should consist of the following:

## CustomResultViewer.mxml ##

```
<?xml version="1.0" encoding="utf-8"?>
<mx:Grid width="100%" height="100%"
         initialize="onInitialize()"
         xmlns:mx="http://www.adobe.com/2006/mxml" xmlns:local="*">
	
	<mx:Script>
		<![CDATA[
			private var _controller:CustomResultViewerController;
			
			private function onInitialize():void {
				controller.initialize();
			}
			
			public function get controller():CustomResultViewerController {
				if ( _controller == null ) {
					_controller = new CustomResultViewerController( this );
				}
				
				return _controller;
			}
		]]>
	</mx:Script>
	
	<mx:GridRow width="100%" height="50%">
		<mx:GridItem width="50%" height="100%">
			<!-- This will contain a graph soon. -->
		</mx:GridItem>
		
		<mx:GridItem width="50%" height="100%">
			<!-- This will contain a graph soon. -->
		</mx:GridItem>
		
	</mx:GridRow>
	
	<mx:GridRow width="100%" height="50%">
		<mx:GridItem width="50%" height="100%">
			<!-- This will contain a graph soon. -->
		</mx:GridItem>
		<mx:GridItem width="50%" height="100%">
			<!-- This will contain a graph soon. -->
		</mx:GridItem>
	</mx:GridRow>
	
</mx:Grid>
```

## CustomResultViewerController.as ##

```
package {
	import reflexunit.framework.RunNotifier;
	import reflexunit.framework.Runner;
	import reflexunit.framework.display.ConsoleViewer;
	import reflexunit.framework.events.RunEvent;
	import reflexunit.framework.models.Recipe;
	import reflexunit.framework.models.Result;
	
	public class CustomResultViewerController {
		
		private var _initialized:Boolean;
		private var _recipe:Recipe;
		private var _result:Result;
		private var _runNotifier:RunNotifier;
		private var _view:CustomResultViewer;
		
		/*
		 * Initialization
		 */
		
		public function CustomResultViewerController( view:CustomResultViewer ) {
			_view = view;
			
			_runNotifier = new RunNotifier();
			_runNotifier.addEventListener( RunEvent.ALL_TESTS_COMPLETED, onAllTestsCompleted, false, 0, true );
			_runNotifier.addEventListener( RunEvent.TEST_COMPLETED, onTestCompleted, false, 0, true );
			_runNotifier.addEventListener( RunEvent.TEST_STARTING, onTestStarting, false, 0, true );
		}
		
		public function initialize():void {
			_initialized = true;
			
			runRecipeWhenReady();
		}
		
		/*
		 * Getter / setter methods
		 */
		
		public function set recipe( value:Recipe ):void {
			_recipe = value;
			
			runRecipeWhenReady();
		}
		
		/*
		 * Helper methods
		 */
		
		private function runRecipeWhenReady():void {
			if ( !_initialized || !_recipe ) {
				return;
			}
			
			_result = new Result();
			
			// For now let's use the built-in ConsoleViewer app to debug our tests with.
			Runner.create( _recipe.clone(), [ new ConsoleViewer() ], _runNotifier, _result );
		}
		
		/*
		 * Event handlers
		 */
		
		public function onAllTestsCompleted( event:RunEvent ):void {
			// Code will go here soon.
		}
		
		public function onTestCompleted( event:RunEvent ):void {
			// Code will go here soon.
		}
		
		public function onTestStarting( event:RunEvent ):void {
			// Code will go here soon.
		}
	}
}
```

The above two components are stubs that we'll be filling in shortly. The first (`CustomResultViewer`) will hold MX charting components and the second (`CustomResultViewerController`) will monitor test progress and pass the appropriate bits of information on to our charts.

_You may have noticed our use of the [ConsoleViewer](http://reflex-unit.googlecode.com/svn/trunk/ReflexUnitSource/docs/reflexunit/framework/display/ConsoleViewer.html) component. This component simply prints plain-text information to the Eclipse console as each test method finishes its execution. Using this "viewer" offers us a quick and easy way of trouble-shooting our tests until they are completed._

As a final setup step let's add the following code to our project's main Flex Application component. (By default this file is named `main.mxml`.)

## Main.mxml ##

```
<?xml version="1.0" encoding="utf-8"?>
<mx:Application width="100%" height="100%" layout="absolute"
                backgroundColor="0xFFFFFF" backgroundGradientColors="[ 0xFFFFFF, 0xFFFFFF ]"
                initialize="onInitialize( event )"
                xmlns:local="*"
                xmlns:mx="http://www.adobe.com/2006/mxml">
	
	<mx:Script>
		<![CDATA[
			import mx.events.FlexEvent;
			
			private function onInitialize( event:FlexEvent ):void {
				// Our test suite will be defined here.
			}
		]]>
	</mx:Script>
	
	<local:CustomResultViewer id="viewer" width="100%" height="100%" />
	
</mx:Application>
```

That's all the setup we need to do. Next let's take a look at writing an example test.

## [Continue to Part 3..](WritingYourOwnCustomViewer3.md) ##