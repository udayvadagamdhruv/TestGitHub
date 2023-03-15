({
    doInit : function(component, event, helper) {
        
        helper.fetchBBInvPayRec(component, event, helper);
        helper.FetchFieldfromFS(component, event, helper);
		helper.getFieldLabels(component, event, helper);
    },
    
    handleRowAction: function(component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
                
            case 'Edit_BBInvPay':
                component.set("v.isBBInvPayOpen", true);
                component.set('v.BBInvPayRecordid',row.Id);
                break;
                
            case 'Delete_BBInvPay':
                helper.deleteBBInvPay(component, event, helper);
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
    
    BBInvPayCreate:function(component, event, helper) {
        component.set("v.isBBInvPayOpen", true);   
    },
    
    onSave: function(component, event, helper) {
        helper.saveDataTable(component, event, helper);
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.isBBInvPayOpen", false);
        component.set('v.BBInvPayRecordid', null);
    },
    
    BBInvPayOnsubmit: function(component, event, helper){
        event.preventDefault(); // Prevent default submit
        var BBInvPayfields = event.getParam("fields");
        BBInvPayfields["Billboard_Invoice__c"] = component.get("v.recordId");
        
        component.find("BBInvPayEditform").submit(BBInvPayfields);
    },
    
    BBInvPayonSuccess: function(component, event, helper){
        var BBInvPayId=component.get('v.BBInvPayRecordid');
        var msg;
        if(BBInvPayId=='undefined' || BBInvPayId==null)
        {
            msg='Successfully Inserted Record';
            
          /*  var newBBInvLIId=event.getParams().response.id;
            var navevt=$A.get("e.force:navigateToSObject");
            navevt.setParams({
                "recordId": newBBInvLIId,
            });
            navevt.fire();*/
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
        helper.fetchBBInvPayRec(component, event, helper);
        component.set("v.isBBInvPayOpen", false);
        component.set('v.BBInvPayRecordid', null);
        ToastMsg1.fire();
        
    },
    
    BBInvPayload: function(component, event, helper){
        console.log('===record Load===');
        var recId = component.get("v.BBInvPayRecordid");
       
        if (recId != null) {
            var BBInvPayfields = event.getParam("recordUi");
        }
    }
})