/**
  * Test code servers as a good demo of the FlowProcess mocking feature
  */
@IsTest
public inherited sharing class CustomNotificationTest {
    
    @IsTest
    private static void whenSendNotificationFlowVarsPassed() {
        // Given 
        FlowProcessRunner mockRunner = 
            (FlowProcessRunner) Test.createStub(FlowProcessRunner.class, new RunnerMock());
        FlowProcess.setMock(mockRunner);
        // When
        new CustomNotification()
            .type('BatchApexError')
            .title('Batch Error')
            .body('Some useful information')
            .sendToCurrentUser();
        // Then
        // ... see asserts in RunnerMock
    }

    private class RunnerMock implements System.StubProvider {
        public Object handleMethodCall(
                Object stubbedObject, String stubbedMethodName, Type returnType, 
                List<Type> listOfParamTypes, List<String> listOfParamNames, List<Object> listOfArgs) {
            // Assert FlowProcess was passed the correct Flow name to resolve
            FlowProcess.ResolveByName resolver = (FlowProcess.ResolveByName) listOfArgs[0];
            System.assertEquals('SendCustomNotification', resolver.flowName);
            Map<String, Object> inputs = (Map<String, Object>) listOfArgs[1];
            System.assertEquals('Batch Error', inputs.get('NotificationTitle'));
            System.assertEquals('Some useful information', inputs.get('NotificationBody'));
            System.assertEquals(UserInfo.getUserId(), inputs.get('TargetId'));
            // TODO: Assert the rest
            // ...
            // Mock a response from the Flow
            return new Map<String, Object>();
        }
    }
}
