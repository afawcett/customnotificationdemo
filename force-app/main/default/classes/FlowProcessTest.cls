@IsTest
public with sharing class FlowProcessTest {

    @IsTest
    private static void whenFlowProcessEndsExpectsResponse() {
        // Given 
        FlowProcessRunner mockRunner = 
            (FlowProcessRunner) Test.createStub(FlowProcessRunner.class, new RunnerMock());
        FlowProcess.setMock(mockRunner);
        // When
        List<Account> accounts = (List<Account>) 
            new FlowProcess().named('GetSomeRecords').returning('Records');
        // Then
        System.assertEquals(1, accounts.size());
        System.assertEquals('MyAccount', accounts[0].Name);
    }

    private class RunnerMock implements System.StubProvider {
        public Object handleMethodCall(
                Object stubbedObject, String stubbedMethodName, Type returnType, 
                List<Type> listOfParamTypes, List<String> listOfParamNames, List<Object> listOfArgs) {
            // Assert FlowProcess was passed the correct Flow name to resolve
            FlowProcess.ResolveByName resolver = (FlowProcess.ResolveByName) listOfArgs[0];
            System.assertEquals('GetSomeRecords', resolver.flowName);
            // Mock a response from the Flow
            return new Map<String, Object> { 
                'Records' => new List<Account> { new Account(Name = 'MyAccount') } };
        }
    }
}
