({
    doInit : function(component, event, helper) {
        var recId = component.get("v.recordId");
        var sObj = component.get("v.sObjectName");
        if(sObj){
            helper.getFieldsforObject(component, sObj);
        }
    },
    
    onRecordSuccess: function(component, event, helper) 
    { 
        var navEvt = $A.get("e.force:navigateToSObject"); 
        var resultsToast = $A.get("e.force:showToast");
        navEvt.setParams({ 
            "recordId": event.getParam("response").id, 
            "slideDevName": "detail" }); 
        navEvt.fire(); 
        resultsToast.setParams({
            "title": "Saved",
            "type" : "success",
            "message": "The record was saved."
        });
        resultsToast.fire();
    },
    
    handleSubmit:function(component, event, helper) {
        event.preventDefault(); // Prevent default submit
        var ClientFields = event.getParam("fields");
        
        var missField = "";
        var reduceReutrn = component.find('ClientField').reduce(function(validFields, inputCmp) {   
            if(inputCmp.get("v.fieldName") == "Name" ){
                var VenName = inputCmp.get("v.value");
                if (VenName == null || VenName == '') 
                    missField = "Name";
            }
        }, true);
        var ToastMsg = $A.get("e.force:showToast");
        ToastMsg.setParams({
            "title": missField,
            "type": "error",
            "message": missField + " Field is required."
            
        }); 
        if (missField == "Name"){
            ToastMsg.fire();
            event.preventDefault();
        }
        else{
            component.find("Clientform").submit(ClientFields);
            //console.log('===form ClientFields==='+JSON.stringify(ClientFields));
        }
        
    },
    
    doCancel: function(component, helper) {
        if(component.get("v.recordId")!=null)
        {
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": component.get("v.recordId")
            });
        }
        else
        {
            var navEvt = $A.get("e.force:navigateToObjectHome");
            navEvt.setParams({
                "scope":component.get("v.sObjectName")
            });
        }
        navEvt.fire();
    }
    
})