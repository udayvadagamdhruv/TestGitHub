({
    doInit : function(component, event, helper) {
       
        helper.fetchVenGlCode(component, event, helper);
        helper.getGLC(component, event, helper);
        helper.getFieldLabels(component, event, helper);
    },
    
    handleRowAction: function(component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
                
            case 'Edit_VenGLc':
                component.set("v.isVGlOpen", true);
                component.set('v.VenGlCRecordid',row.Id);
                break;
            case 'Delete_VenGLc':
                helper.deleteVenGlcode(component, event, helper);
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
    
    VenGlCode:function (component, event, helper) {
        component.set("v.isVGlOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.isVGlOpen", false);
        component.set('v.VenGlCRecordid', null);
    },
       
    VenGlCodeload:  function(component, event, helper) { 
        console.log('===record Load===');
        var recId=component.get("v.VenGlCRecordid");
        console.log('===Recordid after==='+recId);  
       // helper.getGLC(component, event, helper);
        if(recId!=null){
            var VenGlCFields = event.getParam("recordUi");
            setTimeout($A.getCallback(function() {
               component.find("GLCId").set("v.value", VenGlCFields.record.fields.GL_Code__c.value);
            }),500);
        }
    },
    
    VenGlCodeOnsubmit: function(component, event, helper) {
       console.log('>>>>>>>>Submit>>>>>>>>>');
        event.preventDefault(); // Prevent default submit
        var VenGlCFields = event.getParam("fields");
        VenGlCFields["Vendor__c"]=component.get("v.recordId");
        var GlcName=component.find("GLCId").get("v.value");
        
       /*  if(typeof(component.get("v.selectedLookUpRecord_GL").Id)==="undefined"){
            var ToastMsg=$A.get("e.force:showToast");
            ToastMsg.setParams({
                "title":"Glcode",
                "type": "error",
                "message":"Please select Glcode."
            });   
            ToastMsg.fire();
            event.preventDefault(); 
        }*/
        
        
        if(GlcName==null || GlcName=='')
        {
            var ToastMsg=$A.get("e.force:showToast");
            ToastMsg.setParams({
                "title":"Glcode",
                "type": "error",
                "message":"Please select Glcode."
            });   
            ToastMsg.fire();
            event.preventDefault(); 
        }
        else
        {
            VenGlCFields["GL_Code__c"]=component.find("GLCId").get("v.value");
            console.log('===Glcode==='+component.find("GLCId").get("v.value"));
            //VenGlCFields["GL_Code__c"]=component.get("v.selectedLookUpRecord_GL").Id;  
            component.find("VenGlCodeEditform").submit(VenGlCFields);
            console.log('===form Ven Glcode Fields==='+JSON.stringify(VenGlCFields));
        }
    },
    
    VenGlCodeonRecordSuccess: function(component, event, helper) { 
       console.log('===Success==');
        var VenGlcId=component.get('v.VenGlCRecordid');
        var msg;
        if(VenGlcId=='undefined' || VenGlcId==null ){
            msg='Successfully Inserted Vendor GL Code Record';
        }
        else{
            msg='Successfully Updated Vendor GL Code Record';
        }
        console.log('===record Success==='+VenGlcId);
        var ToastMsg11 = $A.get("e.force:showToast");
        ToastMsg11.setParams({
            "title": "Sucess",
            "type": "success",
            "message":msg
            
        });
        
        setTimeout($A.getCallback(function () {
            component.set('v.VenGlCRecordid',null);
            component.set("v.isVGlOpen", false);
            helper.fetchVenGlCode(component, event, helper);
        }), 1000);
        ToastMsg11.fire();
    }
    
    
})