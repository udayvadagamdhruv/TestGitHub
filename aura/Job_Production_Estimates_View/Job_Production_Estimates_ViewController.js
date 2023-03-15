({
    doInit : function(component, event, helper) {
        
        var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
        console.log('--isMobile'+isMobile);
        if(isMobile){
            component.set("v.isMobile",true);
        }
        
        helper.fetchFieldLabels(component, event, helper);
        helper.ProEstSpecRecordsfetch(component, event, helper);
        helper.fetchFieldset(component, event, helper);
    },
    
    updateColumnSorting: function(cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },
    
    onProEstimateSpecsSave:function(component, event, helper) {
        helper.saveDataTableofSpecs(component, event, helper);
    },
    
    NewProEstimateSpec : function(component, event, helper) {
        component.set("v.isProEstSpecOpen",true);
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.proEstSpecRecId", null);
        component.set("v.isProEstSpecOpen", false);
    },
    
    handleRowSpecActions : function(component, event, helper) {
        var action=event.getParam('action');
        var row=event.getParam('row');
        switch(action.name){
            case 'Edit_ProEst_Spec_Item':
                component.set("v.proEstSpecRecId", row.Id);
                component.set("v.isProEstSpecOpen", true);
                break;
            case 'Delete_ProEst_Spec_Item':
                helper.deleteProductionEstimateSpecItem(component, event, helper,row.Id);
                break;
        }
    },
 
     handleSelect : function(component, event, helper) {
        var Menuaction=event.getParam("value");
        var proEstSpecId=event.getSource().get("v.value");
        console.log('======action====='+Menuaction);
        console.log('======proEstSpecId====='+proEstSpecId);
        if(Menuaction=="EditProEstSpec"){
            component.set("v.proEstSpecRecId", proEstSpecId);
            component.set("v.isProEstSpecOpen", true);
        }
        else{
            helper.deleteProductionEstimateSpecItem(component, event, helper,proEstSpecId);
        }
    },
    
    ProEstSpecOnsubmit : function(component, event, helper) {
        
        event.preventDefault(); // Prevent default submit
        var ProEstspecfields = event.getParam("fields");
        ProEstspecfields["Production_Estimate__c"] = component.get("v.recordId");
        var missField = "";
        var reduceReutrn = component.find('ProEstimateSpecField').reduce(function(validFields, inputCmp) {
            if (inputCmp.get("v.fieldName") == "Name") {
                var ProEstimateSpecName = inputCmp.get("v.value");
                if (ProEstimateSpecName == null || ProEstimateSpecName == '')
                    missField= "Spec Name";
            }
        }, true);
        var ToastMsg = $A.get("e.force:showToast");
        ToastMsg.setParams({
            "title": missField,
            "type": "error",
            "message": missField + " Field is required."
            
        }); 
        
        if(missField=="Spec Name"){
            ToastMsg.fire();
            event.preventDefault();
        }
        
        else{
            component.find("ProEstSpecEditform").submit(ProEstspecfields);
        }
    },
        onProEstSpecRecordSuccess : function(component, event, helper) {
            
            var ProEstRecId =component.get("v.proEstSpecRecId");
            var msg="";
            if(ProEstRecId=="undefined" || ProEstRecId==null){
                msg="Successfully Inserted Spec Record";
            }
            else{
                msg="Successfully Updated Spec Record";
            }
            
            component.set("v.proEstSpecRecId", null);
            component.set("v.isProEstSpecOpen", false);
            var ToastMsg1 = $A.get("e.force:showToast");
            ToastMsg1.setParams({
                "type": "success",
                "message":msg
                
            });
            ToastMsg1.fire();
            helper.ProEstSpecRecordsfetch(component, event, helper); 
        },
    
    /************** Mobile Action ******************************/
    
    handlePEstSpecQuickAction : function(component, event, helper) {
        var selectOption=event.getParam("value");
        var selectPEstSpecId=event.getSource().get("v.name");
        console.log('---selectPEstSpecId-'+selectPEstSpecId+'---selectOption--'+selectOption);
        
        switch (selectOption) {
                
			case 'Edit_PEstSpec':
                 component.set("v.proEstSpecRecId", selectPEstSpecId);
                component.set("v.isProEstSpecOpen", true);
                break;
                
            case 'Delete_PEstSpec':
                helper.deleteProductionEstimateSpecItem(component, event, helper,selectPEstSpecId);
                break;
                
        }
    }

})