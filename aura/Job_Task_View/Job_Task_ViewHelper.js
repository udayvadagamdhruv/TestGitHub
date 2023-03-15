({
    fetchJobTaskRoles : function(component, event, helper){
        var TaskId =  component.get("v.recordId");
        var JTRAction=component.get("c.getJobTaskRoles");
        JTRAction.setParams({
            TaskId : TaskId
        });
        
        JTRAction.setCallback(this, function(response){ 
            if (response.getState() === "SUCCESS") {
                var taskRoleList=response.getReturnValue();
                component.set("v.JobTaskRoles",taskRoleList);   
            }
        }); 
        $A.enqueueAction(JTRAction); 
    },
    
   fetchAllStaffWrapper : function(component, event, helper){
        var TaskId =  component.get("v.recordId");
        var SWrap=component.get("c.getStaffWrapperMembers");
        SWrap.setParams({
            TaskId : TaskId
        });
        
        SWrap.setCallback(this, function(response){ 
            if (response.getState() === "SUCCESS") {
                var swrapperlist=response.getReturnValue();
                component.set("v.AllstaffWrappers",swrapperlist);   
            }
        }); 
        $A.enqueueAction(SWrap); 
    },
    
    AddtoStaffMembersToTask :function(component, event, helper,Objelist){
        
        var myJSON = JSON.stringify(Objelist);
        console.log('===Object JSON Formatter=='+myJSON);
        var TaskId =  component.get("v.recordId");
        var AStaffAction=component.get("c.AddStaffToTask");
        AStaffAction.setParams({
            TaskId : TaskId,
            selectedStaff : myJSON
        });
        
        AStaffAction.setCallback(this, function(response){ 
            if (response.getState() === "SUCCESS") {
                if(response.getReturnValue() === "OK"){
                    helper.fetchJobTaskRoles(component, event, helper);
                    component.set("v.isEditStaffOpen",false); 
                    helper.showToast({
                        'type':'success',
                        'message':'Updated Staff Members for the Task.'
                        
                    });   
                }
                else{
                    helper.showToast({
                        'title':"Error!!",
                        'type':'error',
                        'message':response.getReuturnValue()
                        
                    });   
                }
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