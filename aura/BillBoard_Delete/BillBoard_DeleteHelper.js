({
	delete_BB : function(component, event, helper) {
        var recId = component.get("v.recordId");
        var SobjName ="Billboard__c";
        var delActon=component.get("c.DeleteBB");
            delActon.setParams({"BBId": recId});
        delActon.setCallback(this, function(deleteRes) {
             console.log('===result Clinet delete======' + deleteRes.getReturnValue());
            if (deleteRes.getState() === "SUCCESS") {
                if(deleteRes.getReturnValue()=="OK"){
                    this.showToast({
                        "type": "success",
                        "message": 'Record Deleted.'
                    });     
                    
                    var homeEvent = $A.get("e.force:navigateToObjectHome");
                    homeEvent.setParams({
                        "scope": "Billboard__c"
                    });
                    homeEvent.fire();
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
                    "message": errors[0].message
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