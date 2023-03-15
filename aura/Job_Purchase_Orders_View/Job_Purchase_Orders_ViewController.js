({
    doInit : function(component, event, helper) {
        var checkPEpermisson=component.get("c.getPOPermiossions");
        checkPEpermisson.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                console.log('---response.getReturnValue()----'+JSON.stringify(response.getReturnValue()));
                component.set("v.isAccess",response.getReturnValue());
                if(component.get("v.isAccess[3]")){
                    var rowActions = helper.getRowActions.bind(this, component);
                    helper.ShowProductionEstimate(component, event);
                    helper.POlineItemfetch(component, event);
                    // component.find("AVELIDPOVIEW").vendorchangefiremethod(component.get("v.simpleRecord.Vendor__c"));
                    // politems=[select id,Name,Purchase_Order__c,Estimate_Line_Item__c,Estimate_Line_Item__r.name,Amount__c,Invoice_Created__c,GL_Code__c,Quantity_production__c,Unit_Type__c,Quantity__c,Production_Estimate__c from PO_Line_Item__c where Purchase_Order__c =: POId ORDER BY Name];
                    var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
                    console.log('--isMobile'+isMobile);
                    if(isMobile){
                        component.set("v.isMobile",true);
                    }
                    
                    var columns=[
                        { type: 'action', typeAttributes: { rowActions: rowActions }},
                        {label: 'Line Item', fieldName: 'ItemLink',sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'Name'}, target: '_self' }},
                        {label: 'GL Description', fieldName: 'GLDLink',sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'GLDName' }, target: '_self' }},
                        {label: 'Unit Type', fieldName: 'Unit_Type__c',  sortable: true , type:'text'},
                        {label: 'Quantity', fieldName: 'Quantity', sortable: true, type: 'number',cellAttributes: {alignment: 'left' }},
                        {label: 'Amount', fieldName: 'Amount__c',  sortable: true, type: 'currency',cellAttributes: {alignment: 'left' }},
                        {label: 'Invoice Created', fieldName: 'Invoice_Created__c',  sortable: true, type: 'boolean'}
                    ]; 
                    
                    setTimeout($A.getCallback(function() {
                        var showPE=component.get("v.ShowProductionEstimate");
                        console.log('========showPE=========='+showPE);
                        if(showPE){
                            var newcol=columns.slice(0, 2).concat(columns.slice(2 + 1, columns.length))
                            component.set('v.columns',newcol);
                        }
                        else{
                            component.set('v.columns',columns);
                        }
                    }),500);
                }               
            }
        });
        $A.enqueueAction(checkPEpermisson);   
        
        
        
    },
    
    
    
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        if(action.name=="Delete_POLI") {
            helper.deletePOLineItem(component, event, helper);
        }
            
    },
    
     handleselectedRecord :function(component, event, helper) {
        var slecteESLI=event.getParam("ApprovedItems");
        console.log('=====selected Estimate Record==='+slecteESLI);
        component.set("v.Selected_ESTLI",slecteESLI);
        
    },
    
    addLineItems: function (component, event, helper) {
        //var showPE = component.get("v.ShowProductionEstimate");
        if(component.get("v.isAccess[4]")){
            component.set("v.isaddClick",true);
        }else {               
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!!",
                "type": "error",
                "message":'PO Line Item has insufficient access to create.'
            });
            toastEvent.fire();
            
        }
    },
    
    saveSelectedItems :function (component, event, helper) {
        var items=component.get('v.Selected_ESTLI');
        if(items==null || items==''){
            
            var ToastMsg = $A.get("e.force:showToast");
            ToastMsg.setParams({
                "type": "error",
                "message": "There are are no Items to add for the Purchase Order."
            })
            ToastMsg.fire();                
        }
        else{
            helper.selectedEstLI_PELI(component, event, helper);
        }
    },
    
     closeModel: function(component, event, helper) {
        component.set("v.isaddClick",false);  
    },
    
   updateColumnSorting: function(cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    }, 
})