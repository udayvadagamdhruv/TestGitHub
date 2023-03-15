({
	fetchAllSTaskWrapper : function(component, event, helper){
        var STaskId =  component.get("v.STaskId");
        var SWrap=component.get("c.getApprovalSTRolesWrapper");
        SWrap.setParams({
            STaskId : STaskId
        });
        
        SWrap.setCallback(this, function(response){ 
            if (response.getState() === "SUCCESS") {
                var swrapperlist=response.getReturnValue();
                component.set("v.STaskRolesWrapper",swrapperlist);   
            }
        }); 
        $A.enqueueAction(SWrap); 
    },
    
    AddRolesMemberstoSTask :function(component, event, helper,Objelist){
        
        var myJSON = JSON.stringify(Objelist);
        console.log('===Object JSON Formatter=='+myJSON);
        var STaskId =  component.get("v.STaskId");
        var AStaffAction=component.get("c.AddRolesToApprovalScheduleTask");
        AStaffAction.setParams({
            STaskId : STaskId,
            selectedRoles : myJSON
        });
        
        AStaffAction.setCallback(this, function(response){ 
            console.log('====response state==='+response.getState());
               console.log('====response==='+response);
             console.log('====response==='+JSON.stringify(response));
            if (response.getState() === "SUCCESS") {
                if(response.getReturnValue() === "OK"){
                    helper.showToast({
                        'type':'success',
                        'message':'Updated Roles to Schedule Task.'
                        
                    });   
                    component.set("v.isSTAddRolesOpen",false); 
                    
                    var appEvent=$A.get("e.c:UpdateRecordsforChanges");
                    if(appEvent){
                        appEvent.fire();  
                    }
                       
                }
                else{
                    helper.showToast({
                        'title':"Error!!",
                        'type':'error',
                        'message':response.getReturnValue()
                        
                    });   
                }
            }
            else{
                helper.showToast({
                    'title':"Error!!",
                    'type':'error',
                    'message':response.getReturnValue()
                    
                });   
            }
            
        }); 
        $A.enqueueAction(AStaffAction); 
        
    },
    
    showToast : function(params){
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams(params);
            toastEvent.fire();
        } else{
            alert(params.message);
        }
    },
})