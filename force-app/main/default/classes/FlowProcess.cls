/**
 * Manages the execution and interfacing of runtime resolved Flows in Apex
 *   - Fluent syntax for configuration and self documenting usage (output parameter expectations)
 *   - Resolution of the named Flow to execute as expressed via Custom Metadata (Admin configurable)
 *   - Required Flow output parameter checking
 **/
public class FlowProcess {

    private Resolver resolver = null;

    private Map<String, Object> inputs = new Map<String, Object>();

    private Set<String> outputVars = new Set<String>();

    private Set<String> outputVarsRequired = new Set<String>();

    public FlowProcess() { }

    /**
     * Run the given Flow
     **/
    public FlowProcess named(String flowName) {
        resolver = new ResolveByName(flowName);
        return this;
    }

    /**
     * Run the Flow configured by the given metadata custom record 
     **/
    public FlowProcess named(String recordName, SObjectType metadataType, SObjectField flowNameField) {
        resolver = new ResolveByLookup(recordName, metadataType, flowNameField);
        return this;
    }

    /**
     * Pass the following parameter to the Flow
     **/
    public FlowProcess with(String variableName, Object variableValue) {
        inputs.put(variableName, variableValue);
        return this;
    }

    /**
     * Include the following parameter in the output map
     **/
    public FlowProcess output(String variableName) {
        outputVars.add(variableName);
        return this;
    }

    /**
     * Ensure the following parameter is returned and if not throw an exception
     **/
    public FlowProcess required(String variableName) {
        output(variableName);
        outputVarsRequired.add(variableName);
        return this;
    }

    /**
     * Runs the Flow configured by this process
     **/
    public Map<String, Object> run() {
        if(resolver==null) {
            throw new FlowProcessException('You must call the named method before calling the run method.');
        } 
        return runner.run(resolver, inputs, outputVars, outputVarsRequired);
    }

    /**
     * Runs the Flow configured by this process and returns the given parameter
     **/
    public Object returning(String outputVariableName) {
        return required(outputVariableName).run().get(outputVariableName);
    }

    /**
     * Default runner used to create and execute Flows in memory
     **/
    private static FlowProcessRunner runner = new FlowProcessRunner();

    /**
     * Enable the ability to mock Flow executions, by mocking the Runner class via Apex Stub API
     **/
    @TestVisible
    private static void setMock(FlowProcessRunner mockRunner) {
        runner = mockRunner;
    }

    /**
     * Encapsulates the act of resolving the Flow to use for this process
     **/
    public abstract class Resolver {
        public abstract String resolve();
    }

    /**
     * Resolves a given Flow by name
     **/
    public class ResolveByName extends Resolver {
        public String flowName {get; private set;}
        private ResolveByName(String flowName) { this.flowName = flowName; }
        public override String resolve() { return flowName; }
    }

    /**
     * Resolves a Flow by reading a specific Custom Metadata record
     **/
    public class ResolveByLookup extends Resolver {
        public String recordName {get; private set;}
        public SObjectType metadataType  {get; private set;}
        public SObjectField flowNameField {get; private set;}
        private ResolveByLookup(String recordName, SObjectType metadataType, SObjectField flowNameField) {
            this.recordName = recordName;
            this.metadataType = metadataType;
            this.flowNameField = flowNameField;
        }
        public override String resolve() {
            List<SObject> metadataRecords = 
                Database.query('select ' + flowNameField + ' from ' + metadataType + ' where DeveloperName = :recordName');
            if(metadataRecords.size()==1) {
                return (String) metadataRecords[0].get(flowNameField);
            }
            throw new FlowProcessException('Record named ' + recordName + ' not found in ' + metadataType + '.' + flowNameField);
        }
    }

    public class FlowProcessException extends Exception {}
}