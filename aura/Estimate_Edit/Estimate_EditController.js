({
	doInit : function(component, event, helper) {
       // alert('do init');
        var sObj = component.get("v.sObjectName");
        if(sObj){
            helper.getFieldsforObject(component, sObj);
            helper.getGLDepartment(component, event, helper);
        }
        helper.getFieldLabels(component, event, helper);
        
    },
    
    onloadrecord : function(component, event, helper) {
         //alert('onloadrecord');
        console.log('===record Load Starts===');
        var recId = component.get("v.recordId");
        if(recId!=null){
            var Estfilds = event.getParam("recordUi");
            //helper.getGLDepartment(component, event, helper);
            //alert(Estfilds.record.fields.GL_Department__c.value);
            component.find("GLDSelectId").set("v.value",Estfilds.record.fields.GL_Department__c.value);
            
            var GLCodeVal=Estfilds.record.fields.GL_Code__c.value;
            var VendorVal=Estfilds.record.fields.Vendor__c.value;
            
            helper.getGLCode(component, event,helper, GLCodeVal, VendorVal);
          
          /*  setTimeout($A.getCallback(function() {
                component.find("GLCodeSelectId").set("v.value",Estfilds.record.fields.GL_Code__c.value);
                console.log('==GL_Code__c Onload Id=='+component.find("GLCodeSelectId").get("v.value"));
                helper.getVendor(component, event, helper);
            }), 500);
           
            setTimeout($A.getCallback(function() {
                component.find("VendorId").set("v.value",Estfilds.record.fields.Vendor__c.value);
                console.log('==Vendor__c Onload Id=='+component.find("VendorId").get("v.value"));
            }), 1000);*/
        }
        console.log('>>>>> Record on load Ends >>>>');
      
    },
    RecordSubmit: function(component, event, helper) {
        console.log('>>>>> Record Submit starts >>>>');
        event.preventDefault(); // Prevent default submit
        var Estfields = event.getParam("fields");
        var missField = "";
        var missField1 = "";
        var missField2 = "";
        var reduceReutrn = component.find('JobEstField').reduce(function(validFields, inputCmp) {   
            if(inputCmp.get("v.fieldName") == "Name" ){
                var EstName = inputCmp.get("v.value");
                if (EstName == null || EstName == '') 
                    missField = "Name";
            } 
            
            else if(inputCmp.get("v.fieldName") == "Quantity__c"){
                var EstName1 = inputCmp.get("v.value"); 
                if (EstName1 == null || EstName1 == '') 
                    missField1 = "Quantity";
            }
                else if(inputCmp.get("v.fieldName") == "Amount__c"){
                    var EstUnit = inputCmp.get("v.value"); 
                    if (EstUnit == null || EstUnit == '') 
                        missField2 = "Unit Cost";
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
        if (missField == "Name"){
            ToastMsg.fire();
            event.preventDefault();
        }
        else if(component.find("GLDSelectId").get("v.value")==null|| component.find("GLDSelectId").get("v.value")==''){
            var ToastMsg3=$A.get("e.force:showToast");
            ToastMsg3.setParams({
                "title":"GL Depatment",
                "type": "error",
                "message":"GL Depatment Field is required."
                
            });   
            ToastMsg3.fire();
            event.preventDefault();   
        }
            else if(component.find("GLCodeSelectId").get("v.value")==null || component.find("GLCodeSelectId").get("v.value")==''){
                var ToastMsg4=$A.get("e.force:showToast");    
                ToastMsg4.setParams({
                    "title":"GLCode",
                    "type": "error",
                    "message":"GLCode Field is required."
                    
                });   
                ToastMsg4.fire();
                event.preventDefault();   
            }
                else if(component.find("VendorId").get("v.value")==null || component.find("VendorId").get("v.value")==''){
                    var ToastMsg5=$A.get("e.force:showToast");    
                    ToastMsg5.setParams({
                        "title":"Vendor",
                        "type": "error",
                        "message":"Vendor Field is required."
                        
                    });   
                    ToastMsg5.fire();
                    event.preventDefault();   
                } 
                    else if (missField1 == "Quantity"){
                        ToastMsg2.fire();
                        event.preventDefault();
                    }
                        else if (missField2 == "Unit Cost"){
                            ToastMsg1.fire();
                            event.preventDefault();
                        }
        
                            else{
                                Estfields["GL_Department__c"]=component.find("GLDSelectId").get("v.value");
                                //console.log('===GL_Department__c==='+component.find("GLDSelectId").get("v.value"));
                                Estfields["GL_Code__c"]=component.find("GLCodeSelectId").get("v.value");
                                //console.log('===Code==='+component.find("GLCodeSelectId").get("v.value"));
                                Estfields["Vendor__c"]=component.find("VendorId").get("v.value");
                                //console.log('===Ven==='+component.find("VendorId").get("v.value"));
                                //console.log('===form Estfields==='+Estfields);
                                //console.log('===form Estfields==='+JSON.stringify(Estfields));
                                component.find("EstimateEditform").submit(Estfields);
                                //console.log('===form Estfields==='+JSON.stringify(Estfields));
                            }
        console.log('>>>>> Record Submit Endss >>>>');
    },
    
    onRecordSuccess: function(component, event, helper) {
        console.log('>>>>> Record on success Starts >>>>');
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
            "title": "Success",
            "type": "success",
            "message": "Successfully Updated Estimate Record"
            
        });
        setTimeout($A.getCallback(function() {
           ToastMsg1.fire();
        }), 1000);
        console.log('>>>>> Record on success Ends >>>>');
    },

    GLDepatment: function(component, event, helper) {
        
        component.find("GLCodeSelectId").set('v.value',null);
        component.set("v.VendorRecords", null);
        component.find("VendorId").set('v.value',null);
        //component.set('v.Amount', null);
        helper.getGLCode(component, event, helper, null, null);
    },
    
     GLCode:function(component, event, helper) {
         component.find("VendorId").set('v.value',null);  
         var GLCodeVal=component.find("GLCodeSelectId").get('v.value');
         console.log('--GLCodeVal-'+GLCodeVal);
        helper.getVendor(component, event, helper, GLCodeVal, null);
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