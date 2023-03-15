({
    doInit : function(component, event, helper) {
        var sObj = component.get("v.sObjectName");
        if(sObj){
            helper.getFieldsforObject(component, sObj);
            helper.getVendor(component, event, helper);
            helper.getStaff(component, event, helper);
        }
        helper.getFieldLabels(component, event, helper);
    },
    
    onloadrecord : function(component, event, helper) {
        console.log('===record Load===');
        var recId = component.get("v.recordId");
        if(recId!=null){
            var POfilds = event.getParam("recordUi");
           
            helper.getVendor(component, event, helper);
            helper.getVendorCon(component, event, helper,POfilds.record.fields.Vendor__c.value);
            helper.getStaff(component, event, helper);
            component.set("v.PORecordDetails",POfilds.record.fields);
            console.log('>>>>>>>>>>>POfilds  22222>>>>>>>>>>>>>'+JSON.stringify(POfilds.record.fields));
            console.log('>>>>>>>>>>>POfilds 22222>>>>>>>>>>>>>'+JSON.stringify(POfilds.record.fields.Vendor__r.value.fields.Name.value));
            setTimeout($A.getCallback(function() {
                if(recId==null || recId=='undefined'){
                    //component.find("VendorId").set("v.value",POfilds.record.fields.Vendor__c.value);
                    //console.log('==Vendor__c Onload Id=='+component.find("VendorId").get("v.value"));
                }
            }), 500);
            
            setTimeout($A.getCallback(function() {
                component.find("VenConId").set("v.value",POfilds.record.fields.Vendor_Contact__c.value);
                console.log('==Vendor_Contact__c Onload Id=='+component.find("VenConId").get("v.value"));
            }), 500);
            
            setTimeout($A.getCallback(function() {
                component.find("StaffID").set("v.value",POfilds.record.fields.Approved_By_Staff__c.value);
                console.log('==Approved_By_Staff__c Onload Id=='+component.find("StaffID").get("v.value"));
            }), 1000);
        }
        
    },
    RecordSubmit: function(component, event, helper) {
        event.preventDefault(); // Prevent default submit
        var POfields = event.getParam("fields");
        POfields["Job__c"]=component.get("v.jobrecordId");
        var missField = "";
        var missField1 = "";
        var missField2 = "";
        var reduceReutrn = component.find('JobPOField').reduce(function(validFields, inputCmp) {   
            if(inputCmp.get("v.fieldName") == "Vendor__c"){
                var VenName = inputCmp.get("v.value"); 
                if (VenName == null || VenName == '') 
                    missField = "Vendor";
            }
            
            else if(inputCmp.get("v.fieldName") == "Issue_Date__c" ){
                var POIssueDate = inputCmp.get("v.value");
                if (POIssueDate == null || POIssueDate == '') 
                    missField1 = "Issue Date";
            } 
            
            
                else if(inputCmp.get("v.fieldName") == "Due_Date__c"){
                    var DueDate = inputCmp.get("v.value"); 
                    if (DueDate == null || DueDate == '') 
                        missField2 = "Due Date";
                }
        }, true);
        var ToastMsg = $A.get("e.force:showToast");
        ToastMsg.setParams({
            "title": missField,
            "type": "error",
            "message": missField + " Field is required."
            
        }); 
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
        if (missField == "Vendor"){
            ToastMsg.fire();
            event.preventDefault();
        }
        else if (missField1 == "Issue Date"){
            ToastMsg2.fire();
            event.preventDefault();
        }
            else if(missField2 == "Due Date"){
                ToastMsg1.fire();
                event.preventDefault();
            }
                else{
                   /* if(component.get('v.PORecordid')==null || component.get('v.PORecordid')=='undefined'){
                        POfields["Vendor__c"]=component.find("VendorId").get("v.value");
                        console.log('===Ven==='+component.find("VendorId").get("v.value"));
                    }*/
                    
                    POfields["Vendor_Contact__c"]=component.find("VenConId").get("v.value");
                    POfields["Approved_By_Staff__c"]=component.find("StaffID").get("v.value");
                    component.find("POEditform").submit(POfields);
                }
    },
    onRecordSuccess: function(component, event, helper) {
        
        var ToastMsg1 = $A.get("e.force:showToast");
        ToastMsg1.setParams({
            "title": "Sucess",
            "type": "success",
            "message": "Successfully Updated Purchase Order Record"
            
        });
        ToastMsg1.fire();
        
        if(component.get("v.recordId")!=null)
        {
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": component.get("v.recordId")
            });
            navEvt.fire();
        }
        
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