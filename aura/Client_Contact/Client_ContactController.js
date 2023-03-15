({
    doInit : function(component, event, helper) {
        
        var rowActions = helper.getRowActions.bind(this, component);
        helper.fetchCCon(component, event, helper);
        helper.CreateCConRecord(component, event, helper); 
        helper.getRoles(component, event, helper);
        helper.getFieldLabels(component, event, helper);
    },
    
    handleRowAction: function(component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
                
            case 'Edit_CCon':
                component.set("v.isCCOpen", true);
                component.set('v.CConRecordid',row.Id);
                break;
            case 'Delete_CCon':
                helper.deleteCCon(component, event, helper);
                break;
        }
    },
    
    updateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },
    
    onSave : function (component, event, helper) {
        helper.saveDataTable(component, event, helper);
    },
    
    CConCreate:function (component, event, helper) {
        component.set("v.isCCOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.isCCOpen", false);
        component.set('v.CConRecordid', null);
    },
    
    CConload:  function(component, event, helper) { 
        console.log('===record Load===');
        var recId=component.get("v.CConRecordid");
        console.log('===Recordid after==='+recId);  
        helper.getRoles(component, event, helper);
        if(recId!=null){
            var CConFields = event.getParam("recordUi");
            setTimeout($A.getCallback(function() {
                component.find("RoleId").set("v.value", CConFields.record.fields.Client_Contact_Role__c.value);
            }),500);
        }
    },
    
    CConOnsubmit : function(component, event, helper) {
        event.preventDefault(); // Prevent default submit
        var CConFields = event.getParam("fields");
        if(component.get('v.CConRecordid')==null || component.get('v.CConRecordid')=='undefined'){ 
            CConFields["Client__c"]=component.get("v.recordId");
        }
        var FirstName;
        var LastName;
        var missField = "";
        var missField1 = "";
        var missField2 = "";
        var missField3 = "";
        var missField4 = "";
        
        var reduceReutrn = component.find('CConField').reduce(function(validFields, inputCmp) {   
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
                    else if(inputCmp.get("v.fieldName") == "UserName__c	"){
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
                            CConFields["Name"]=FirstName+' '+LastName;
                            CConFields["Client_Contact_Role__c"]=component.find("RoleId").get("v.value");
                            console.log('===Role==='+component.find("RoleId").get("v.value"));
                            component.find("CConEditform").submit(CConFields);
                            console.log('===form CCon Fields==='+JSON.stringify(CConFields));
                        }
    },
    
    CCononRecordSuccess: function(component, event, helper) { 
        console.log('===Success==');
        var CConId=component.get('v.CConRecordid');
        var msg;
        if(CConId=='undefined' || CConId==null ){
            msg='Successfully Inserted Client Contact Record';
        }
        else{
            msg='Successfully Updated Client Contact Record';
        }
        console.log('===record Success==='+CConId);
        var ToastMsg11 = $A.get("e.force:showToast");
        ToastMsg11.setParams({
            "title": "Sucess",
            "type": "success",
            "message":msg
            
        });
        
        setTimeout($A.getCallback(function () {
            component.set('v.CConRecordid',null);
            component.set("v.isCCOpen", false);
            helper.fetchCCon(component, event, helper);
        }), 2000);
        ToastMsg11.fire();
    }
    
})