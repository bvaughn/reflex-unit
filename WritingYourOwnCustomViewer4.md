# Part 4: Creating Individual Result Views #

We're going to move quickly through this next part. Although it contains the most source code, much of this code deals with Flex charting components and other areas that lie outside of the scope of this tutorial. For more information in these areas I recommend Google-searching one of the available "Flex Charting Explorer" applications.

As previously stated, a primary purpose of this tutorial is to illustrate a variety of ways in which Reflex Unit test result data may be displayed to a user/developer. The custom "viewer" we will create will be comprised of several smaller views or charts. Each of these charts will illustrate a different way of interpreting/displaying the outcome of tests.

## Overall / Summary Test Information ##

After running a suite of tests, your first thought may be "did they all pass?". For this purposes we'll be using a [PieChart](http://livedocs.adobe.com/flex/3/langref/mx/charts/PieChart.html) to display the overall percentages of errors, failures, and successes.

To do this we will create 2 components: `OverallTestStatuses.mxml` and `OverallTestStatusesData.as`. You can think of these components as our view and model. (We will introduce the "controller" in the next section of this article.)

### OverallTestStatuses.mxml ###

```
<?xml version="1.0" encoding="utf-8"?>
<mx:HBox width="100%" height="100%" horizontalGap="20"
         horizontalAlign="center" verticalAlign="middle"
         xmlns:mx="http://www.adobe.com/2006/mxml">
	
	<mx:Script>
		<![CDATA[
			import mx.collections.ArrayCollection;
			import mx.graphics.SolidColor;
			
			[Bindable]	// Contains: OverallTestStatusesData
			public var dataProvider:ArrayCollection = new ArrayCollection();
		]]>
	</mx:Script>
	
	<mx:PieChart id="pieChart" width="100%" height="100%" maxWidth="475" maxHeight="300"
	             showAllDataTips="true"
	             dataProvider="{ dataProvider }">
		
		<mx:series>
			<mx:PieSeries nameField="statusName" field="count"
			              fills="{ [ new SolidColor( 0x990000 ), new SolidColor( 0xAAAA00 ), new SolidColor( 0x009900 ) ] }">
				
				<!-- Clear the ugly drop-shadow and bevel effects. -->
				<mx:filters>
					<mx:Array />
				</mx:filters>
				
			</mx:PieSeries>
		</mx:series>
		
	</mx:PieChart>
	
	<mx:VBox horizontalAlign="center" verticalGap="0">
		<mx:Text styleName="header" text="Overall" />
		<mx:Text styleName="header" text="Test" />
		<mx:Text styleName="header" text="Statuses" />
		
		<mx:Spacer height="25" />
		
		<mx:Legend dataProvider="{ pieChart }"/>
	</mx:VBox>
	
</mx:HBox>
```

### OverallTestStatusesData.as ###

```
package {
	import reflexunit.framework.statuses.IStatus;
	
	public class OverallTestStatusesData {
		
		public var count:int;
		public var statusName:String;
		
		public function OverallTestStatusesData( statusNameIn:String ) {
			statusName = statusNameIn;
			count = 0;
		}
	}
}
```

## Individual Test Statuses ##

