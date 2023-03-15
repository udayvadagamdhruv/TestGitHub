({
    doInit : function(component, event, helper) {
         var JobId=component.get("v.recordId");
        
       
        var action = component.get("c.getAllTasksByStatus");
        action.setParams({ JobId : JobId});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            var percent = response.getReturnValue();
            console.log('==percent======'+percent);
            if (state === "SUCCESS") {
                component.set("v.Percentage",percent);
                }
            
        });
        $A.enqueueAction(action);
        
    }
})