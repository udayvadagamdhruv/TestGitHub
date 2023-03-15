({
    doInitChangesNeededTask : function(component, event, helper) {
        
        var recId = component.get("v.recordId");
        
        var ChangesNeededTask=component.get("c.taskChangesNeeded");
        ChangesNeededTask.setParams({
            TskId : recId
        });
        
        ChangesNeededTask.setCallback(this, function(response){ 
            
            console.log('>>>Response State>>>>>'+response.getState());
            console.log('>>>Response State1>>>>>'+response.getReturnValue());
            
            if (response.getState() === "SUCCESS") {
                var res=response.getReturnValue();
                if(response.getReturnValue()=="Not Ready"){
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": 'This Step has not been submitted for review.'
                    });
                    $A.get("e.force:closeQuickAction").fire(); 
                }
                else if(response.getReturnValue()=="already Approved"){
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": 'This Step has already been Approved.'
                    });
                    $A.get("e.force:closeQuickAction").fire(); 
                }
                else{
                    helper.showToast({
                        "type": "success",
                        "message": "Step status has changed to Changes Needed."
                    });
                     $A.get("e.force:closeQuickAction").fire();
                    $A.get('e.force:refreshView').fire();
                    /*var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": res,
                        "slideDevName": "detail"
                    });
                    navEvt.fire();*/
                }
            }
            else{
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": response.getReturnValue()
                });  
            }
        });
        
        $A.enqueueAction(ChangesNeededTask);
    },
    
    handleClose : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire(); 
    },
    
})