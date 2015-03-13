# Reflex Unit Users: Configuring a Flex Project #

# Enabling Metadata #
In order to enable metadata support for Reflex Unit, do the following:
  1. Right click on the project and select "Properties"
  1. Go to the "Flex Compiler" tab
  1. In the "Additional compiler arguments" field, ensure you have the following:
```
-keep-as3-metadata+=Test,TestCase
```
You may need to clean you project after making this change in order for it to apply.

# Reflex Unit Developers: Setting Up a Local SVN Checkout #

## Configuring Project Directory ##
If you're using the Flex Builder plugin with Subclipse, then this will not be an issue. If you're using Tortoise SVN though, you'll want to do the following:
  1. Navigate to the root of your project directory
  1. Right click on the "bin" folder and select: "Tortoise SVN" -> "Add to ignore list" -> "bin"

## Generating/Updating Documentation ##
In order to generate project docs from a local SVN checkout simply run the following terminal command from the root of the project:
```
asdoc -source-path . -doc-sources . -output docs
```

## Setting SVN Mime-Types ##
  1. Using Tortoise SVN, rick click on your local checkout and go to "Tortoise SVN" -> "Settings"
  1. In the "General" tab, click on the "Edit" button beside "Subversion configuration file"
  1. Make sure the following lines are in the file (and are not commented out)
```
enable-auto-props = yes
[auto-props]
*.gif = svn:mime-type=image/gif
*.png = svn:mime-type=image/png
*.jpg = svn:mime-type=image/jpeg
*.htm = svn:mime-type=text/html
*.html = svn:mime-type=text/html
```