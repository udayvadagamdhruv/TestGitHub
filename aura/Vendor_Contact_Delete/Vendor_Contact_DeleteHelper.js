({
    delete_VenCon : function(component, event, helper) {
        var recId = component.get("v.recordId");
        var SobjName ="Vendor_Contact__c";
        var delActon=component.get("c.DeleteVenCon");
        delActon.setParams({"VenId": recId});
        delActon.setCallback(this, function(deleteRes) {
            console.log('===state======' + deleteRes.getState());
            var deleteState = deleteRes.getState();
            if (deleteState === "SUCCESS") {
                if(deleteRes.getReturnValue() == "OK"){
                    var Vendorid=deleteRes.getReturnValue();
                    
                    helper.showToast({
                        "type": "success",
                        "message": 'Record Deleted.'
                    });     
                    
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": Vendorid,
                        "slideDevName": "detail"
                    });
                    navEvt.fire();
                    
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
                console.log('>>>>>> Error >>>>>>>>>>',deleteRes.getError()[0].message);
                var errors = deleteRes.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Vendor Contact has '+errors[0].message
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