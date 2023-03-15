({
	LoadDocumnets : function(component, event, helper) {
        var action = component.get("c.loadWorkdocItems");
        action.setParams({
            CampId : component.get("v.recordId")
        });
        
        action.setCallback(this, function(res) {
           
            if (res.getState() === "SUCCESS") {
                 console.log("==========Document Ids========"+JSON.stringify(res.getReturnValue()));
                console.log("==========Document Ids size========"+JSON.stringify(res.getReturnValue().length));
                component.set("v.docList",res.getReturnValue()); 
            }
            
        });
        $A.enqueueAction(action);
    }
})