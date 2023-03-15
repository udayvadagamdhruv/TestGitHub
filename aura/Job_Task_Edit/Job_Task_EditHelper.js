({
    
     fetchObjectLabels : function(component, event , helper){
       var action=component.get("c.getObjectLabels");
        action.setParams({
            ObjNames:['Job_Task__c']
        });
        
        action.setCallback(this, function(res){
            if(res.getState()=== "SUCCESS"){
                console.log('===Job Task Edit Response====='+JSON.stringify(JSON.parse(res.getReturnValue())));
                component.set("v.ObjectType",JSON.parse(res.getReturnValue()));
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    EditTaskDaysChanged :function(component, event, helper) {
        
        var modalBody;
        var modalFooter; 
        $A.createComponents([
            ["lightning:button",
             {
                 "aura:id": "NoEditDaysId",
                 "label": "No",
                 "onclick":component.getReference("c.NoEditDaysAction") 
             }],
            ["lightning:button",
             {
                 "aura:id": "YesEditDaysId",
                 "variant" :"brand",
                 "label": "Yes",
                 "onclick": component.getReference("c.YesEditDaysAction") 
             }]
        ],
                            function(content, status, errorMessage){
                                if (status === "SUCCESS") {
                                    modalBody = 'Do you want to update rest of the Schedule?';
                                    modalFooter=content;
                                    var modalPromise=component.find('overlayLib1').showCustomModal({
                                        header: "Schedule Update",
                                        body: modalBody,
                                        footer: modalFooter,
                                        showCloseButton: true,
                                        cssClass: "mymodal EditTaskClass",
                                        closeCallback: function() {
                                            //component.find("TaskTable").set("v.draftValues", null);
                                        }
                                    });
                                    component.set("v.overlayPanel1", modalPromise);   
                                } 
                                else if (status === "ERROR") {
                                    console.log("Error: " + errorMessage);
                                }
                                
                            }
                           );
        
    },
    
    
     EditTaskDateChanged :function(component, event, helper) {
     
        var modalBody;
        var modalFooter; 
        $A.createComponents([
             ["lightning:button",
             {
                 "aura:id": "NoEditDateId",
                 "label": "No",
                 "onclick":component.getReference("c.NoEditDateAction") 
             }],
            ["lightning:button",
             {
                 "aura:id": "YesEditDateId",
                 "variant" :"brand",
                 "label": "Yes",
                 "onclick": component.getReference("c.YesEditDateAction") 
             }]
           ],
             function(content, status, errorMessage){
                 if (status === "SUCCESS") {
                     modalBody = 'Do you want to update rest of the Schedule?';
                     modalFooter=content;
                   var modalPromise=component.find('overlayLib1').showCustomModal({
                         header: "Schedule Update",
                         body: modalBody,
                         footer: modalFooter,
                         showCloseButton: true,
                         cssClass: "mymodal EditTaskClass",
                         closeCallback: function() {
                         }
                     });
                     
                  component.set("v.overlayPanel1", modalPromise);   
                 } 
                 else if (status === "ERROR") {
                     console.log("Error: " + errorMessage);
             }
             
         }
    );
        
    },
    
    
    TaskEditSucess :function(component,event, helper,TaskId,UpdateRestDays,UpdateRestDates){
        var TaskSuccessAction=component.get("c.TaskEditSuccess");
        TaskSuccessAction.setParams({
            TaskId : TaskId,
            UpdateRestDays : UpdateRestDays,
            UpdateRestDates :UpdateRestDates
        });
        
        TaskSuccessAction.setCallback(this, function(response){ 
            console.log('=====State of Tas===='+response.getState());
            if (response.getState() === "SUCCESS") {
                
                if(response.getReturnValue()=="OK"){
                    //helper.JobTasksfetch(component,event);
                    //this.fetchCalenderEvents(component,event, helper);
                    //helper.reloadDataTable();
                    
                    component.set("v.isDaysChanged",false);
                    component.set("v.isDueDateChanged",false);
                    helper.showToast({
                        "type": "success",
                        "message": "Sucessfully Updated the Job Task."
                    });
                    
                    var TaskId=component.get("v.recordId");
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": TaskId,
                        "slideDevName": "detail"
                    });
                    navEvt.fire();   
                    
                }
                else{
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": response.getReturnValue()
                    });  
                }
                
            }  
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                });
                toastEvent.fire();
            }
        }); 
        $A.enqueueAction(TaskSuccessAction); 
        
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
    
    reloadDataTable : function(){
        var refreshEvent = $A.get("e.force:refreshView");
        if(refreshEvent){
            refreshEvent.fire();
        }
    },
    
    
    
})