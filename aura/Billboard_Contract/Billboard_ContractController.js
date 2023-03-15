({
    doInit : function(component, event, helper) {
        
        helper.fetchBBConRec(component, event, helper);
        helper.FetchFieldfromFS(component, event, helper);
        helper.getFieldLabels(component, event, helper);
    },
    
    handleRowAction: function(component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
                
            case 'Edit_BBCon':
                component.set("v.isBBConOpen", true);
                component.set('v.BBConRecordid',row.Id);
                break;
                
            case 'Delete_BBCon':
                helper.deleteBBCon(component, event, helper);
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
    
    BBConCreate:function(component, event, helper) {
        component.set("v.isBBConOpen", true);   
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.isBBConOpen", false);
        component.set('v.BBConRecordid', null);
    },
    
    BBConOnsubmit: function(component, event, helper){
        event.preventDefault(); // Prevent default submit
        var BBConfields = event.getParam("fields");
        var VenField = component.get("v.selectedLookUpRecord_Ven"); 
        BBConfields["Billboard__c"] = component.get("v.recordId");
        if(typeof(VenField.Id)!='undefined') 
        {
            BBConfields["BB_Vendor_Name__c"]=component.get("v.selectedLookUpRecord_Ven").Id;
        }
        else{
            BBConfields["BB_Vendor_Name__c"]="";
        }
        component.find("BBConEditform").submit(BBConfields);
    },
    
    BBCononSuccess: function(component, event, helper){
        var BBConId=component.get('v.BBConRecordid');
        var msg;
        if(BBConId=='undefined' || BBConId==null)
        {
            msg='Successfully Inserted Record';
        }
        else
        {
            msg='Successfully Updated Record';
        }
        var ToastMsg1 = $A.get("e.force:showToast");
        ToastMsg1.setParams({
            "title": "Sucess",
            "type": "success",
            "message":msg
        });
        helper.fetchBBConRec(component, event, helper);
        component.set("v.isBBConOpen", false);
        component.set('v.BBConRecordid', null);
        ToastMsg1.fire();
        
    },
    
    BBConload: function(component, event, helper){
        console.log('===record Load===');
        var recId = component.get("v.BBConRecordid");
        
        var VenPopulate=component.get("v.VenPopulate");
        console.log('===VenPopulate===='+VenPopulate);
        if(VenPopulate!=null && VenPopulate!=''){
            console.log('===VenPopulate after if===='+JSON.stringify(VenPopulate));
            component.find("VenauraId").sampleMethod(VenPopulate);
        }
        if (recId != null) {
            var BBConfields = event.getParam("recordUi");
            if(BBConfields.record.fields.BB_Vendor_Name__c.value!=null){
                var VenObj={"Id":BBConfields.record.fields.BB_Vendor_Name__c.value, "Name":BBConfields.record.fields.BB_Vendor_Name__r.value.fields.Name.value};
                console.log('>>>>>>  VenObj  >>>>>>>>>'+VenObj)
                component.find("VenauraId").sampleMethod(VenObj);
            }
        }
    }
    
    
})