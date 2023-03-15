({
    doInit : function(component, event, helper) {
        var sObj = component.get("v.sObjectName");
        console.log('===do init==='+sObj);
        var recId = component.get("v.recordId");
        console.log('===record Id==='+recId);
        if(sObj){
            helper.getFieldsforObject(component, sObj);
        }
    },
    
    onloadrecord : function(component, event, helper) {
        console.log('===record Load===');
        var recId = component.get("v.recordId");
        if (recId != null) {
            var Shpfilds = event.getParam("recordUi");
        }
        
    },
    RecordSubmit: function(component, event, helper) {
        event.preventDefault(); // Prevent default submit
        
        var Shpfields = event.getParam("fields");
     //   Shpfields["Job__c"] = component.get("v.recordId");
        var NameField = "";
        
        var reduceReturn=component.find('JobShpField').reduce(function(validFields, inputCmp){
            if(inputCmp.get("v.fieldName") == "Shipment_Name__c")
            {
                var ShpName= inputCmp.get("v.value");
                if(ShpName == null || ShpName == '')
                    NameField="Name";
            }
        }, true);
        
        var ToastMsg=$A.get("e.force:showToast");
        ToastMsg.setParams({
            "title": NameField,
            "type": "error",
            "message": NameField + " Field is required."
        });
        if (NameField == "Name") {
            ToastMsg.fire();
            event.preventDefault();
        } 
        else {
            component.find("ShpEditform").submit(Shpfields);
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
        setTimeout($A.getCallback(function() {
           ToastMsg1.fire();
        }), 2000);
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