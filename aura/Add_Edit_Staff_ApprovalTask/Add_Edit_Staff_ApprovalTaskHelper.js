({
	fetchAllStaffWrapper : function(component, event, helper){
        var TaskId =  component.get("v.TaskId");
        console.log('===TaskId Helper=='+TaskId);
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
        var TaskId =  component.get("v.TaskId");
        console.log('===TaskId Helper=='+TaskId);
        var AStaffAction=component.get("c.AddStaffToTask");
        AStaffAction.setParams({
            TaskId : TaskId,
            selectedStaff : myJSON
        });
        
        AStaffAction.setCallback(this, function(response){ 
            console.log('====response state==='+response.getState());
               console.log('====response==='+response);
             console.log('====response==='+JSON.stringify(response));
            if (response.getState() === "SUCCESS") {
                if(response.getReturnValue() === "OK"){
                    this.showToast({
                        'type':'success',
                        'message':'Updated Staff Members for the Task.'
                        
                    });   
                    component.set("v.isEditStaffOpen",false); 
                    
                    var appEvent=$A.get("e.c:UpdateRecordsforChanges");
                    if(appEvent){
                        appEvent.fire();  
                    }
                       
                }
                else{
                    this.showToast({
                        'title':"Error!!",
                        'type':'error',
                        'message':response.getReturnValue()
                        
                    });   
                }
            }
            else{
                this.showToast({
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