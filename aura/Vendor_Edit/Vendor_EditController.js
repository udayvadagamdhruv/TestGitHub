({
	doInit : function(component, event, helper) {
        var sObj = component.get("v.sObjectName");
        if(sObj){
            helper.getFieldsforObject(component, sObj);
             helper.getVendor(component, event, helper);
        }
        var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
        component.set("v.isMobile",isMobile);
        //helper.getFieldLabels(component, event, helper);
    },
    
    onloadrecord : function(component, event, helper) {
        console.log('===record Load===');
        var recId=component.get("v.recordId");
        console.log('===Recordid after==='+recId);           
        if(recId!=null){
            var Invfilds = event.getParam("recordUi");
           // helper.getVendor(component, event, helper);
           // setTimeout($A.getCallback(function() {
              // component.find("VendorId").set("v.value",Invfilds.record.fields.Vendor__c.value);
              //  console.log('==Vendor__c Onload Id=='+component.find("VendorId").get("v.value"));
           // }), 500);
          
        } 
    },
    RecordSubmit: function(component, event, helper) {
        event.preventDefault(); // Prevent default submit
        var Invfields = event.getParam("fields");
        console.log('========'+component.get("v.jobrecordId"));
       
        console.log('===OnSubmit====='+component.get("v.jobrecordId"));
        var missField = "";
        var missField1 = "";
        var missField2 = "";
        var reduceReutrn = component.find('JobInvField').reduce(function(validFields, inputCmp) {   
            if(inputCmp.get("v.fieldName") == "Name" ){
                var InvName = inputCmp.get("v.value");
                if (InvName == null || InvName == '') 
                    missField = "Name";
            } 
            
           /* else if(component.find("VendorId").get("v.value")=='null' || component.find("VendorId").get("v.value")==''){
                var ToastMsg5=$A.get("e.force:showToast");    
                ToastMsg5.setParams({
                    "title":"Vendor",
                    "type": "error",
                    "message":"Vendor Field is required."
                });   
                ToastMsg5.fire();
                event.preventDefault();   
            } */
            
                else if(inputCmp.get("v.fieldName") == "Date_Received__c"){
                    var DateRec = inputCmp.get("v.value"); 
                    if (DateRec == null || DateRec == '') 
                        missField2 = "Date Received";
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
        else if(missField2 == "Date Received"){
            ToastMsg1.fire();
            event.preventDefault();
        }
            else{
                //Invfields["Vendor__c"]=component.find("VendorId").get("v.value");
                //console.log('===Ven==='+component.find("VendorId").get("v.value"));
                component.find("InvoiceeEditform").submit(Invfields);
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
            "message": "Successfully Updated Invoice Record"
            
        });
       // setTimeout($A.getCallback(function() {
           ToastMsg1.fire();
        //}), 2000);
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