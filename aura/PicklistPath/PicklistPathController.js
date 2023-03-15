({
	handleSelect : function (component, event, helper) {     
    	var stepName = event.getParam("detail").value;
    	var cc = component.get("v.case");
        var action = component.get("c.updateCase");
        action.setParams({ "c": cc, "s": stepName   });
        action.setCallback(this, function(response) {  
            var state = response.getState();
            
            if (state === "SUCCESS") {
                component.find('notifLib').showToast({
            		"variant": "success",
            		"message": "Record was updated sucessfully",
                    "mode" : "sticky"
        		});
                $A.get('e.force:refreshView').fire();
            }
            else if(state === "ERROR"){
                component.find('notifLib').showToast({
            		"variant": "error",
            		"message": "Unfortunately, there was a problem updating the record.",
                    "mode" : "sticky"
        		});
                $A.get('e.force:refreshView').fire();
            }
             
        } );
    	$A.enqueueAction(action);
        
        /*
     	component.find("record").saveRecord($A.getCallback(function(saveResult) {
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                component.find('notifLib').showToast({
            		"variant": "success",
            		"message": "Record was updated sucessfully",
                    "mode" : "sticky"
        		});
            } else {
                component.find('notifLib').showToast({
            		"variant": "error",
            		"message": "Unfortunately, there was a problem updating the record.",
                    "mode" : "sticky"
        		});
            }
        }));
        */
   
    }
})