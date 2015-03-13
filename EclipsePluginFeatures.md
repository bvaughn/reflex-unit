# UI Features #

## Test Selection ##
  * "Scan for Tests" button
  * Ability to manually add/remove test cases
  * Checkbox for toggling each tests active state

## Running Tests ##
  * Run:
    * All test cases
    * Only selected test cases
    * Only selected test methods
  * Option to re-run all previously failing tests
  * Button to "stop-all" test execution

## View Results ##
  * Double-click a class or a method to jump-to the code in Flex Builder
  * Button for showing only errors/failures
  * Summary count panel
  * Single-click a test method to view full info (assertions, stack-trace, etc.)

# XML Protocol #

## Outgoing/Incoming XML ##

```
<message id="UNIQUE_INVOCATION_ID" receiverID="RECEIVER_ID" name="METHOD_NAME">
  <data />
</message>
```

## Return Value ##

```
<return messageID="UNIQUE_INVOCATION_ID" receiverID="RECEIVER_ID" name="METHOD_NAME">
  <data />
</return>
```