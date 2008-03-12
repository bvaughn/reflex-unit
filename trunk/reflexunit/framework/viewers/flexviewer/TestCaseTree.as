package reflexunit.framework.viewers.flexviewer {
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Tree;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	
	import reflexunit.framework.Description;
	import reflexunit.framework.Failure;
	import reflexunit.framework.IResultViewer;
	import reflexunit.framework.IStatus;
	import reflexunit.framework.InProgress;
	import reflexunit.framework.Recipe;
	import reflexunit.framework.Result;
	import reflexunit.framework.Success;
	import reflexunit.framework.Untested;
	import reflexunit.framework.viewers.flexviewer.embedded.Resources;
	import reflexunit.introspection.models.MethodModel;
	
	/**
	 * Convert to Tree structure (Array of Objects with "children" => status, all New by default)
	 * This dispatches events to the viewer, which updates the children as notified
	 */
	[ExcludeClass]
	public class TestCaseTree extends Tree implements IResultViewer {
		
		private var _recipe:Recipe;
		private var _result:Result;
		private var _testClassTreeModels:ArrayCollection;
		
		/*
		 * Initialization
		 */
		
		public function TestCaseTree() {
			addEventListener( FlexEvent.INITIALIZE, onInitialize, false, 0, true );
			addEventListener( ListEvent.ITEM_CLICK, onItemClick, false, 0, true );
			
			_testClassTreeModels = new ArrayCollection();
			
			allowMultipleSelection = true;
			iconFunction = getTreeIcon;
			labelFunction = getTreeLabel;
		}
		
		/*
		 * ITestWatcher (pass-through) methods
		 */
		
		/**
		 * @see reflexunit.framework.ITestWatcher#allTestsCompleted
		 */
		public function allTestsCompleted():void {
		}
		
		/**
		 * @see reflexunit.framework.ITestWatcher#testCompleted
		 */
		public function testCompleted( methodModel:MethodModel, status:IStatus ):void {
			updateStatus( methodModel, status );
		}
		
		/**
		 * @see reflexunit.framework.ITestWatcher#testStarting
		 */
		public function testStarting( methodModel:MethodModel ):void {
			updateStatus( methodModel, new InProgress( methodModel ) );
		}
		
		/*
		 * Getter / setter methods
		 */
		
		public function set recipe( value:Recipe ):void {
			_recipe = value
			
			initRecipe();
		}
		
		public function set result( value:Result ):void {
			_result = value
		}
		
		// TODO: This type of logic could/should be re-located to a helper class. 
		public function get selectedItemsRecipe():Recipe {
			var classToMethodMap:Object = new Object();
			var status:IStatus;
			
			for each ( var data:* in selectedItems ) {
				
				// If a test class has been selected, add all of its test methods.
				// TODO: Is this correct? Should we actually only be adding test methods if explicitly selected?
				// TODO: Should we perhaps factor in a consideration of itemOpen() vs not here?
				if ( data is TestClassTreeModel ) {
					var testClassTreeModel:TestClassTreeModel = data as TestClassTreeModel;
					var methodNames:Array = new Array();
					
					for each ( status in testClassTreeModel.statuses ) {
						methodNames.push( status.methodModel.name );
					}
					
					classToMethodMap[ testClassTreeModel.description.introspectionUtil.classModel.name ] = methodNames;
					
				} else if ( data is IStatus ) {
					status = data as IStatus;
					
					var className:String = getQualifiedClassName( status.methodModel.methodDefinedBy );
					
					if ( ! classToMethodMap[ className ] ) {
						classToMethodMap[ className ] = new Array();
					}
					
					( classToMethodMap[ className ] as Array ).push( status.methodModel.name );
				}
			}
			
			var descriptions:Array = new Array();
			
			for ( className in classToMethodMap ) {
				var klass:Class = getDefinitionByName( className ) as Class;
				 
				descriptions.push(
					new Description( new klass(),
					                 classToMethodMap[ className ] as Array ) );  
			}
			
			return Recipe.createFromDescriptions( descriptions );
		}
		
		/*
		 * Helper methods
		 */
		
		private function getTreeIcon( data:* ):Class {
			if ( data is Untested ) {
				return Resources.iconNewClass;
			} else if ( data is InProgress ) {
				return Resources.iconOpenClass;
			} else if ( data is Failure ) {
				return Resources.iconErrorClass;
			} else if ( data is Success ) {
				
				// Show a warning icon for a test that made no Asserts; (this probably is not intentional).
				if ( ( data as Success ).numAsserts == 0 ) {
					return Resources.iconWarningClass;					
				} else {
					return Resources.iconSuccessClass;
				}
				
			} else if ( data is TestClassTreeModel ) {
				var testClassTreeModel:TestClassTreeModel = data as TestClassTreeModel;
				var iconClass:Class;
				
				// If test methods have been run, then the test icon should show Success, Failure, or warning.
				for each ( var status:IStatus in testClassTreeModel.statuses ) {
					if ( status is Failure ) {
						iconClass = Resources.iconErrorClass;
						break;									// Failure/errors override all other statuses.
					} else if ( status is Success && ( status as Success ).numAsserts == 0 ) {
						iconClass = Resources.iconWarningClass;	// Warnings override successes but not errors.
					} else if ( !( status is Untested ) && iconClass != Resources.iconWarningClass ) {
						iconClass = Resources.iconSuccessClass;	// Only succeed if all other tests methods succeed.
					}
				}
				
				// If no test methods have been run, use the default tree icon.
				if ( iconClass ) {
					return iconClass;
				} else {
					return isItemOpen( data ) ? Resources.iconCloseClass : Resources.iconOpenClass; 
				}
				
			} else {
				return null;
			}
		}
		
		private function getTreeLabel( data:* ):String {
			if ( data is IStatus ) {
				return ( data as IStatus ).methodModel.name;
			} else if ( data is TestClassTreeModel ) {
				return ( data as TestClassTreeModel ).description.introspectionUtil.classModel.name;
			} else {
				return null; 
			}
		}
		
		private function initRecipe():void {
			_testClassTreeModels = new ArrayCollection();
			
			if ( _recipe ) {
				for each ( var description:Description in _recipe.descriptions ) {
					var testClassTreeModel:TestClassTreeModel = new TestClassTreeModel( description );
					
					for each ( var methodModel:MethodModel in description.methodModels ) {
						var untested:Untested = new Untested( methodModel );
						
						testClassTreeModel.statuses.push( untested );
					}
					
					_testClassTreeModels.addItem( testClassTreeModel )
				}
			}
			
			dataProvider = _testClassTreeModels;
		}
		
		private function updateStatus( methodModel:MethodModel, replacementStatus:IStatus ):void {
			var replacementMade:Boolean;
			
			for each ( var testClassTreeModel:TestClassTreeModel in _testClassTreeModels.source ) {
				for ( var index:int = 0; index < testClassTreeModel.statuses.length; index++ ) {
					var status:IStatus = testClassTreeModel.statuses[ index ] as IStatus;
					
					if ( getQualifiedClassName( status.test ) == getQualifiedClassName( replacementStatus.test ) && 
					     status.methodModel.name == methodModel.name ) {
						
						testClassTreeModel.statuses[ index ] = replacementStatus;
						
						replacementMade = true;
						
						break;
					}
				}
				
				if ( replacementMade ) {
					break;
				}
			}
			
			// Refresh only the currently-visible items; don't re-set the "dataProvider" or it will collapse the Tree.
			openItems = openItems;
		}
		
		/*
		 * Event handlers
		 */
		
		private function onInitialize( event:FlexEvent ):void {
		}
		
		private function onItemClick( event:ListEvent ):void {
			// TODO: Open non-open items if ( openItems.itemRenderer.data is TestClassTreeModel ).
		}
	}
}