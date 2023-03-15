({
    getColumnDefinitionsForMIUI: function(component, event, helper){
        var rowActions = helper.getRowActionsForMIUItems.bind(this, component);
        var Objaction = component.get( "c.getObjectType" );
        Objaction.setParams({
            ObjNames : 'Material_Usage_line_item__c'
        }); 
        Objaction.setCallback(helper, function( response ) {
            console.log('======response======='+response.getState());
            console.log('======response======='+JSON.stringify(JSON.parse(response.getReturnValue())));
            if(component.isValid() && response.getState() === 'SUCCESS' ) {
                var tableHeader=JSON.parse(response.getReturnValue());
                var columns=[
                    //{label: 'Created Date', fieldName: 'CreatedDate', type: 'date-local', sortable: true},
                    { type: 'action', typeAttributes: { rowActions: rowActions } },
                    {label: tableHeader.Material_Usage_line_item__c.Date__c.label, fieldName: 'Date__c', type: 'date-local', sortable: true, initialWidth: 150},
                    {label: tableHeader.Material_Usage_line_item__c.Type__c.label, fieldName: 'Type__c', type: 'text', sortable: true, initialWidth: 250},
                    {label: tableHeader.Material_Usage_line_item__c.Description__c.label, fieldName: 'Description__c', type: 'text', sortable: true},
                    {label: tableHeader.Material_Usage_line_item__c.Debit__c.label, fieldName: 'Debit__c', type: 'number', sortable: true, initialWidth:150,cellAttributes: { alignment: 'left'}},
                    {label: tableHeader.Material_Usage_line_item__c.Credit__c.label, fieldName: 'Credit__c', type: 'number', sortable: true, initialWidth:150,cellAttributes: { alignment: 'left'}},
                    {label: tableHeader.Material_Usage_line_item__c.Qty_On_Hand__c.label, fieldName: 'Qty_On_Hand__c', type: 'number', sortable: true, initialWidth:150,cellAttributes: { alignment: 'left'}}
                ];
                component.set('v.MIUIColumns',columns);  
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Material Usage line item has '+errors[0].message
                }); 
            }
        });
        $A.enqueueAction(Objaction);
    },
    
    getColumnDefinitionsMIInv: function(component, event, helper){
        var rowActions = helper.getRowActionsForMInv.bind(this, component);
        var Objaction = component.get( "c.getObjectType" );
        Objaction.setParams({
            ObjNames : 'Material_Inventory_Item__c'
        }); 
        Objaction.setCallback(helper, function( response ) {
            console.log('======response======='+response.getState());
            console.log('======response======='+JSON.stringify(JSON.parse(response.getReturnValue())));
            if(component.isValid() && response.getState() === 'SUCCESS' ) {
                var tableHeader=JSON.parse(response.getReturnValue());
                var columns=[
                    { type: 'action', typeAttributes: { rowActions: rowActions } },
                    {label: tableHeader.Material_Inventory_Item__c.Name.label, fieldName: 'Name', type: 'text', sortable: true},
                    {label: tableHeader.Material_Inventory_Item__c.Inventory_Date__c.label, fieldName: 'Inventory_Date__c', type: 'date-local', sortable: true},
                    {label: tableHeader.Material_Inventory_Item__c.Mfg_Item_Number__c.label, fieldName: 'Mfg_Item_Number__c', type: 'text', sortable: true,cellAttributes: { alignment: 'left' }},
                    {label: tableHeader.Material_Inventory_Item__c.Qty_On_Shelf__c.label, fieldName: 'Qty_On_Shelf__c', type: 'number', sortable: true,cellAttributes: { alignment: 'left' } }
                ];
                component.set('v.MInvColumns',columns);  
            }
             else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Material Inventory Item has '+errors[0].message
                }); 
            }
        });
        $A.enqueueAction(Objaction);  
    },
    
    fetchFieldSet:  function(component, event, helper){
        var actionToday=component.get("c.gettodaydate");
        actionToday.setCallback(this,function(response){
            console.log("=====today()====", response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                component.set("v.today",response.getReturnValue()); 
            }
             else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Material Inventory Item has '+errors[0].message
                }); 
            }
        });
        var actionMIUI = component.get("c.getFieldsforObject");
        actionMIUI.setParams({
            sObjName : "Material_Usage_line_item__c"
        });
        actionMIUI.setCallback(this, function(res) {
            console.log("=====Field set for Materail Usage Line Items====", res.getReturnValue());
            if (res.getState() === "SUCCESS") {
                component.set("v.MIUIFieldSet",res.getReturnValue()); 
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',res.getError()[0].message);
                var errors = res.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Material Usage line item has '+errors[0].message
                }); 
            }
        });
        var actionMInv = component.get("c.getFieldsforObject");
        actionMInv.setParams({
            sObjName : "Material_Inventory_Item__c"
        });
        actionMInv.setCallback(this, function(res) {
            console.log("=====Field set for Materail Inventory====", res.getReturnValue());
            if (res.getState() === "SUCCESS") {
                component.set("v.MInvFieldSet",res.getReturnValue()); 
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',res.getError()[0].message);
                var errors = res.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Material Inventory Item has '+errors[0].message
                }); 
            }
        });
        $A.enqueueAction(actionMIUI);
        $A.enqueueAction(actionMInv);
        $A.enqueueAction(actionToday);
    },
    
    getRowActionsForMIUItems: function (component, row, doneCallback) {
        console.log('===row='+row);
        console.log('====rowsss==='+JSON.stringify(row));
        var actions = [];
        var deleteAction = {
            'label': 'Delete',
            'iconName': 'action:delete',
            'name': 'Delete_MIUI',
            'disabled':row.rowIndexNo!=0
        };
        actions.push(deleteAction);
        setTimeout($A.getCallback(function () {
            doneCallback(actions);
        }), 200);
    },
    
    getRowActionsForMInv : function (component, row, doneCallback) {
        console.log('===row='+row);
        console.log('====rowsss==='+JSON.stringify(row));
        var actions = [];
        var deleteAction = {
            'label': 'Delete',
            'iconName': 'action:delete',
            'name': 'Delete_MUInv'
        };
        actions.push(deleteAction);
        setTimeout($A.getCallback(function () {
            doneCallback(actions);
        }), 200);
    },
    
    fetchMaterialUsageItems : function(component, event, helper) {
        var recordId=component.get("v.recordId");
        var action=component.get("c.getMaterialUsageItems");
        action.setParams({
            MItemId:recordId
        });
        action.setCallback(this, function(res){
            console.log('====MaterialUsageItems Records==='+JSON.stringify(res.getReturnValue()));
            if(res.getState()==="SUCCESS"){
                var rows=res.getReturnValue();
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    row.rowIndexNo=i;
                }
                component.set("v.MaterialUsageItems",rows);
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',res.getError()[0].message);
                var errors = res.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Material Usage Item has '+errors[0].message
                }); 
            }
            
        });
        $A.enqueueAction(action);
    },
    
    updateMaterailItemQtyOnHandField :function(component, event, helper) {
        var action=component.get("c.updateMaterailItemQtyOnHandField");
        action.setParams({
            MItemId:component.get("v.recordId")
        });
        action.setCallback(this, function(res){
            console.log('====MaterialUsageItems Records==='+JSON.stringify(res.getReturnValue()));
            if(res.getState()==="SUCCESS"){
                if(res.getReturnValue()=="OK"){
                    /*   helper.showToast({
                        "type":"success",
                        "message":'Material Item Qty On Hand Field Updated Successfully.'
                    }); */
                    helper.reloadData(); 
                }
                else{
                    helper.showToast({
                        "title":"Error!!",
                        "type":"error",
                        "message":res.getReturnValue()
                    }); 
                }
            }
             else {
                console.log('>>>>>> Error >>>>>>>>>>',res.getError()[0].message);
                var errors = res.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Material Usage Item has '+errors[0].message
                }); 
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchMaterialInventory : function(component, event, helper) {
        var recordId=component.get("v.recordId");
        var action=component.get("c.getMaterialInventory");
        action.setParams({
            MItemId:recordId
        });
        action.setCallback(this, function(res){
            console.log('====MaterialInventory Records==='+JSON.stringify(res.getReturnValue()));
            if(res.getState()==="SUCCESS"){
                component.set("v.MaterialInventory",res.getReturnValue());
            }
             else {
                console.log('>>>>>> Error >>>>>>>>>>',res.getError()[0].message);
                var errors = res.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Material Inventory Item has '+errors[0].message
                }); 
            }
        });
        $A.enqueueAction(action);
    },
    
    deleteMaterialUsageLineItem :function(component, event, helper,MIUIId){
        var action=component.get("c.deleteMIUsageItem");
        action.setParams({
            MIUIId:MIUIId,
            MItemId:component.get("v.recordId")
        });
        action.setCallback(this, function(res){
            console.log('====Delete response MIUI==='+JSON.stringify(res.getReturnValue()));
            if(res.getState()==="SUCCESS"){
                if(res.getReturnValue()=="OK"){
                    helper.showToast({
                        "type":"success",
                        "message":'Record Deleted Successfully.'
                    });
                    helper.fetchMaterialUsageItems(component, event, helper);
                    helper.reloadData();
                }
                else{
                    helper.showToast({
                        "title":"Error!!",
                        "type":"error",
                        "message":res.getReturnValue()
                    }); 
                }
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',res.getError()[0].message);
                var errors = res.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Material Usage Line Item has '+errors[0].message
                }); 
            }
            
        });
        $A.enqueueAction(action);
    },
    
    deleteMaterialInventory :function(component, event, helper,MInvItemId){
        var action=component.get("c.deleteMInventoryItem");
        action.setParams({
            MInvItemId:MInvItemId
        });
        action.setCallback(this, function(res){
            console.log('====Delete response MINventory===='+JSON.stringify(res.getReturnValue()));
            if(res.getState()==="SUCCESS"){
                if(res.getReturnValue()=="OK"){
                    helper.showToast({
                        "type":"success",
                        "message":'Record Deleted Successfully.'
                    });
                    helper.fetchMaterialInventory(component, event, helper);
                    helper.reloadData();
                }
                else{
                    helper.showToast({
                        "title":"Error!!",
                        "type":"error",
                        "message":res.getReturnValue()
                    }); 
                }
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',res.getError()[0].message);
                var errors = res.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Material Inventory Item has '+errors[0].message
                }); 
            }
        });
        $A.enqueueAction(action);
    },
    
    
    
    showToast:function(params){
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams(params);
            toastEvent.fire();  
        }
        else{
            alert(params.message);
        }
    },
    
    reloadData :function(){
        var refreshEvent=$A.get("e.force:refreshView");
        if(refreshEvent){
            refreshEvent.fire();
        }
    },
    
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.MaterialUsageItems");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.MaterialUsageItems", data);
    },
    sortDataMInv : function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.MaterialInventory");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.MaterialInventory", data);
    },
    
    sortBy: function (field, reverse, primer) {
        console.log('==sortBy=primer==='+primer);
        console.log('==sortBy=field==='+field);
        console.log('==sortBy=reverse==='+reverse);
        var key = primer ?
            function(x) {return primer(x[field])} :
        function(x) {return x[field]};
        //checks if the two rows should switch places
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
})