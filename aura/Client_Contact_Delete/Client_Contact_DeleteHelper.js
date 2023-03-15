({
	delete_ClientCon : function(component, event, helper) {
        var recId = component.get("v.recordId");
        var SobjName = "Client_Contact__c";
        var delActon=component.get("c.DeleteCCon");
        delActon.setParams({"CConId": recId});
        delActon.setCallback(this, function(deleteRes) {
            console.log('===state======' + deleteRes.getState());
            var deleteState = deleteRes.getState();
            if (deleteState === "SUCCESS") {
                if(deleteRes.getReturnValue() == "OK"){
                    var Clientid=deleteRes.getReturnValue();
                    
                    this.showToast({
                        "type": "success",
                        "message": 'Record Deleted.'
                    });     
                    
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": Clientid,
                        "slideDevName": "detail"
                    });
                    navEvt.fire();
                }
                else{
                     this.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": deleteRes.getReturnValue()
                    });  
                }
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',deleteRes.getError()[0].message);
                var errors = deleteRes.getError();
                this.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Client Contact has '+errors[0].message
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