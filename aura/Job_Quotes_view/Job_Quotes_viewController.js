({
    doInit : function(component, event, helper) {       
        
        var checkPEpermisson=component.get("c.getQuotePermiossions");
        checkPEpermisson.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                console.log('---response.getReturnValue()----'+JSON.stringify(response.getReturnValue()));
                component.set("v.isAccess",response.getReturnValue());
                if(component.get("v.isAccess[2]")){
                    helper.fetchFieldLabels(component, event, helper);
                    helper.productiontempList(component, event, helper);
                }
                if(component.get("v.isAccess[5]")){
                     helper.getVendorforVendorQuote(component, event);
                }
            }
        });
        $A.enqueueAction(checkPEpermisson);             
        //helper.QuoteSpecsfetch(component, event);
        //helper.VendorQuotefetch(component, event);
       
        var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
        console.log('--isMobile'+isMobile);
        if(isMobile){
            component.set("v.isMobile",true);
        }
    },
    
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'Vendor_Approve':
                 if(component.get("v.isAccess[7]")){
                helper.Vendor_Approved(component, event, helper);
                 }else{
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": 'Vendor Quote has insufficient access to edit/update'
                    });   
                 }
                break;
            case 'Vendor_Delete':
                helper.Vendor_Delete(component, event, helper);
                break;
            case 'Print_Quote':
                var vfUrl = '/apex/PrintQuote?id=' + row.Id;
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": vfUrl
                });
                urlEvent.fire();
                break;
                
        }
    },
    
    handleRowSpecActions: function(component, event, helper) {
        var action=event.getParam('action');
        var row=event.getParam('row');
        switch(action.name){
            case 'Edit_Quote_Spec_Item':               
                if(component.get("v.isAccess[4]")==true){
                    component.set("v.ObjectApiName", "Quote_Spec_Item__c");
                    helper.getfieldsetvalues(component, "Quote_Spec_Item__c");
                    component.set("v.quoteRecordid", row.Id);
                    component.set("v.isOpen", true);
                }
                else{
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": 'Quote Spec Item has insufficient access to edit/update'
                    }); 
                }
               
                break;
            case 'Delete_Quote_Spec_Item':
                helper.deleteQuoteSpecItem(component, event, helper,row.Id);
        }
    },
    
    handleSelect: function(component, event, helper) {
        var MenuAction = event.getParam("value");
        var SpecRecId = event.getSource().get("v.value");
        if (MenuAction == "EditSpec") {
            var sobjname="Quote_Spec_Item__c";
            component.set("v.ObjectApiName", sobjname);
            helper.getfieldsetvalues(component, sobjname);
            component.set("v.quoteRecordid", SpecRecId);
            component.set("v.isOpen", true);
        } else {
            var DelSpecAction = component.get("c.deleteQuoteSpec");
            DelSpecAction.setParams({
                SpecRecId: SpecRecId
            });
            
            DelSpecAction.setCallback(this, function(DelSpecResponse) {
                console.log('===Dele spec Reuturn==' + DelSpecResponse.getReturnValue());
                if (DelSpecResponse.getState() === "SUCCESS") {
                    console.log('===Dele spec Reuturn==' + DelSpecResponse.getReturnValue());
                    helper.QuoteSpecsfetch(component, event);
                    
                    var DeleteSpecMsg = $A.get("e.force:showToast");
                    DeleteSpecMsg.setParams({
                        "type": "success",
                        "message": "Spec Item Deleted Successfully"
                        
                    });
                    DeleteSpecMsg.fire(); 
                }
            });
            $A.enqueueAction(DelSpecAction);
        }
    },
    
    updateColumnSorting: function(cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },
    
    updateColumnSortingforSpecs: function(cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortDataforSpecs(cmp, fieldName, sortDirection);
    },
    
    onQuotesSpecsSave: function(component, event, helper) {
        helper.saveDataTableofSpecs(component, event, helper);
    },
    
    onSave: function(component, event, helper) {
        helper.saveDataTable(component, event, helper);
    },
    
    ImportProductionTemp : function(component, event, helper) {
    helper.ImportProductionTempHelper(component, event, helper);
   },
    
    NewQuoteSpec: function(component, event, helper) {
        if(component.get("v.isAccess[3]")==true){
            var sobjname="Quote_Spec_Item__c";
            component.set("v.ObjectApiName", sobjname);
            helper.getfieldsetvalues(component, sobjname);
            setTimeout($A.getCallback(function () {
                component.set("v.isOpen", true);
            }), 1100);
        } else{
            helper.showToast({
                "title": "Error!!",
                "type": "error",
                "message": 'Quote Spec Item has insufficient access to create'
            }); 
        }
       
        
    },
    NewVendorQuote: function(component, event, helper) {
        if(component.get("v.isAccess[6]")){
            var sobjname="Vendor_Quote__c";
            component.set("v.ObjectApiName", sobjname);
            helper.getfieldsetvalues(component, sobjname);
            setTimeout($A.getCallback(function () {
                component.set("v.isOpen", true);
            }), 1100);
        } else{
            helper.showToast({
                "title": "Error!!",
                "type": "error",
                "message": 'Vendor Quote has insufficient access.'
            }); 
        }
    },
    closeModel: function(component, event, helper) {
        component.set("v.quoteRecordid", null);
        component.set("v.isOpen", false);
        component.set("v.ObjectApiName", null);
        setTimeout($A.getCallback(function () {
            component.set("v.fieldset", null);
        }), 1000);
        
        
    },
    QuoteSpecOnsubmit: function(component, event, helper) {
        event.preventDefault(); // Prevent default submit
        var Quotespecfields = event.getParam("fields");
        console.log('Quotespecfields===== '+JSON.stringify(Quotespecfields));
        Quotespecfields["Quote__c"] = component.get("v.recordId");
        var missField = "";
        var missField1 = "";
        var reduceReutrn = component.find('QuoteSpecField').reduce(function(validFields, inputCmp) {
            //console.log('inputcmp===='+inputcmp);
             console.log('reduceReutrn===='+reduceReutrn);
              //console.log('==JSON String====='+JSON.stringify(inputCmp.get("v.value")));    
            if (inputCmp.get("v.fieldName") == "Name") {
                var QuoteSpecName = inputCmp.get("v.value");
                if (QuoteSpecName == null || QuoteSpecName == '')
                    missField= "Spec Name";
            }
            else if (inputCmp.get("v.fieldName") == "Date__c") {
                var QuoteName1 = inputCmp.get("v.value");
                if (QuoteName1 == null || QuoteName1 == '')
                    missField1 = "Quote To Vendor";
            }
        }, true);
         console.log('reduceReutrn===='+reduceReutrn);
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
        if (missField == "Spec Name") {
            ToastMsg.fire();
            event.preventDefault();
        }
        else if(component.get("v.ObjectApiName")=="Vendor_Quote__c"){
            console.log("=====missField1====="+missField1);
            if(component.find("VendorId").get("v.value")=='null' || component.find("VendorId").get("v.value")=='' || component.find("VendorId").get("v.value")=='--None--' ){
                var ToastMsg5=$A.get("e.force:showToast");    
                ToastMsg5.setParams({
                    "title":"Vendor",
                    "type": "error",
                    "message":"Vendor Field is required."
                });   
                ToastMsg5.fire();
                event.preventDefault();   
            }
            else if (missField1 =="Quote To Vendor") {
                ToastMsg2.fire();
                event.preventDefault();
            }
                else{
                    Quotespecfields["Vendor__c"]=component.find("VendorId").get("v.value");
                    component.find("QuoteSpecEditform").submit(Quotespecfields);
                }
        }
            else{
                component.find("QuoteSpecEditform").submit(Quotespecfields);
            }
    },
    
    onQuoteSpecRecordSuccess: function(component, event, helper) {
        component.set("v.quoteRecordid", null);
        component.set("v.isOpen", false);
        var ToastMsg1 = $A.get("e.force:showToast");
        ToastMsg1.setParams({
            "title": "Sucess",
            "type": "success",
            "message": "Successfully Updated the Record"
            
        });
        ToastMsg1.fire();
        component.set("v.ObjectApiName", null);
        helper.QuoteSpecsfetch(component, event);
        helper.VendorQuotefetch(component, event);
    },
    
    //****mobile actions******/
    handleVdQuickAction : function(component, event, helper) { 
        var selectOption=event.getParam("value");
        var selectVendorId=event.getSource().get("v.name");
        console.log('---selectVendorId-'+selectVendorId+'---option--'+selectOption);
        if(selectOption=='Approve'){
            helper.Vendor_Approved(component, event, helper,selectVendorId);            
        }
        else if(selectOption=='Delete'){  
            helper.Vendor_Delete(component, event, helper,selectVendorId);
        }
            else{

                var vfUrl = '/one/one.app#/alohaRedirect/apex/PrintQuote?id=' +selectVendorId;
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": vfUrl
                });
                urlEvent.fire();
            }
    },
     
    /************** Mobile Action ******************************/
    
    handleSpecQuickAction : function(component, event, helper) {
        var selectOption=event.getParam("value");
        var selectQtSpeckId=event.getSource().get("v.name");
        console.log('---selectQtSpeckId-'+selectQtSpeckId+'---selectOption--'+selectOption);
        if(selectOption=='Edit'){
            component.set("v.ObjectApiName", "Quote_Spec_Item__c");
            helper.getfieldsetvalues(component, "Quote_Spec_Item__c");
            component.set("v.quoteRecordid",selectQtSpeckId);
            component.set("v.isOpen", true);
        }
        else {
          helper.deleteQuoteSpecItem(component, event, helper,selectQtSpeckId);
        } 
        
        
    }
})