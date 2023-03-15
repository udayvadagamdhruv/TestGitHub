({
	doInitApprovedTask : function(component, event, helper) {
        
        var recId = component.get("v.recordId");
        
        var ApprovedTask=component.get("c.ApprovedTsk");
        ApprovedTask.setParams({
            TskId : recId
        });
        
        ApprovedTask.setCallback(this, function(response){ 
            
             console.log('>>>Response State>>>>>'+response.getState());
            console.log('>>>Response State1>>>>>'+response.getReturnValue());
            
            if (response.getState() === "SUCCESS") {
                var res=response.getReturnValue();
                if(response.getReturnValue()=="Not Ready"){
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": 'This step has not been submitted for approval.'
                    });
                    $A.get("e.force:closeQuickAction").fire(); 
                }
                else if(response.getReturnValue()=="already Approved"){
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": 'This step has already been Approved.'
                    });
                    $A.get("e.force:closeQuickAction").fire(); 
                }
                else{
                    helper.showToast({
                        "type": "success",
                        "message": "This step was approved."
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
        
         $A.enqueueAction(ApprovedTask);
    },
    
    handleClose : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire(); 
    },
		
})