({
    doInit : function(component, event, helper) {
        var sObj = component.get("v.sObjectName");
        console.log('===do init==='+sObj);
        var recId = component.get("v.recordId");
        console.log('===record Id==='+recId);
        if(sObj){
            helper.getFieldsforObject(component, sObj);
        }
        helper.getFieldLabels(component, event, helper);
        var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
        component.set("v.isMobile",isMobile);
    },
    
    
    Conloadrecord : function(component, event, helper) {
        console.log('===record Load===');
        var recId = component.get("v.recordId");
        console.log('===record Id==='+recId);
        if(recId!=null){
            var Tagfilds = event.getParam("recordUi");
        }
    },
    
    RecordSubmit: function(component, event, helper) {
        event.preventDefault(); // Prevent default submit
        var Tagfields = event.getParam("fields");
        console.log('========'+component.get("v.recordId"));
        
        
        var missField = "";
        var reduceReutrn = component.find('JobTagField').reduce(function(validFields, inputCmp) {   
            if(inputCmp.get("v.fieldName") == "Name" ){
                var TagName = inputCmp.get("v.value");
                if (TagName == null || TagName == '') 
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
        else
        {
            component.find("TagEditform").submit(Tagfields);
        }
        
    },
    onRecordSuccess: function(component, event, helper) {
        if(component.get("v.recordId")!=null)
        {
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": component.get("v.recordId")
            });
            navEvt.fire();
        }
        var ToastMsg1 = $A.get("e.force:showToast");
        ToastMsg1.setParams({
            "title": "Sucess",
            "type": "success",
            "message": "Successfully Updated Record"
            
        });
        ToastMsg1.fire();
    },
    
    doCancel:function(component, event, helper) {
        if(component.get("v.recordId")!=null)
        {
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": component.get("v.recordId")
            });
        }
        navEvt.fire();
    }
})