({
    doInit : function(component, event, helper) {
       
        helper.fetchBBInvRec(component, event, helper);
        helper.FetchFieldfromFS(component, event, helper);
        helper.getFieldLabels(component, event, helper);
    },
    
    handleRowAction: function(component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
                
            case 'Edit_BBInv':
                component.set("v.isBBInvOpen", true);
                component.set('v.BBInvRecordid',row.Id);
                break;
                
            case 'Delete_BBInv':
                helper.deleteBBInv(component, event, helper);
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
    
    BBInvCreate:function(component, event, helper) {
        component.set("v.isBBInvOpen", true);   
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.isBBInvOpen", false);
        component.set('v.BBInvRecordid', null);
    },
    
    BBInvOnsubmit: function(component, event, helper){
        
        event.preventDefault(); // Prevent default submit
       
        var BBInvfields = event.getParam("fields");
        var VenField = component.get("v.selectedLookUpRecord_Ven"); 
       
        BBInvfields["Billboard__c"] = component.get("v.recordId");
        if(typeof(VenField.Id)!='undefined') 
        {
            BBInvfields["Billboard_Vendor__c"]=component.get("v.selectedLookUpRecord_Ven").Id;
        }
        else{
            BBInvfields["Billboard_Vendor__c"]="";
        }
        component.find("BBInvEditform").submit(BBInvfields);
    },
    
    BBInvonSuccess: function(component, event, helper){
        var BBInvId=component.get('v.BBInvRecordid');
        var msg;
        if(BBInvId=='undefined' || BBInvId==null)
        {
            msg='Successfully Inserted Record';
            
            var newBBInvId=event.getParams().response.id;
            var navevt=$A.get("e.force:navigateToSObject");
            navevt.setParams({
                "recordId": newBBInvId,
            });
            navevt.fire();
        }
        else{
            msg='Successfully Updated Record';
        }
        var ToastMsg1 = $A.get("e.force:showToast");
        ToastMsg1.setParams({
            "title": "Sucess",
            "type": "success",
            "message":msg
        });
        helper.fetchBBInvRec(component, event, helper);
        component.set("v.isBBInvOpen", false);
        component.set('v.BBInvRecordid', null);
        ToastMsg1.fire();
        
    },
    
    BBInvload: function(component, event, helper){
        console.log('===record Load===');
        var recId = component.get("v.BBInvRecordid");
        
        var VenPopulate=component.get("v.VenPopulate");
        console.log('===VenPopulate===='+VenPopulate);
        if(VenPopulate!=null && VenPopulate!=''){
            console.log('===VenPopulate after if===='+JSON.stringify(VenPopulate));
            component.find("VenauraId").sampleMethod(VenPopulate);
        }
        if (recId != null) {
            var BBInvfields = event.getParam("recordUi");
            if(BBInvfields.record.fields.Billboard_Vendor__c.value!=null){
                var VenObj={"Id":BBInvfields.record.fields.Billboard_Vendor__c.value, "Name":BBInvfields.record.fields.Billboard_Vendor__r.value.fields.Name.value};
                console.log('>>>>>>  VenObj  >>>>>>>>>'+VenObj)
                component.find("VenauraId").sampleMethod(VenObj);
            }
        }
    }
    
    
})