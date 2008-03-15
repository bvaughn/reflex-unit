package reflexunit.framework.display {
	import flash.utils.getQualifiedClassName;
	
	import reflexunit.framework.TestSuite;
	import reflexunit.framework.models.Description;
	import reflexunit.framework.models.Recipe;
	import reflexunit.framework.models.Result;
	import reflexunit.framework.statuses.Failure;
	import reflexunit.framework.statuses.IStatus;
	import reflexunit.introspection.models.MethodModel;
	
	/**
	 * Generates XML information for use with a CruiseControl environment.
	 * XML is in the following format:
	 * 
	 * <code>
	 * <testsuites>
	 *   <testsuite name="package_name::ClassName">
	 *     <testcase name="methodName" time="0.0"/>
	 *     <testcase name="methodName" time="0.0">
	 *       <error><<stack trace>></error>
	 *     </testcase>
	 *     <testcase name="methodName" time="0.0">
	 *       <failure><<stack trace>></failure>
	 *     </testcase>
	 *     ...
	 *   </testsuite>
	 *   ...
	 * </testsuites>
	 * </code>
	 */
	public class CruiseControlLogger implements IResultViewer {
		
		private var _recipe:Recipe;
		private var _result:Result;
		private var _xml:XML;
		
		/*
		 * Initialization
		 */
		
		public function CruiseControlLogger() {
			_xml = new XML( <testsuites /> );
			
			trace( '-----------------TESTRUNNEROUTPUTBEGINS----------------' );
		}
		
		/**
		 * @inheritDoc
		 */
		public function allTestsCompleted():void {
			var success:Boolean = _result.errorCount == 0 && _result.failureCount == 0;
			
			trace( 'Test Suite success: ' + success );
			
			_xml.@time = _result.testTimes
			
			trace( _xml );
			
			trace( '-----------------TESTRUNNEROUTPUTBEGINS----------------' );
		}
		
		/**
		 * @inheritDoc
		 */
		public function testCaseCompleted( description:Description ):void {
		}
		
		/**
		 * @inheritDoc
		 */
		public function testCaseStarting( description:Description ):void {
			var testCaseXML:XML = <testsuite />;
			testCaseXML.@name = description.introspectionUtil.classModel.name;
			
			_xml.appendChild( testCaseXML );
		}
		
		/**
		 * @inheritDoc
		 */
		public function testCompleted( methodModel:MethodModel, status:IStatus ):void {
			var testXML:XML = getTestXML( methodModel );
			
			testXML.@time = status.time;
			
			if ( status is Failure ) {
				var failure:Failure = status as Failure;
				
				if ( failure.isFailure ) {
					testXML.appendChild( <failure>{ failure.error.getStackTrace() }</failure> );
				} else {
					testXML.appendChild( <error>{ failure.error.getStackTrace() }</error> );
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function testStarting( methodModel:MethodModel ):void {
			var testXML:XML = <testcase time="0.0" />;
			testXML.@name = methodModel.name;
			
			var testCaseXML:XML = getTestCaseXML( methodModel );
			
			testCaseXML.appendChild( testXML );
		}
		
		/*
		 * Getter / setter methods
		 */
		
		/**
		 * @inheritDoc
		 */
		public function set recipe( value:Recipe ):void {
			_recipe = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set result( value:Result ):void {
			_result = value;
		}
		
		/*
		 * Helper methods
		 */
		
		private function getTestCaseXML( descriptionOrMethodModel:* ):XML {
			var name:String = descriptionOrMethodModel is MethodModel ?
			                  getQualifiedClassName( ( descriptionOrMethodModel as MethodModel ).methodDefinedBy ) :
			                  ( descriptionOrMethodModel as Description ).introspectionUtil.classModel.name
			
			for each ( var testCaseXML:XML in _xml.testsuite ) {
				if ( testCaseXML.@name == name ) {
					return testCaseXML;
				}
			}
			
			return null;
		}
		
		private function getTestXML( methodModel:MethodModel ):XML {
			for each ( var testXML:XML in _xml.testsuite.testcase ) {
				if ( testXML.@name == methodModel.name ) {
					return testXML;
				}
			}
			
			return null;
		}
	}
}