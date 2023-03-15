({
    doInit : function(component, event, helper) {
        var checkPEpermisson=component.get("c.getMOPermiossions");
        checkPEpermisson.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                console.log('---response.getReturnValue()----'+JSON.stringify(response.getReturnValue()));
                component.set("v.isAccess",response.getReturnValue());
                if(component.get("v.isAccess[0]")){
                    helper.CreateMORecord(component, event, helper);   
                }
            }
        });
        $A.enqueueAction(checkPEpermisson); 
        helper.getFieldLabels(component, event, helper);
        helper.fetchMO(component, event, helper); 
        
    },
    
    
    MOCreate  : function(component, event, helper) {
        if(component.get("v.isAccess[1]")){
            component.set("v.isMOOpen", true);
            
        }
    },
    
    jobMOload  : function(component, event, helper) {
        
    },
    
    handleRowAction: function(component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'Edit_MO':
                if(component.get("v.isAccess[2]")){
                    component.set("v.isMOOpen", true);
                    component.set('v.MORecordid',row.Id);
                } else{
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": 'Material order  has insufficient access to edit'
                    }); 
                }            
                break;
                
            case 'Delete_MO':
                if(component.get("v.isAccess[3]")){
                    helper.deleteMO(component, event, helper,row.Id);
                }
                else{
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": 'Material order  has insufficient access to delete'
                    }); 
                }
                break;
        }
    },
            
            jobMOOnsubmit : function(component, event, helper) {
                event.preventDefault(); // Prevent default submit
                var MOfields = event.getParam("fields");
                MOfields["Vendor_Name__c"]=component.get("v.recordId");
                var missField = "";
                var missField1 = "";
                var missField2 = "";
                var reduceReutrn = component.find('JobMOField').reduce(function(validFields, inputCmp) {   
                    if(inputCmp.get("v.fieldName") == "Issue_Date__c" ){
                        var MOIssueDate = inputCmp.get("v.value");
                        if (MOIssueDate == null || MOIssueDate == '') 
                            missField1 = "Issue Date";
                    } 
                    else if(inputCmp.get("v.fieldName") == "MO_Due_Date__c"){
                        var DueDate = inputCmp.get("v.value"); 
                        if (DueDate == null || DueDate == '') 
                            missField2 = "Due Date";
                    }
                }, true);
                var ToastMsg2 = $A.get("e.force:showToast");
                ToastMsg2.setParams({
                    "title": missField1,
                    "type": "error",
                    "message": missField1 + " Field is required."
                    
                }); 
                var ToastMsg1 = $A.get("e.force:showToast");
                ToastMsg1.setParams({
                    "title": missField2,
                    "type": "error",
                    "message": missField2 + " Field is required."
                }); 
                if (missField1 == "Issue Date"){
                    ToastMsg2.fire();
                    event.preventDefault();
                }
                else if(missField2 == "Due Date"){
                    ToastMsg1.fire();
                    event.preventDefault();
                }
                    else{
                        component.find("JobMOEditform").submit(MOfields);  
                    }
            },
                
                onMORecordSuccess : function(component, event, helper) {
                    var MOId=component.get("v.MORecordid");
                    var newMoId=event.getParam("response").id;
                    // alert('MOID === '+MOId);
                    var msg;
                    if(MOId=='undefined' || MOId==null ){
                        msg='Successfully Inserted  MO Record';   
                    }
                    else{
                        msg='Successfully Updated  MO Record';            
                    }
                    var ToastMsg11 = $A.get("e.force:showToast");
                    ToastMsg11.setParams({
                        "type": "success",
                        "message":msg
                    });
                    ToastMsg11.fire();
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": newMoId
                    });
                    navEvt.fire();
                    setTimeout($A.getCallback(function() {
                        component.set("v.isMOOpen", false);
                        component.set('v.MORecordid', null); 
                        helper.fetchMO(component, event, helper); 
                    }),1000);
                },
                    
                    closeModel : function(component, event, helper) {
                        component.set("v.isMOOpen", false);
                        component.set('v.MORecordid', null);  
                    }
    })