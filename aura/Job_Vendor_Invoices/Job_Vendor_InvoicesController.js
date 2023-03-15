({
    doInit : function(component, event, helper) {
         
        var checkPEpermisson=component.get("c.getVIPermiossions");
        checkPEpermisson.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                console.log('---response.getReturnValue()--INVOICES--'+JSON.stringify(response.getReturnValue()));
                component.set("v.isAccess",response.getReturnValue());
                if(component.get("v.isAccess[0]")){
                    helper.getFieldLabels(component, event, helper);
                    helper.fetchJobInv(component, event, helper);
                    helper.CreateInvRecord(component, event, helper); 
                    helper.getVendor(component, event, helper);
                }               
            }
        });
        $A.enqueueAction(checkPEpermisson);
        
      
        var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
        console.log('--isMobile'+isMobile);
        if(isMobile){
            component.set("v.isMobile",true);
        }
        
      
        
        
    },
    
    recordsUpdateforchanges :function(component, event, helper) {
        helper.fetchJobInv(component, event, helper);
    },
    
    handleRowAction: function(component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
                
            case 'Edit_Inv':
                if(component.get("v.isAccess[2]")){
                      component.set("v.isInvOpen", true);
                component.set('v.VendorInvRecordid',row.Id);
                }else{
             helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Invoices has insuffiecient access to edit.'
                }); 
      		  }
              
                break;
                
            case 'Delete_Inv':
                helper.deleteJobInv(component, event, helper);
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
    
    InvCreate:function (component, event, helper) {
        if(component.get("v.isAccess[1]")){
            component.set("v.isInvOpen", true);
        }else{
             helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Invoices has insuffiecient access to create'
                }); 
        }
        
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.isInvOpen", false);
        component.set('v.VendorInvRecordid', null);
    },
    
    jobInvOnsubmit : function(component, event, helper) {
        event.preventDefault(); // Prevent default submit
        var Invfields = event.getParam("fields");
        console.log('========'+component.get("v.jobrecordId"));
        Invfields["Job__c"]=component.get("v.jobrecordId");
        
        var InvrecId=component.get("v.VendorInvRecordid");
        console.log('===Invoice Record Id=='+InvrecId);           
        
        var missField = "";
        var missField1 = "";
        var missField2 = "";
        var reduceReutrn = component.find('JobInvField').reduce(function(validFields, inputCmp) {   
            if(inputCmp.get("v.fieldName") == "Name" ){
                var InvName = inputCmp.get("v.value");
                if (InvName == null || InvName == '') 
                    missField = "Name";
            } 
            
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
        
        
        
        else if(missField2 == "Date Received"){
            ToastMsg1.fire();
            event.preventDefault();
        }
            else{
                if(InvrecId==null){
                    if(component.find("VendorId").get("v.value")=='null' || component.find("VendorId").get("v.value")==''){
                        var ToastMsg5=$A.get("e.force:showToast");    
                        ToastMsg5.setParams({
                            "title":"Vendor",
                            "type": "error",
                            "message":"Vendor Field is required."
                        });   
                        ToastMsg5.fire();
                        event.preventDefault();   
                    }
                    else{
                        Invfields["Vendor__c"]=component.find("VendorId").get("v.value");
                        console.log('===Ven==='+component.find("VendorId").get("v.value"));
                        component.find("JobInvEditform").submit(Invfields);
                    }
                    
                }
                else{
                    component.find("JobInvEditform").submit(Invfields);
                }
                
                
            }
    },
    
    onInvRecordSuccess: function(component, event, helper) { 
        var InvId=component.get('v.VendorInvRecordid');
        var msg;
        if(InvId=='undefined' || InvId==null ){
            msg='Successfully Inserted Job Invoice Record';
        }
        else{
            msg='Successfully Updated Job Invoice Record';
        }
        console.log('===record Success==='+InvId);
        var ToastMsg11 = $A.get("e.force:showToast");
        ToastMsg11.setParams({
            "title": "Sucess",
            "type": "success",
            "message":msg
        });
        
        //setTimeout($A.getCallback(function () {
        component.set('v.VendorInvRecordid',null);
        component.set("v.isInvOpen", false);
        helper.fetchJobInv(component, event, helper);
        //helper.getVendor(component, event, helper);
        //}), 500);
        ToastMsg11.fire();
    },
    
    jobInvload:  function(component, event, helper) { 
        console.log('===record Load===');
        var recId=component.get("v.VendorInvRecordid");
        console.log('===Recordid after==='+recId);           
        if(recId!=null){
            var Invfilds = event.getParam("recordUi");
            //helper.fetchJobInv(component, event, helper); 
            // helper.getVendor(component, event, helper);
            //setTimeout($A.getCallback(function() {
            //component.find("VendorId").set("v.value",Invfilds.record.fields.Vendor__c.value);
            //console.log('==Vendor__c Onload Id=='+component.find("VendorId").get("v.value"));
            // }), 500);
        }
    },
    
    /************** Mobile Action ******************************/
    
    handleVdInvcQuickAction : function(component, event, helper) {
        var selectOption=event.getParam("value");
        var selectVdInvId=event.getSource().get("v.name");
        console.log('---selectVdInvId-'+selectVdInvId+'---selectOption--'+selectOption);
        if(selectOption=='Edit'){
            component.set("v.isInvOpen", true);
            component.set('v.VendorInvRecordid',selectVdInvId);
        }
        else {
            helper.deleteJobInv(component, event, helper,selectVdInvId);
        } 
    }
})