If one or more tests fail, you'll need a way to separate the failures. For this purpose we'll introduce our second chart, a [ColumnChart](http://livedocs.adobe.com/flex/3/langref/mx/charts/ColumnChart.html) showing the outcomes of each individual test class. Like our previous chart, this too will consist of an MXML component (the view) and an ActionScript class (the model):

### IndividualTestStatuses.mxml ###

```
<?xml version="1.0" encoding="utf-8"?>
<mx:HBox width="100%" height="100%" horizontalGap="20"
         horizontalAlign="center" verticalAlign="middle"
         xmlns:mx="http://www.adobe.com/2006/mxml">
	
	<mx:Script>
		<![CDATA[
			import mx.collections.ArrayCollection;
			import mx.graphics.SolidColor;
			
			[Bindable]	// Contains: IndividualTestStatusesData
			public var dataProvider:ArrayCollection = new ArrayCollection();
			
			private function getHorizontalAxis( categoryValue:Object, previousCategoryValue:Object, axis:CategoryAxis, categoryItem:Object ):String {
				var array:Array = categoryValue.toString().match( /\:(\w+)$/ );
				
				return array ? array[1] : categoryValue.toString();
			}
		]]>
	</mx:Script>
	
	<mx:ColumnChart id="columnChart" height="100%" width="100%" maxWidth="475" maxHeight="300"
	                showDataTips="true"
	                dataProvider="{ dataProvider }">
		
		<mx:horizontalAxis>
			<mx:CategoryAxis dataProvider="{ dataProvider }" categoryField="testCaseName"
			                 labelFunction="{ getHorizontalAxis }" />
		</mx:horizontalAxis>
		
		<mx:series>
			<mx:ColumnSeries xField="testCaseName" yField="successCount" displayName="Successes"
			                 fill="{ new SolidColor( 0x009900 ) }" />
			<mx:ColumnSeries xField="testCaseName" yField="failureCount" displayName="Failures"
			                 fill="{ new SolidColor( 0xAAAA00 ) }" />
			<mx:ColumnSeries xField="testCaseName" yField="errorCount" displayName="Errors"
			                 fill="{ new SolidColor( 0x990000 ) }" />
		</mx:series>
	</mx:ColumnChart>
	
	<mx:VBox horizontalAlign="center" verticalGap="0">
		<mx:Text styleName="header" text="Individual" />
		<mx:Text styleName="header" text="Test" />
		<mx:Text styleName="header" text="Statuses" />
		
		<mx:Spacer height="25" />
		
		<mx:Legend dataProvider="{ columnChart }"/>
	</mx:VBox>
	
</mx:HBox>
```

### IndividualTestStatusesData.as ###

```
package {
	import reflexunit.framework.statuses.Failure;
	import reflexunit.framework.statuses.IStatus;
	import reflexunit.framework.statuses.Success;
	import reflexunit.introspection.models.ClassModel;
	
	public class IndividualTestStatusesData {
		
		public var classModel:ClassModel;
		public var errorCount:int;
		public var failureCount:int;
		public var successCount:int;
		
		public function IndividualTestStatusesData( classModelIn:ClassModel ) {
			classModel = classModelIn;
			
			errorCount = 0;
			failureCount = 0;
			successCount = 0;
		}
		
		public function addStatus( status:IStatus ):void {
			if ( status is Failure ) {
				var failure:Failure = status as Failure;
				
				if ( failure.isFailure ) {
					_failureCount++;
				} else {
					_errorCount++;
				}
				
			} else if ( status is Success ) {
				_successCount++;
			}
		}
	}
}
```

## Test Execution Speeds ##

As your application (and its related test suite) grows you may become concerned with the performance of your tests. After all, if your tests become to slow and cumbersome for developers to run, they may run them less frequently and in doing so fail to catch bugs at an earlier phase in development.

Our third renderer will be an [AreaChart](http://livedocs.adobe.com/flex/3/langref/mx/charts/AreaChart.html) that displays the number of tests (methods and assertions) executed over time.

### TestsAndAssertionsOverTime.mxml ###

```
<?xml version="1.0" encoding="utf-8"?>
<mx:HBox width="100%" height="100%" horizontalGap="20"
         horizontalAlign="center" verticalAlign="middle"
         xmlns:mx="http://www.adobe.com/2006/mxml">
	
	<mx:Script>
		<![CDATA[
			import mx.collections.ArrayCollection;
			import mx.graphics.SolidColor;
			
			[Bindable]	// Contains: TestsAndAssertionsOverTimeData
			public var dataProvider:ArrayCollection = new ArrayCollection();
		]]>
	</mx:Script>
	
	<mx:AreaChart id="areaChart" height="100%" width="100%" maxWidth="475" maxHeight="300"
	              dataProvider="{ dataProvider }">
		
		<mx:horizontalAxis>
			<mx:CategoryAxis dataProvider="{ dataProvider }" categoryField="time" />
		</mx:horizontalAxis>
		
		<mx:series>
			<mx:AreaSeries yField="assertionCount" displayName="Assertions"
			               areaFill="{ new SolidColor( 0x0000AA, 1 ) }" />
			<mx:AreaSeries yField="testCount" displayName="Tests"
			               areaFill="{ new SolidColor( 0xAA0000, 1 ) }" />
		</mx:series>
		
	</mx:AreaChart>
	
	<mx:VBox horizontalAlign="center" verticalGap="0">
		<mx:Text styleName="header" text="Tests" />
		<mx:Text styleName="header" text="and" />
		<mx:Text styleName="header" text="Assertions" />
		<mx:Text styleName="header" text="Over" />
		<mx:Text styleName="header" text="Time" />
		
		<mx:Spacer height="25" />
		
		<mx:Legend dataProvider="{ areaChart }"/>
	</mx:VBox>
	
</mx:HBox>
```

### TestsAndAssertionsOverTimeData.as ###

```
package {
	public class TestsAndAssertionsOverTimeData {
		
		public var assertionCount:int;
		public var testCount:int;
		public var time:Number;
		
		public function TestsAndAssertionsOverTimeData( timeIn:Number, testCountIn:int = 0, assertionCountIn:int = 0 ) {
			time = timeIn;
			assertionCount = assertionCountIn;
			testCount = testCountIn;
		}
	}
}
```

## Sprint Graph ##

Admittedly our last chart is just for-fun. Given that, I won't even attempt to justify it. This view uses Mark Shepherd's [SpringGraph](http://mark-shepherd.com/blog/springgraph-flex-component/) component. Unlike our other views, it consists of the following 2 MXML components. (The "model" portion will be comprised of Reflex Unit classes.)

### TestsCasesAndContainedTests.mxml ###

```
<?xml version="1.0" encoding="utf-8"?>
<mx:HBox width="100%" height="100%" horizontalGap="20"
         horizontalAlign="center" verticalAlign="middle"
         xmlns:fc="http://www.adobe.com/2006/fc"
         xmlns:mx="http://www.adobe.com/2006/mxml">
	
	<mx:Script>
		<![CDATA[
			import com.adobe.flex.extras.controls.springgraph.Graph;
			
			[Bindable]	// Contains Item objects (which in turn hold ClassModel or MethodModel objects)
			public var dataProvider:Graph = new Graph();
		]]>
	</mx:Script>
	
	<fc:SpringGraph id="springGraph" width="100%" height="100%" maxWidth="475" maxHeight="300"
	                left="0" right="0" top="0" bottom="0"
	                backgroundColor="0xFFFFFF" lineColor="0xCCCCCC"
	                autoFit="false" repulsionFactor=".33"
	                itemRenderer="TestCasesAndContainedTestsRenderer"
	                dataProvider="{ dataProvider }" />
	
	<mx:VBox horizontalAlign="center" verticalGap="0">
		<mx:Text styleName="header" text="Test" />
		<mx:Text styleName="header" text="Cases" />
		<mx:Text styleName="header" text="and" />
		<mx:Text styleName="header" text="Contained" />
		<mx:Text styleName="header" text="Tests" />
	</mx:VBox>
	
</mx:HBox>
```

### TestsCasesAndContainedTestsRenderer.mxml ###

```
<?xml version="1.0" encoding="utf-8"?>
<mx:Label fontSize="9"
          xmlns:mx="http://www.adobe.com/2006/mxml">
	
	<mx:Script>
		<![CDATA[
			import com.adobe.flex.extras.controls.springgraph.Item;
			
			import flash.utils.getQualifiedClassName;
			
			import reflexunit.framework.statuses.Failure;
			import reflexunit.framework.statuses.IStatus;
			
			override public function set data( value:Object ):void {
				super.data = value;
				
				var item:Item = value as Item;
				
				if ( item.data is IStatus ) {
					var status:IStatus = item.data as IStatus;
					
					text = status.methodModel.name;
					setStyle( 'fontWeight', 'normal' );
					
					if ( status is Failure ) {
						if ( ( status as Failure ).isFailure ) {
							setStyle( 'color', 0x8888a00 );
						} else {
							setStyle( 'color', 0xAA0000 );
						}
					} else {
						setStyle( 'color', 0x009900 );
					}
					
				} else {
					text = getQualifiedClassName( item.data );
					setStyle( 'color', 0x333333 );
					setStyle( 'fontWeight', 'bold' );
				}
			}
		]]>
	</mx:Script>
	
	<mx:filters>
		<mx:GlowFilter alpha=".75" strength="10" blurX="5" blurY="5" color="0xFFFFFF" />
	</mx:filters>
	
</mx:Label>
```

We've just covered a lot, but hopefully it was mostly self-explanatory. If not that's okay; take a look at the online [Flash 9 Language Reference](http://livedocs.adobe.com/flex/3/langref/index.html) for more in-depth documentation and sample code.

We're now ready to plug everything together and see our code in action!

## [Continue to Part 5..](WritingYourOwnCustomViewer5.md) ##