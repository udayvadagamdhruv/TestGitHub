({
    init: function (cmp, event, helper) {
        helper.fetchCustomSettingData(cmp, event, helper);
        helper.fetchApprovedEstLI(cmp, event, helper);
        // present only written for the estimate line Line Items.Need to write Production Estimate.
        // Pro Estimate Total_Cost__c 
        // Estimate having Total_Amount__c remaing fields are same.
        var columns=[
            {label: 'Name', fieldName: 'Name', type: 'text',sortable: true},
            {label: 'GL Description', fieldName: 'GLCName', type: 'text',sortable: true},
            {label: 'Unit Type', fieldName: 'Unit_Type__c',  type: 'text',sortable: true,},
            {label: 'Quantity', fieldName: 'Quantity__c', type: 'number', sortable: true,cellAttributes: {alignment: 'left' }},
            {label: 'Total Cost', fieldName: 'TotalCost', type: 'currency',sortable: true,cellAttributes: {alignment: 'left' } }
        ];
       
        setTimeout($A.getCallback(function() {
            var showPE=cmp.get("v.ShowProductionEstimate");
            console.log('========showPE=========='+showPE);
            if(showPE){
                var newcol=columns.slice(0, 2).concat(columns.slice(2 + 1, columns.length))
                cmp.set('v.columns',newcol);
            }
            else{
                 cmp.set('v.columns',columns);
            }
        }),500);
       
        
        
    },
    
    updateColumnSorting : function(cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    }, 
    
    updateSelectedText: function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');
          console.log('==========='+JSON.stringify(selectedRows));
        cmp.set('v.selectedRowsCount', selectedRows.length);
        console.log('==========='+typeof(selectedRows));
        var vendorselect=cmp.getEvent("ChangdVendorApproveList");
        vendorselect.setParams({
            "ApprovedItems" :selectedRows
        });
        vendorselect.fire();
    },
    
    
    
    VendorChangeAction: function (cmp, event, helper){
        console.log('=======VendorChangeAction=======');
        var Parmas=event.getParam('arguments');
        if(Parmas){
            cmp.set("v.VendorId",Parmas.venId);
            helper.fetchApprovedEstLI(cmp, event, helper);  
        }
    }
})