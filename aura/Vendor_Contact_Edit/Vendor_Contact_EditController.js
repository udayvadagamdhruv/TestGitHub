({
	doInit : function(component, event, helper) {
        helper.getFieldLabels(component, event, helper);
        var sObj = component.get("v.sObjectName");
        console.log('===do init==='+sObj);
        if(sObj){
            
            helper.getFieldsforObject(component, event, helper);
            
            helper.getRoles(component, event, helper);
        }
        
    },
   
    
    onloadrecord : function(component, event, helper) {
        console.log('===record Load===');
        var recId=component.get("v.recordId");
        console.log('===Recordid after==='+recId);  
        helper.getFieldsforObject(component, event, helper);
        helper.getRoles(component, event, helper);
        if(recId!=null){
            var VenConFields = event.getParam("recordUi");
            setTimeout($A.getCallback(function() {
                component.find("RoleId").set("v.value", VenConFields.record.fields.Role__c.value);
            }),1500);
        }
    },
    
    RecordSubmit: function(component, event, helper) {
        event.preventDefault(); // Prevent default submit
        var VenConFields = event.getParam("fields");
        VenConFields["Vendor__c"]=component.get("v.simpleRecord.Vendor__c");
        var FirstName;
        var LastName;
        var missField = "";
        var missField1 = "";
        var missField2 = "";
        var missField3 = "";
        var missField4 = "";
        
        var reduceReutrn = component.find('VenConField').reduce(function(validFields, inputCmp) {   
            if(inputCmp.get("v.fieldName") == "First_Name__c" ){
                FirstName = inputCmp.get("v.value");
                if (FirstName == null || FirstName == '') 
                    missField = "First Name";
            } 
            
            else if(inputCmp.get("v.fieldName") == "Last_Name__c"){
                LastName = inputCmp.get("v.value"); 
                if (LastName == null || LastName == '') 
                    missField1 = "Last Name";
            }
                else if(inputCmp.get("v.fieldName") == "Email__c"){
                    var Email = inputCmp.get("v.value"); 
                    if (Email == null || Email == '') 
                        missField2 = "Email";
                }
                    else if(inputCmp.get("v.fieldName") == "User_Name__c"){
                        var UserName = inputCmp.get("v.value"); 
                        if (UserName == null || UserName == '') 
                            missField3 = "User Name";
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
        var ToastMsg3 = $A.get("e.force:showToast");
        ToastMsg3.setParams({
            "title": missField3,
            "type": "error",
            "message": missField3 + " Field is required."
        }); 
        
        if (missField == "First Name"){
            ToastMsg.fire();
            event.preventDefault();
        }
        else if (missField1 == "Last Name"){
            ToastMsg2.fire();
            event.preventDefault();
        }
            else if (missField2 == "Email"){
                ToastMsg1.fire();
                event.preventDefault();
            }
                else if (missField3 == "User Name"){
                    ToastMsg3.fire();
                    event.preventDefault();
                }
        
                    else if(component.find("RoleId").get("v.value")=='null' || component.find("RoleId").get("v.value")==''){
                        var ToastMsg4=$A.get("e.force:showToast");    
                        ToastMsg4.setParams({
                            "title":"Role",
                            "type": "error",
                            "message":"Role Field is required."
                            
                        });   
                        ToastMsg4.fire();
                        event.preventDefault();   
                    }
        
                        else{
                            VenConFields["Name"]=FirstName+' '+LastName;
                            VenConFields["Role__c"]=component.find("RoleId").get("v.value");
                            console.log('===Role==='+component.find("RoleId").get("v.value"));
                            component.find("VenConEditform").submit(VenConFields);
                            console.log('===form VenCon Fields==='+JSON.stringify(VenConFields));
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
            "message": "Successfully Updated Vendor Contact Record"
            
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