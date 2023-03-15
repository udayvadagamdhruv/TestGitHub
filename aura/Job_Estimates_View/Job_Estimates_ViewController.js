({
    doInit : function(component, event, helper) {
        
        var checkCreate=component.get("c.getEstPermiossions");
        checkCreate.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                console.log('---response.getReturnValue()----'+JSON.stringify(response.getReturnValue()));
                component.set("v.isAccess",response.getReturnValue());
                if(component.get("v.isAccess[3]")){
                    helper.EstSpecRecordsfetch(component, event, helper); 
                    helper.fetchFieldLabels(component, event, helper)
                    helper.getfieldsetvalues(component,  event, helper);
                    helper.productiontempList(component, event, helper);
                }
            }
        });
        $A.enqueueAction(checkCreate);
        
        var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
        console.log('--isMobile'+isMobile);
        if(isMobile){
            component.set("v.isMobile",true);
        }
      
    },
    
    
    handleRowAction: function(component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
       // var sobjname='Estimate_Spec_Item__c';
        console.log('===Est Spec Idsss=='+row.Id);
        switch (action.name) {
         
            case 'Edit_EstSpec':
                if(component.get("v.isAccess[5]")){ 
                    component.set('v.estSpecRecId',row.Id);
                    component.set("v.isEstSpecOpen", true);
                    //  helper.getfieldsetvalues(component, sobjname);
                } else{
                    var ToastImportMsg=$A.get("e.force:showToast");
                    ToastImportMsg.setParams({
                        "title" : "Error",
                        "type" :"error",
                        "message" : 'Estimate Spec Item has insufficient access to edit.'                   
                    });
                    ToastImportMsg.fire();  
                }
                break;
                
            case 'Delete_EstSpec':
                helper.deleteEstSpec(component, event, helper);
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
    
    ImportProductionTemp : function(component, event, helper) {
        var ProdTempId=component.find("ProTemplateId").get("v.value");
        var EstrecId=component.get("v.recordId");
        var ImporTempAction = component.get("c.importProTemplateSpecs");
        console.log('==ProdTempId='+ProdTempId);
        console.log('==EstrecId='+EstrecId);
        
        ImporTempAction.setParams({
            EstrecId : EstrecId,
            ProTempId: ProdTempId
            
        });
        ImporTempAction.setCallback(this, function(Impresponse) {
            if (Impresponse.getState() === "SUCCESS") {
                var msg="";
                var type="";
                if(Impresponse.getReturnValue()=='Choose'){
                    msg="Please select the Production Spec Template.";
                    type="error";
                }
                else if(Impresponse.getReturnValue()=='NoRecords'){
                    msg="This Production Spec Template doesn\'t have any spec Items to import.";
                    type="error";
                }
                else if(Impresponse.getReturnValue()=='OK'){
                        msg="Successfully Imported Production Spec Template.";
                        type="success";
                }else{
                        msg=Impresponse.getReturnValue();
                        type="error";
                    }
                
                var ToastImportMsg=$A.get("e.force:showToast");
                ToastImportMsg.setParams({
                    "title" : "Import Template",
                    "type" :type,
                    "message" : msg                   
                });
                    ToastImportMsg.fire();
                    component.find("ProTemplateId").set("v.value",null);
                    helper.EstSpecRecordsfetch(component, event, helper); 
                }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',Impresponse.getError()[0].message);
                var errors = Impresponse.getError();                
                var ToastImportMsg=$A.get("e.force:showToast");
                ToastImportMsg.setParams({
                    "title" : "Error!!",
                    "type" :"error",
                    "message" :errors[0].message          
                });
                ToastImportMsg.fire();
            }
        });
        $A.enqueueAction(ImporTempAction);
    },
    
    NewEstimateSpec : function(component, event, helper) {
        //var sobjname='Estimate_Spec_Item__c';
        // helper.getfieldsetvalues(component, sobjname); 
        if(component.get("v.isAccess[4]")){       
            component.set("v.isEstSpecOpen", true); }
        else{
            var ToastImportMsg=$A.get("e.force:showToast");
            ToastImportMsg.setParams({
                "title" : "Error",
                "type" :"error",
                "message" : 'Estimate Spec Item has insufficient access to create.'                   
            });
            ToastImportMsg.fire();  
        }
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.estSpecRecId", null);
        component.set("v.isEstSpecOpen", false);
    },
    
    
    EstSpecOnsubmit : function(component, event, helper) {
        
     event.preventDefault(); // Prevent default submit
        var Estspecfields = event.getParam("fields");
        Estspecfields["Estimates__c"] = component.get("v.recordId");
        var missField = "";
        var reduceReutrn = component.find('EstimateSpecField').reduce(function(validFields, inputCmp) {
            if (inputCmp.get("v.fieldName") == "Name") {
                var EstimateSpecName = inputCmp.get("v.value");
                if (EstimateSpecName == null || EstimateSpecName == '')
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
             component.find("EstSpecEditform").submit(Estspecfields);
        }
        
        
    },
    onEstSpecRecordSuccess : function(component, event, helper) {
       
        var EstRecId =component.get("v.estSpecRecId");
        var msg="";
        if(EstRecId=="undefined" || EstRecId==null){
            msg="Successfully Inserted Spec Record";
        }
        else{
             msg="Successfully Updated Spec Record";
        }
        
        component.set("v.estSpecRecId", null);
        component.set("v.isEstSpecOpen", false);
        var ToastMsg1 = $A.get("e.force:showToast");
        ToastMsg1.setParams({
            "type": "success",
            "message":msg
            
        });
        ToastMsg1.fire();
         helper.EstSpecRecordsfetch(component, event, helper); 
    },
       
    /************** Mobile Action ******************************/
    
    handleEstSpecQuickAction : function(component, event, helper) {
        var selectOption=event.getParam("value");
        var selectEstSpecId=event.getSource().get("v.name");
        console.log('---selectEstSpecId-'+selectEstSpecId+'---selectOption--'+selectOption);
        
        switch (selectOption) {
                
            case 'Edit_EstSpec':                
                component.set('v.estSpecRecId',selectEstSpecId);
                component.set("v.isEstSpecOpen", true);               
                break;
                
            case 'Delete_EstSpec':
                helper.deleteEstSpec(component, event, helper, selectEstSpecId);
                break;
                
        }
    }
})