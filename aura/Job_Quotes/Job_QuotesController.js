({
    doInit : function(component, event, helper) {
        var checkCreate=component.get("c.getQuotePermiossions");
        checkCreate.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                console.log('---response.getReturnValue()----'+JSON.stringify(response.getReturnValue()));
                component.set("v.isAccess",response.getReturnValue());
            }
        });
        $A.enqueueAction(checkCreate);
        helper.fetchJobQuotes(component, event, helper);
        helper.CreateQuoteRecord(component, event, helper); 
        helper.getGLDepartment(component, event, helper);
        //helper.reloadDataTable();
        helper.getFieldLabels(component, event, helper);
        var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
        console.log('--isMobile'+isMobile);
        if(isMobile){
            component.set("v.isMobile",true);
        }
    },
    
    NagivatetoQuoteSection:function(component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.jobrecordId"),
            "slideDevName": "related"
        });
        
        navEvt.fire();
    },
    
    handleRowAction: function(component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'Edit_Quote':
                if(component.get("v.isAccess[1]")==true){
                    component.set("v.isOpen", true);
                    component.set('v.quoteRecordid', row.Id);
                }
                else{
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": 'Quote has insufficient access to edit/update'
                    }); 
                }
                break;
            case 'Delete_Quote':
                helper.deleteJobQuote(component, event, helper);
                break;
            case 'UnApprv_Quote':
                helper.unApporveQuote(component, event, helper);
                break;
        }
    },
    
    recordsUpdateforchanges: function (cmp, event, helper) {
        // alert('fireing in estimate section after records delete and insert');
        helper.fetchJobQuotes(component, event, helper);
    },
    
    updateColumnSorting: function(cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },
    
    onSave: function(component, event, helper) {
        alert('working');
        helper.saveDataTable(component, event, helper);
    },
    
    QuoteCreate: function(component, event, helper) {  
        
        if(component.get("v.isAccess[0]")==true){
            component.set("v.isOpen", true);
        } else{
            helper.showToast({
                "title": "Error!!",
                "type": "error",
                "message": 'Quote has insufficient access to create'
            }); 
        }
        
    },
    
    GLDepatment: function(component, event, helper) {
        helper.getGLCode(component, event);
    },
    
    closeModel: function(component, event, helper) {
        //component.set("v.isErrorOcuur", false);
        // component.set("v.erorrMsg", '');
        component.set("v.isOpen", false);
        component.set('v.quoteRecordid', null);
        component.set("v.selectedLookUpRecord_GLD",{"Id":null, "Name":null});
        component.set("v.selectedLookUpRecord_GLC",{"Id":null, "Name":null});
        
    },
    
    jobQuoteOnsubmit: function(component, event, helper) {
       // alert('submit');
        event.preventDefault(); // Prevent default submit
        var Quotefields = event.getParam("fields");
        Quotefields["Job__c"] = component.get("v.jobrecordId");
        var missField = "";
        var missField1 = "";
        var reduceReutrn = component.find('JobQuoteField').reduce(function(validFields, inputCmp) {
            if (inputCmp.get("v.fieldName") == "Name") {
                var QuoteName = inputCmp.get("v.value");
                if (QuoteName == null || QuoteName == '')
                    missField = "Quote Name";
                
            } else if (inputCmp.get("v.fieldName") == "Quantity__c") {
                var QuoteName1 = inputCmp.get("v.value");
                if (QuoteName1 == null || QuoteName1 == '')
                    missField1 = "Quantity";
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
        if (missField == "Quote Name") {
            //component.set("v.isErrorOcuur", true);
            //component.set("v.erorrMsg", 'Name Field is Required');
            ToastMsg.fire();
            event.preventDefault();
        } else if (missField1 == "Quantity") {
            //component.set("v.isErrorOcuur", true);
            // component.set("v.erorrMsg", 'Quantity Field is Required');
            ToastMsg2.fire();
            event.preventDefault();
        } else if(component.get("v.selectedLookUpRecord_GLD").Id==null) {
            //component.set("v.isErrorOcuur", true);
            //component.set("v.erorrMsg", 'GL Depatment Field is Required');
            var ToastMsg3 = $A.get("e.force:showToast");
            ToastMsg3.setParams({
                "title": "GL Depatment",
                "type": "error",
                "message": "GL Depatment Field is required."
            });
            ToastMsg3.fire();
            event.preventDefault();
        } else if(component.get("v.selectedLookUpRecord_GLC").Id==null) {
            //component.set("v.isErrorOcuur", true);
            //component.set("v.erorrMsg", 'GL Code Field is Required');
            var ToastMsg4 = $A.get("e.force:showToast");
            ToastMsg4.setParams({
                "title": "GLCode",
                "type": "error",
                "message": "GLCode Field is required."
            });
            ToastMsg4.fire();
            event.preventDefault();
        } else {
            if(component.get("v.selectedLookUpRecord_GLD").Id==null){
                Quotefields["GL_Department__c"]="";
            }
            else{
                Quotefields["GL_Department__c"]=component.get("v.selectedLookUpRecord_GLD").Id;  
            }
            if(component.get("v.selectedLookUpRecord_GLC").Id==null){
                Quotefields["GL_Code__c"]="";
            } 
            else{
                Quotefields["GL_Code__c"]=component.get("v.selectedLookUpRecord_GLC").Id;
            }
            //alert('working');
          //  alert(JSON.stringify(Quotefields));
            component.find("JobQuoteEditform").submit(Quotefields);
        }
    },
    onQuoteRecordSuccess: function(component, event, helper) {
        // component.set("v.isOpen", false);
        //component.set("v.isErrorOcuur", false);
        //component.set("v.erorrMsg", '');
        
        var QuoteId=component.get('v.quoteRecordid');
        var msg;
        if(QuoteId=='undefined' || QuoteId==null ){
            msg='Successfully Inserted Quote Record';
            
            var newQuoteid = event.getParams().response.id;
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": newQuoteid,
            });
            navEvt.fire();
        }
        else{
            msg='Successfully Updated Quote Record';
        }
        
        var ToastMsg1 = $A.get("e.force:showToast");
        ToastMsg1.setParams({
            "title": "Success",
            "type": "success",
            "message":msg
        });
        // setTimeout($A.getCallback(function() {
        helper.fetchJobQuotes(component, event, helper);
        component.set('v.quoteRecordid', null);
        component.set("v.isOpen", false);
        component.set("v.selectedLookUpRecord_GLD",{"Id":null, "Name":null});
        component.set("v.selectedLookUpRecord_GLC",{"Id":null, "Name":null});
        // }), 500);
        ToastMsg1.fire();
    },
    jobQuoteload: function(component, event, helper) {
        console.log('===record Load===');
         // alert('onload');
        var recId = component.get("v.quoteRecordid");
        if (recId != null) {
            var quotefilds = event.getParam("recordUi");
            // alert('onload quotefields '+JSON.stringify(quotefilds));
            console.log('The quotefilds========== '+quotefilds);
            if(quotefilds.record.fields.GL_Department__c.value!=null){
                var GLDObj={"Id":quotefilds.record.fields.GL_Department__r.value.fields.Id.value, "Name":quotefilds.record.fields.GL_Department__r.value.fields.Name.value};
                var GLCObj={"Id":quotefilds.record.fields.GL_Code__r.value.fields.Id.value, "Name":quotefilds.record.fields.GL_Code__r.value.fields.Name.value};
                component.find("GLD_GLC_AuraId").sampleMethod(GLDObj,GLCObj);
            }
        }
        
    },
    /************** Mobile Action ******************************/
    
    handleQtQuickAction : function(component, event, helper) {
        var selectOption=event.getParam("value");
        var selectQtkId=event.getSource().get("v.name");
        console.log('---selectQtkId-'+selectQtkId+'---selectOption--'+selectOption);
        if(selectOption=='Edit'){
            component.set("v.isOpen", true);
            component.set('v.quoteRecordid',selectQtkId);
        }
        else if(selectOption=='Delete'){ 
            helper.deleteJobQuote(component, event, helper,selectQtkId);
        } else{
            helper.unApporveQuote(component, event, helper,selectQtkId); 
        }
        
        
    }
    
})