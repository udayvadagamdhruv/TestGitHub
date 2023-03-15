({
    doInit : function(component, event, helper) {
        
        
        var ClientInvAccess = component.get("c.getisAccessable");
        ClientInvAccess.setCallback(this, function(response) {
            console.log('>>>>>>>>>DoInit>>>>>>>>'+response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                component.set("v.CntInvLIAccess",response.getReturnValue());
                var ClientInvLIAcc=component.get("v.CntInvLIAccess[1]");
                var ClientInvLIAllocAcc=component.get("v.CntInvLIAccess[2]");
                console.log('>>>>>>>>>DoInit>>>>>>>>'+ClientInvLIAcc);
                if(ClientInvLIAcc==true){
                    helper.fetchInvALI(component, event, helper, ClientInvLIAcc, ClientInvLIAllocAcc);
                }
                if(ClientInvLIAllocAcc==true){
                    helper.getInvALITemp(component, event, helper);
                }
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        
        $A.enqueueAction(ClientInvAccess);
        
        helper.ShowProductionEstimate(component, event);
        // var rowActions = helper.getRowActions.bind(this, component);
        //  var CLInvLIrowActions = helper.getCLInvLIRowActions.bind(this, component);
        
        helper.getClient(component, event, helper);
        helper.getFieldLabels(component, event, helper);
        var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
        component.set("v.isMobile",isMobile);
    },
    
    updateSelectedText: function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        console.log('>>>>selected Rows>>>>>'+JSON.stringify(selectedRows));
        cmp.set('v.selectedRowsCount', selectedRows.length);
        cmp.set('v.Selected_ESTLI', selectedRows);
    },   
    
    
    
    handleRowAction: function(component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'Delete_InvALI':
                helper.deleteInvALI(component, event, helper);
                break;
        }
    },
    
    
    CLInvLIhandleRowAction: function(component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'Delete_CLInvLI':
                helper.deleteCLInvLI(component, event, helper);
                break;     
        }
    },
    
    /* recordsUpdateforchanges: function (cmp, event, helper) {
        // alert('fireing in Client Invoice section after records delete and insert');
        helper.fetchInvALI(cmp, event, helper);
    },*/
    
    // Sorting the Invoice Allocation section table
    updateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },
    
    // Sorting the Invoice Line Items section table
    CLIupdateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.CLINVLIsortedBy", fieldName);
        cmp.set("v.CLINVLIsortedDirection", sortDirection);
        helper.CLInvLIsortData(cmp, fieldName, sortDirection);
    },
    
    // Sorting the Add Invoice Line Items table
    AddCLIupdateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.AddCLINVLIsortedBy", fieldName);
        cmp.set("v.AddCLINVLIsortedDirection", sortDirection);
        helper.AddCLInvLIsortData(cmp, fieldName, sortDirection);
    },
    
    // Inline Edit save for Invoice Allocation Item
    onSave : function (component, event, helper) {
        helper.saveDataTable(component, event, helper);
    },
    // Inline Edit save for Invoice Line Item
    onSaveCLInvLI : function (component, event, helper) {
        helper.CLInvLIsaveDataTable(component, event, helper);
    },
    // Save the selected items from Add Invoice Line items button        
    saveSelectedItems :function (component, event, helper) {
        var items=component.get('v.Selected_ESTLI');
        if(items==null || items==''){
            
            var ToastMsg = $A.get("e.force:showToast");
            ToastMsg.setParams({
                "type": "error",
                "message": "There are are no Items to add for the Client Invoice."
            })
            ToastMsg.fire();                
        }
        else{
            helper.selectedEstLI_PELI(component, event, helper);
            helper.reloadDataTable();
        }
    }, 
    
    // Create a Invoice Allocation
    CreateInvALIRecord:function (component, event, helper) {
        component.set("v.isInvALIOpen", true);
    },
    
    // Create Invoice Line Item
    CreateCLInvLIRecord:function (component, event, helper) {
        component.set("v.isaddClick", true);
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.isInvALIOpen", false);
        component.set('v.InvALIRecordid', null);
    },
    
    closeModelForCLInvLI: function(component, event, helper) {
        component.set("v.isaddClick", false);
        component.set('v.selectedRowsCount', null);
    },
    
    ImportTemplate:function(component, event, helper) {
        
        var importaction = component.get("c.importIATLI");
        var ToastMsg=$A.get("e.force:showToast");
        console.log('=recid=='+component.get("v.recordId"));
        importaction.setParams({
            CLIid: component.get("v.recordId"),
            selectedInvAllocationTemp:component.find("InvALITempSelectId").get("v.value")
        });
        
        importaction.setCallback(this, function(res) {
            console.log('==== ImportTemplate before=='+ res.getReturnValue());
            var state11 = res.getState();
            if (state11 === "SUCCESS" ){
                if(res.getReturnValue()==="Sucessfully Imported Client Invoice Allocation records") {
                    console.log('====ImportTemplate  sucess=='+ res.getReturnValue());
                    ToastMsg.setParams({
                        "title":"Import Jobs",
                        "type": "success",
                        "message":  res.getReturnValue()
                        
                    });
                    var ClientInvLIAcc=component.get("v.CntInvLIAccess[1]");
                    var ClientInvLIAllocAcc=component.get("v.CntInvLIAccess[2]");
                    helper.fetchInvALI(component, event, helper, ClientInvLIAcc, ClientInvLIAllocAcc);
                    ToastMsg.fire();
                    component.find("InvALITempSelectId").set("v.value",null);
                }
                else{
                    ToastMsg.setParams({
                        "title":"Import Jobs",
                        "type": "error",
                        "message": res.getReturnValue()
                    });
                    ToastMsg.fire();
                }
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',res.getError());
                var errors = res.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
            
            
        });
        $A.enqueueAction(importaction); 
    },
    
    InvALIOnsubmit : function(component, event, helper) {
        event.preventDefault(); // Prevent default submit
        var InvALIfields = event.getParam("fields");
        console.log('===Submit====='+component.get("v.recordId"));
        InvALIfields["Client_Invoice__c"]=component.get("v.recordId");
        InvALIfields["Client_Name__c"]=component.find("ClientId").get("v.value");
        InvALIfields["Allocation_Qty__c"]=component.find("InvALItems").get("v.value");
        
        console.log('===Submit Client Name====='+component.get("v.simpleRecord.Client_Name__c"));
        console.log('===Allocation_Qty ====='+component.find("InvALItems").get("v.value"));
        /*        var reduceReutrn = component.find('InvALItems').reduce(function(validFields, inputCmp) {   
        }
                                                                , true);*/
        
        component.find("InvALIEditform").submit(InvALIfields);
        //console.log('===form InvALIfields==='+JSON.stringify(InvALIfields));
        
    },
    
    InvALIRecordSuccess: function(component, event, helper) { 
        var InvALIId=component.get('v.InvALIRecordid');
        var msg;
        if(InvALIId=='undefined' || InvALIId==null ){
            msg='Successfully Inserted Invoice Allocation Items Record';
        }
        else{
            msg='Successfully Updated Invoice Allocation Items Record';
        }
        console.log('===record Success==='+InvALIId);
        var ToastMsg11 = $A.get("e.force:showToast");
        ToastMsg11.setParams({
            "title": "Sucess",
            "type": "success",
            "message":msg
            
        });
        
        setTimeout($A.getCallback(function () {
            component.set('v.InvALIRecordid',null);
            component.set("v.isInvALIOpen", false);
            var ClientInvLIAcc=component.get("v.CntInvLIAccess[1]");
            var ClientInvLIAllocAcc=component.get("v.CntInvLIAccess[2]");
            helper.fetchInvALI(component, event, helper, ClientInvLIAcc, ClientInvLIAllocAcc);
        }), 2000);
        ToastMsg11.fire();
    },
    
    InvALIload:  function(component, event, helper) { 
        console.log('===record Load===');
        var recId=component.get("v.InvALIRecordid");
        console.log('===Recordid after==='+recId); 
        
        if(recId!=null){
            console.log('===Recordid 33333 after==='+recId);    
            var InvALIfilds = event.getParam("recordUi");
            // helper.CreateInvALIRecord(component, event, helper); 
            //   helper.getClient(component, event, helper);
            console.clear();
            setTimeout($A.getCallback(function() {
                var clientIdCmp = component.find("ClientId");
                console.log("-----clientIdCmp---"+JSON.stringify(clientIdCmp));
                var isarray = Array.isArray(clientIdCmp);
                if(isarray === true ){
                    console.log("---it might be second time--");
                    var allValid = clientIdCmp.reduce(function (validFields, inputCmp) {
                        inputCmp.set("v.value", InvALIfilds.record.fields.Client_Name__c.value);
                    }, true);
                }else{
                    console.log("---it might be firstTime time--");                    
                    clientIdCmp.set("v.value", InvALIfilds.record.fields.Client_Name__c.value);
                    console.log('==client=='+component.find("ClientId").get("v.value"));
                }
            }), 2000);
        }
    } 
})