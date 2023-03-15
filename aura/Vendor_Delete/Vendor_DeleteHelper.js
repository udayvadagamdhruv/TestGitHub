({
	delete_Ven : function(component, event, helper) {
        var recId = component.get("v.recordId");
        var SobjName ="Vendor__c";
        var delActon=component.get("c.DeleteVen");
            delActon.setParams({"VenId": recId});
        delActon.setCallback(this, function(deleteRes) {
             console.log('===vendor delete result======' + deleteRes.getReturnValue());
            if (deleteRes.getState() === "SUCCESS") {
                if(deleteRes.getReturnValue()=="OK"){
                    helper.showToast({
                        "type": "success",
                        "message": 'Record Deleted.'
                    });     
                    
                    var homeEvent = $A.get("e.force:navigateToObjectHome");
                    homeEvent.setParams({
                        "scope": "Vendor__c"
                    });
                    homeEvent.fire();
                } 
                else{
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": deleteRes.getReturnValue()
                    });     
                }
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response1.getError()[0].message);
                var errors = response1.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Vendors has '+ errors[0].message
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