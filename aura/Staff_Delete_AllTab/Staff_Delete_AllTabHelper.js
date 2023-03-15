({
    delete_Staff : function(component, event, helper) {
        var recId = component.get("v.recordId");
        var SobjName ="Staff__c";
        var delActon=component.get("c.delStaff");
        delActon.setParams({"StaffId": recId});
        delActon.setCallback(this, function(deleteRes) {
            console.log('===state======' + deleteRes.getState());
            var deleteState = deleteRes.getState();
            if (deleteState === "SUCCESS") {
                if(deleteRes.getReturnValue() === 'OK'){
                    console.log('===state======' + deleteRes.getReturnValue());
                    helper.showToast({
                        "type": "success",
                        "message": 'Record Deleted.'
                    });     
                    
                    var homeEvent = $A.get("e.force:navigateToObjectHome");
                    homeEvent.setParams({
                        "scope": "Staff__c"
                    });
                    homeEvent.fire();
                }
            }
            else{
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": deleteRes.getReturnValue()
                });     
            }
        });
        $A.enqueueAction(delActon);
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