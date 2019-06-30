/**
 * Internal class interacts with the Apex Flow API to invoke a flow, pass inputs and collect outputs 
 *   @see FlowProcess
 **/
public class FlowProcessRunner {

    public Map<String, Object> run(FlowProcess.Resolver resolver, Map<String, Object> inputs, Set<String> outputVarNames, Set<String> outputVarRequiredNames) {
        String flowName = resolver.resolve();
        Flow.Interview flow = Flow.Interview.createInterview(flowName, inputs);
        flow.start();
        Map<String, Object> outputVars = new Map<String, Object>();
        for(String outputVar : outputVarNames) {
            Object outputVarValue = flow.getVariableValue(outputVar);
            if(outputVarValue!=null) {
                outputVars.put(outputVar, outputVarValue);
            } else if(outputVarRequiredNames.contains(outputVar)) {
                throw new FlowProcess.FlowProcessException('Output variable ' + outputVar + ' expected but not returned from Flow ' + flowName);
            }                                
        }
        return outputVars;
    }

}