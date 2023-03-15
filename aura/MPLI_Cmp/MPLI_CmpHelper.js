({
    getFieldLabels :  function(component, event, helper){
        var rowActions = helper.getRowActions.bind(this, component);
         var rowActionsReceipt = helper.getRowActionsReceipt.bind(this, component);
        var Objaction = component.get( "c.getObjectType" );
        Objaction.setParams({
            ObjNames : ['Material_Purchase_Line_Item__c','Material_Order_Line_Item_Receipt__c']
        }); 
        Objaction.setCallback( helper, function( response ) {
            console.log('>>>>>> Enter >>>>>>>>>>');
            if(response.getState() === 'SUCCESS' ) {
                var tableHeaders=JSON.parse(response.getReturnValue());
                component.set("v.ObjectType", JSON.parse( response.getReturnValue()));
                //alert('>>>>>> Result of labels >>>>>>>>>>'+JSON.stringify(JSON.parse( response.getReturnValue()))); 
                component.set('v.columns', [
                    {type: 'action', typeAttributes: {rowActions: rowActions}},
                    {label: tableHeaders.Material_Purchase_Line_Item__c.Name.label, fieldName: 'ProEstLink',  type: 'url', sortable: true,  typeAttributes: { label: { fieldName: 'Name' }, target: '_self', tooltip :{ fieldName: 'Name' }} },
                    {label: tableHeaders.Material_Purchase_Line_Item__c.Material_Order__c.label, fieldName: 'Material_Order__c', sortable: true, type: 'text',initialWidth:200},
                    {label: tableHeaders.Material_Purchase_Line_Item__c.Material_Item__c.label, fieldName: 'MaterialItemLink', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'MTIL' }, target: '_self', tooltip :{ fieldName: 'MTIL' }} },
                    {label: tableHeaders.Material_Purchase_Line_Item__c.Calc_Unit__c.label, fieldName: 'Calc_Unit__c',sortable: true, type: 'text',initialWidth:150 },
                    {label: tableHeaders.Material_Purchase_Line_Item__c.MPLI_Status__c.label, fieldName: 'MPLI_Status__c',sortable: true, type: 'text',initialWidth:150 },
                    {label: tableHeaders.Material_Purchase_Line_Item__c.Qty__c.label, fieldName: 'Qty__c',  sortable: true, type: 'Number',initialWidth:200 },
                 {label: tableHeaders.Material_Purchase_Line_Item__c.Qty_Outstanding__c.label, fieldName: 'Qty_Outstanding__c',  sortable: true, type: 'Number',initialWidth:200 }

                    
                ]);
                var labels = {
                    'Name':tableHeaders.Material_Purchase_Line_Item__c.Name.label,
                    'Vendor':tableHeaders.Material_Purchase_Line_Item__c.Material_Order__c.label,
                    'IssueDate': tableHeaders.Material_Purchase_Line_Item__c.Material_Item__c.label,
                    'DueDate':tableHeaders.Material_Purchase_Line_Item__c.Calc_Unit__c.label,
                    'Status':tableHeaders.Material_Purchase_Line_Item__c.MPLI_Status__c.label,
                    'Qty':tableHeaders.Material_Purchase_Line_Item__c.Qty__c.label,
                     'Qty Outstanding':tableHeaders.Material_Purchase_Line_Item__c.Qty_Outstanding__c.label
                };
                component.set('v.DynamicLabels',labels);
                console.log('-----labels--'+JSON.stringify(labels));
                
                component.set('v.MOLIReceiptcolumns', [
                    {type: 'action', typeAttributes: {rowActions : rowActionsReceipt}},
                    {label: tableHeaders.Material_Order_Line_Item_Receipt__c.Name.label, fieldName: 'ProEstLink',  type: 'url', sortable: true, initialWidth:220, typeAttributes: { label: { fieldName: 'Name' }, target: '_self', tooltip :{ fieldName: 'Name' }} },
         {label: tableHeaders.Material_Order_Line_Item_Receipt__c.Material_Purchase_Line_Item__c.label, fieldName: 'Material_Purchase_Line_Item__c',sortable: true, type: 'text',initialWidth:220 },
         {label: tableHeaders.Material_Order_Line_Item_Receipt__c.MOLI_Receipt_Qty__c.label, fieldName: 'MOLI_Receipt_Qty__c',sortable: true, type: 'text',initialWidth:220 },
        {label: tableHeaders.Material_Order_Line_Item_Receipt__c.MPLI_Receipt_Status__c.label, fieldName: 'MPLI_Receipt_Status__c',sortable: true, type: 'text',initialWidth:220 }
                ]);
                var labels = {
                    'Name':tableHeaders.Material_Order_Line_Item_Receipt__c.Name.label,
'Material Purchase Line Item':tableHeaders.Material_Order_Line_Item_Receipt__c.Material_Purchase_Line_Item__c.label,
  'MOLI Receipt Qty':tableHeaders.Material_Order_Line_Item_Receipt__c.MOLI_Receipt_Qty__c.label,
                      'Status':tableHeaders.Material_Order_Line_Item_Receipt__c.MPLI_Receipt_Status__c.label
                };
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
        var action1 = component.get("c.getLabelforObject");
        action1.setParams({
            sObjName :  "Material_Purchase_Line_Item__c"
        });
        action1.setCallback(this, function(response){
            var state = response.getState();
            console.log("label name" + response.getReturnValue());
            if(state === "SUCCESS"){
                component.set("v.Labelname", response.getReturnValue());
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
        $A.enqueueAction( Objaction );
        $A.enqueueAction( action1 );    
    },
    
    deleteMO :  function(component, event, helper,rcdid){ 
        
        //alert('Moid == '+Moid);
        var action = component.get("c.deleteMPLIrcd");
        action.setParams({
            rcdids : rcdid 
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": component.get('v.recordId')
                });
                navEvt.fire();
                if(response.getReturnValue() == 'deleted'){
                    helper.showToast({
                        "type":"success",
                        "message":  "MPLI Record Deleted Successfully."
                    }); 
                    // helper.fetchMO(component, event, helper);
                }
                else{
                    helper.showToast({
                        "type":"Error",
                        "message":  "Unable to delete record Because there is Material Order line item receipt records."
                    }); 
                    
                }
            }
        });
        $A.enqueueAction(action); 
    },
    
    createandupdatematerialusage :  function(component, event, helper,rcdid){ 
        var action = component.get("c.createandupdatematerial");
        action.setParams({
            rcdids : rcdid
        });
        action.setCallback(this, function(response) {
            console.log("=====Response====", response.getReturnValue());
            if (response.getState() === "SUCCESS") 
            {
                
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": component.get('v.recordId')
                });
                navEvt.fire();
                
                helper.showToast({
                    "type":"success",
                    "message":  "Material Usage Line Item Record Inserted Successfully."
                }); 
                
            }   
        });
        $A.enqueueAction(action);    
    },
    
    getRowActionsReceipt : function (component, row, doneCallback){
       var actions = [];
        
        var editAction = {
            'label': 'Edit',
            'iconName': 'utility:edit',
            'name': 'Edit_MOLIReceipt'
        };
        
        /*var deleteAction = {
            'label': 'Delete',
            'iconName': 'utility:delete',
            'name': 'Delete_MOLIReceipt'
        };*/
        actions.push(editAction);  
        setTimeout($A.getCallback(function () {
            doneCallback(actions);
        }), 200);
    },
    
    getRowActions: function (component, row, doneCallback) {
        var actions = [];
        
        /* var MarkReceivedDone = {  //This is commented for moli receipt on 15 - 04 - 2022
            'label': 'Received',
            'iconName': 'action:approval',
            'name': 'Mark_Received_Done',
            'disabled' : row.MPLI_Status__c == 'Received'
        };*/
        
        var CreateReceipt = {
            'label': 'CreateReceipt',
            'name': 'New_MPLI_Receipt'
            
        };
        
        var editAction = {
            'label': 'Edit',
            'iconName': 'utility:edit',
            'name': 'Edit_MPLI'
           
        };
        
        var deleteAction = {
            'label': 'Delete',
            'iconName': 'utility:delete',
            'name': 'Delete_MPLI'
           
        };
        
        // actions.push(editAction,deleteAction,MarkReceivedDone,CreateReceipt); //This is commented for moli receipt on 15 - 04 - 2022
        actions.push(editAction,deleteAction,CreateReceipt); 
        // simulate a trip to the server
        setTimeout($A.getCallback(function () {
            doneCallback(actions);
        }), 200);
    },
    
    //This is commented for moli receipt on 15 - 04 - 2022
    /*   MarkReceivedDone :  function(component, event, helper,rcdid){
      var action = component.get("c.editmplircd");
        action.setParams({
            rcdids : rcdid 
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": component.get('v.recordId')
                });
                navEvt.fire();
                if(response.getReturnValue() == 'updated'){
                    helper.showToast({
                        "type":"success",
                        "message":  "MPLI Record updated Successfully."
                    }); 
                    // helper.fetchMO(component, event, helper);
                    helper.createandupdatematerialusage(component, event, helper,rcdid);
                }
                else{
                    helper.showToast({
                        "type":"Error",
                        "message":  "Unable to update record."
                    }); 
                    
                }
            }
        });
        $A.enqueueAction(action); 
    },    */
    
    CreateMPLIRecord :  function(component, event, helper){
        var action = component.get("c.getFieldsforObject");
        action.setParams({
            sObjName : "Material_Purchase_Line_Item__c"
        });
        action.setCallback(this, function(response) {
            console.log("=====Field set====", response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                component.set("v.fieldset",response.getReturnValue()); 
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
        $A.enqueueAction(action);
    },
    
    CreateMPLIReceiptRecord :  function(component, event, helper,MPLIname){
        var action = component.get("c.getFieldsforObject");
        action.setParams({
            sObjName : "Material_Order_Line_Item_Receipt__c"
        });
        action.setCallback(this, function(response) {
            console.log("=====Field set====", response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                component.set("v.MPLIReceiptfieldset",response.getReturnValue()); 
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
        $A.enqueueAction(action); 
    },
    
    fetchMPLI :  function(component, event, helper){
        var recId = component.get("v.recordId");
        var MORec = component.get("c.getMPLIRecords");
        MORec.setParams({
            recordId : recId 
        });
        MORec.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var rows=response.getReturnValue();
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    
                    if(row.Name)row.ProEstLink='/'+row.Id; 
                    
                    row.MaterialItemLink = '/'+row.Material_Item__c; 
                    if (row.Material_Item__c) row.MTIL = row.Material_Item__r.Name;
                    
                    if (row.Material_Order__c) row.Material_Order__c = row.Material_Order__r.Name;
                    
                    /* if(row.Status__c=='Sent'){
                        row.POInlineEdit='PONonEditable';  
                    }
                    else{
                        row.POInlineEdit='POEditable';   
                    } */ 
                }
                component.set("v.data",rows);
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
        $A.enqueueAction(MORec);
    },
    
    fetchMOLIReceiptRecords : function(component, event, helper){
      var recId = component.get("v.recordId");
        var MOLIReceiptRec = component.get("c.getMPLIReceiptRecords");  
       MOLIReceiptRec.setParams({
            recordId : recId 
        });
        MOLIReceiptRec.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
             var rows=response.getReturnValue();
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                   // alert(JSON.stringify(row));
                    if(row.Name)row.ProEstLink='/'+row.Id; 
                    
                    if(row.Material_Purchase_Line_Item__c) row.Material_Purchase_Line_Item__c = row.Material_Purchase_Line_Item__r.Name;
                }
                             component.set("v.MOLIReceiptdata",rows);
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
         $A.enqueueAction(MOLIReceiptRec);
    },
    
    getMaterialItems :function(component, event, helper,CalUnit){
        //var CalUnit=component.find("CalUnitFieldId").get("v.value");
        //
        console.log("========CalUnit===="+CalUnit);
        var miaction = component.get("c.getMatereialItems");
        miaction.setParams({
            CalUnit :CalUnit 
        });
        miaction.setCallback(this, function(res) {
            console.log("=====Materail Items records===="+ res.getReturnValue());
            if(res.getState() === "SUCCESS"){
                component.set("v.MItem_Records", res.getReturnValue()); 
            } 
        });
        $A.enqueueAction(miaction);  
    },
    
    showToast : function(params){
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams(params);
            toastEvent.fire();
        } else{
            alert(params.message);
        }
    }
})