({
    doInit : function(component, event, helper) {
        helper.fetchBBInvLIRec(component, event, helper);
        helper.FetchFieldfromFS(component, event, helper);
        helper.getFieldLabels(component, event, helper);
    },
    
    handleRowAction: function(component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
                
            case 'Edit_BBInvLI':
                component.set("v.isBBInvLIOpen", true);
                component.set('v.BBInvLIRecordid',row.Id);
                break;
                
            case 'Delete_BBInvLI':
                helper.deleteBBInvLI(component, event, helper);
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
    
    BBInvLICreate:function(component, event, helper) {
        component.set("v.isBBInvLIOpen", true);   
    },
    
    onSave: function(component, event, helper) {
        helper.saveDataTable(component, event, helper);
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.isBBInvLIOpen", false);
        component.set('v.BBInvLIRecordid', null);
    },
    
    BBInvLIOnsubmit: function(component, event, helper){
        event.preventDefault(); // Prevent default submit
        var BBInvLIfields = event.getParam("fields");
        BBInvLIfields["Billboard_Invoice__c"] = component.get("v.recordId");
        var GLD=component.get("v.selectedLookUpRecord_GLD").Id;
        console.log('==========GLD========='+JSON.stringify(GLD));
        var GLC=component.get("v.selectedLookUpRecord_GLC").Id;
        console.log('==========GLC========='+JSON.stringify(GLC));
        if(typeof(GLD)!='undefined'){
            BBInvLIfields["GL_Department__c"]=component.get("v.selectedLookUpRecord_GLD").Id;
        }
        else{
            BBInvLIfields["GL_Department__c"]="";
        }
        if(typeof(GLC)!='undefined'){
            BBInvLIfields["GL_Code__c"]=component.get("v.selectedLookUpRecord_GLC").Id;
        }
        else{
             BBInvLIfields["GL_Code__c"]="";
        }
        component.find("BBInvLIEditform").submit(BBInvLIfields);
    },
    
    BBInvLIonSuccess: function(component, event, helper){
        var BBInvLIId=component.get('v.BBInvLIRecordid');
        var msg;
        if(BBInvLIId=='undefined' || BBInvLIId==null)
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
        helper.fetchBBInvLIRec(component, event, helper);
        component.set("v.isBBInvLIOpen", false);
        component.set('v.BBInvLIRecordid', null);
        ToastMsg1.fire();
        
    },
    
    BBInvLIload: function(component, event, helper){
        console.log('===record Load===');
        var recId = component.get("v.BBInvLIRecordid");
       
        if (recId != null) {
            var BBInvLIfields = event.getParam("recordUi");
            if(BBInvLIfields.record.fields.GL_Department__c.value!=null){
                var GLDObj={"Id":BBInvLIfields.record.fields.GL_Department__c.value, "Name":BBInvLIfields.record.fields.GL_Department__r.value.fields.Name.value};
                var GLCObj;
                if(BBInvLIfields.record.fields.GL_Code__c.value!=null){
                    GLCObj={"Id":BBInvLIfields.record.fields.GL_Code__c.value, "Name":BBInvLIfields.record.fields.GL_Code__r.value.fields.Name.value};
                }
                else {
                    GLCObj={};
                }
                    component.find("GLD_GLCId").sampleMethod(GLDObj,GLCObj);
            }
        }
    }
})