# Part 1: Introduction #

This tutorial is intended for Reflex Unit users who are interested in creating custom components for displaying test results. Results can be "displayed" in many ways including visual interfaces comprised of graphs and text (e.g. [FlexViewer](http://reflex-unit.googlecode.com/svn/trunk/ReflexUnitSource/docs/reflexunit/framework/display/flexviewer/FlexViewer.html)), plain text or XML that is printed to the console (e.g. [ConsoleViewer](http://reflex-unit.googlecode.com/svn/trunk/ReflexUnitSource/docs/reflexunit/framework/display/ConsoleViewer.html) or [CruiseControlLogger](http://reflex-unit.googlecode.com/svn/trunk/ReflexUnitSource/docs/reflexunit/framework/display/CruiseControlLogger.html)), or even components that send data via a socket to an external application (e.g. an Eclipse plug-in).

For the purposes of this tutorial we will be using a handful of MX charting components to demonstrate various ways in which test data can be displayed visually to a user/developer. Since these components are included with the Flex framework we won't dive too deeply into their uses/syntax. Instead, our primary goal is to create a solid foundation upon which a developer can expand when creating his or her own custom viewer.

If at any point during this exercise you have a question, feel free to refer to the completed source code for this example application. It is accessible via SVN at the following URL: http://reflex-unit.googlecode.com/svn/misc/tutorials/ReflexUnit-CustomView/

## Before You Begin.. ##

Before starting, make sure that you've downloaded a recent release of Reflex Unit from the [downloads page](http://code.google.com/p/reflex-unit/downloads/list). You may download a bundled SWC or check out the project source.

Next let's create a new Eclipse project to do our development in (`File -> New -> Flex Project`). Once the new project is open, right click on its name in the explorer and choose `Properties -> Flex Build Path`. Tell Flex Builder to include Reflex Unit by modifying the `Source Path` or `Library Path` (depending on which format you downloaded the release in). For more information on this step, please refer to the [Adobe LiveDocs](http://livedocs.adobe.com/flex/3/html/help.html?content=projects_7.html)

Now we are ready to begin.

## [Continue to Part 2..](WritingYourOwnCustomViewer2.md) ##