({
    doInit : function(component, event, helper) {
         helper.customSettingfecth(component, event);
        var rowActions = helper.getRowActions.bind(this, component);
        
        var checkPEpermisson=component.get("c.getVIPermiossions");
        checkPEpermisson.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                console.log('---response.getReturnValue()----'+JSON.stringify(response.getReturnValue()));
                component.set("v.isAccess",response.getReturnValue());
                if(component.get("v.isAccess[3]")){
                    helper.InvlineItemfetch(component, event);
                    helper.CreateINVLIRecord(component, event, helper);
                }               
            }
        });
        $A.enqueueAction(checkPEpermisson);
        
        
      
        var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
        console.log('--isMobile'+isMobile);
        if(isMobile){
            component.set("v.isMobile",true);
        }
        var finalColumns=[];
        var Columns=[
            //{ type: 'action', typeAttributes: { rowActions: rowActions }},
            {label: 'GL Department', fieldName: 'GL_Department__c',sortable: true, type: 'text'},
            {label: 'GL Code', fieldName: 'GL_Code_No__c',  sortable: true , type:'text'},
            {label: 'GL Description', fieldName: 'GLCLink', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'GLCName' }, target: '_self' }},
            {label: 'Unit Type', fieldName: 'Unit_Type__c', sortable: true , type:'text'},
            {label: 'Quantity', fieldName: 'Quantity__c',   sortable: true,editable:'true', type: 'number',cellAttributes: {alignment: 'left' }},
            {label: 'Amount', fieldName: 'Amount__c', sortable: true, editable:'true',type: 'currency',cellAttributes: {alignment: 'left' }}
            
        ];
        
      
        var LineItemCol= [{label: 'Line Item', fieldName: 'ItemLink',sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'EstName'}, target: '_self' }}];
        
        finalColumns.push({ type: 'action', typeAttributes: { rowActions: rowActions }});
        setTimeout($A.getCallback(function () {
            helper.getGLCode(component, event, helper);
            var POId=component.get("v.simpleRecord").Purchase_Order__c;
            console.log('=====POId====='+JSON.stringify(POId));
            if(POId!='' && POId!=null){
                Array.prototype.push.apply(finalColumns, LineItemCol);
            }
            var ShoWPE=component.get("v.ShowProductionEstimate");
            console.log("====Controller===="+ShoWPE);
            var newColmns=[];
            if(ShoWPE){
                newColmns=Columns.slice(0, 3).concat(Columns.slice(3 + 1, Columns.length))
            }
            else{
                newColmns=Columns;
            }
            Array.prototype.push.apply(finalColumns, newColmns);
            component.set('v.columns',finalColumns); 
        }), 700);
        
        
        
        component.set('v.PoLicolumns', [
            {label: 'Line Item', fieldName: 'LineName', type: 'text',},
            {label: 'Amount', fieldName: 'Calc_Amnt', type: 'currency',cellAttributes: { alignment: 'left' }},
            {label: 'Quantity', fieldName: 'Qunatity', type: 'number',cellAttributes: { alignment: 'left' }}
            
        ]);
        
    },
    
    updateSelectedTextPOLI: function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        cmp.set('v.Selected_POLI', selectedRows);   
        console.log('>>>>>> Event Selected Row Values >>>>>>>>>>>>',+JSON.stringify(selectedRows));
        console.log('>>>>>> Selected Row Values >>>>>>>>>>>>',+JSON.stringify(cmp.get('v.Selected_POLI')));
        cmp.set('v.PoLiselectedRowsCount', selectedRows.length);
    },
    
    
    handleRowAction: function(component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
                
            case 'Edit_INVLI':
                if(component.get("v.isAccess[5]")){
                    component.set("v.isINVLIOpen", true);
                    component.set('v.INVLIRecordid',row.Id);
                }else{
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": 'Invoices Line Item has insuffiecient access to edit.'
                    });  
                }
                
                break;
                
            case 'Delete_INVLI':
                helper.deleteJobINVLI(component, event, helper);
                break;
        }
    },
    
    addLineItemFromPo: function (component, event, helper) {
        if(component.get("v.isAccess[4]")){
            helper.PoLineItemsFromPoInvoiceView(component, event, helper);
            component.set("v.isaddClick",true);
        }
        else{
            helper.showToast({
                "title": "Error!!",
                "type": "error",
                "message": 'Invoices Line Item has insuffiecient access to creat.'
            }); 
        }
      
    },
    
    closeModelForAddLineItems: function (component, event, helper) {
        component.set("v.Selected_POLI",null); 
        component.set("v.isaddClick",false);
    },
    
    
    recordsUpdateforchanges: function (cmp, event, helper) {
        // alert('fireing in Client Invoice section after records delete and insert');
        helper.InvlineItemfetch(cmp, event, helper);
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
    
    INVLICreate:function (component, event, helper) {
        //helper.getGLCode(component, event, helper);
        if(component.get("v.isAccess[4]")){
             component.set("v.isINVLIOpen", true);
        }else{
            helper.showToast({
                "title": "Error!!",
                "type": "error",
                "message": 'Invoices Line Item has insuffiecient access to create.'
            }); 
        }
       
        
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.isINVLIOpen", false);
        component.set('v.INVLIRecordid', null);
    },
    
    
    jobINVLIOnsubmit : function(component, event, helper) {
        event.preventDefault(); // Prevent default submit
        var INVLIfields = event.getParam("fields");
        console.log('========'+component.get("v.recordId"));
        INVLIfields["Invoice__c"]=component.get("v.recordId");
        var missField = "";           
        var reduceReutrn = component.find('JobINVLIField').reduce(function(validFields, inputCmp) {   
            if(component.find("GLCId").get("v.value")=='null' || component.find("GLCId").get("v.value")==''){
                var ToastMsg5=$A.get("e.force:showToast");    
                ToastMsg5.setParams({
                    "title":"GL Description",
                    "type": "error",
                    "message":"GL Description Field is required."
                });   
                ToastMsg5.fire();
                event.preventDefault();   
            } 
            else if(inputCmp.get("v.fieldName") == "Amount__c" ){
                var InvName = inputCmp.get("v.value");
                if (InvName == null || InvName == '') 
                    missField = "Amount";
            } 
            
            
            
        }, true);
        
        var ToastMsg = $A.get("e.force:showToast");
        ToastMsg.setParams({
            "title": missField,
            "type": "error",
            "message": missField + " Field is required."
            
        }); 
        
        if (missField == "Amount"){
            ToastMsg.fire();
            event.preventDefault();
        }
        else
        {
            INVLIfields["GL_Code__c"]=component.find("GLCId").get("v.value");
            component.find("INVLIEditform").submit(INVLIfields);
            
        }
    },
    
    onINVLIRecordSuccess: function(component, event, helper) { 
        var INVLIId=component.get('v.INVLIRecordid');
        var msg;
        if(INVLIId=='undefined' || INVLIId==null ){
            msg='Successfully Inserted Invoice Line Item Record';
        }
        else{
            msg='Successfully Updated Invoice Line Item Record';
        }
        console.log('===record Success==='+INVLIId);
        var ToastMsg11 = $A.get("e.force:showToast");
        ToastMsg11.setParams({
            "title": "Sucess",
            "type": "success",
            "message":msg
            
        });
        
        // setTimeout($A.getCallback(function () {
        component.set("v.isINVLIOpen", false);
        component.set('v.INVLIRecordid',null);
        helper.InvlineItemfetch(component, event, helper);
        ToastMsg11.fire();
        helper.reloadDataTable();    
        // }), 1500);
        
    },
    
    jobINVLIload:  function(component, event, helper) { 
        console.log('===record Load===');
        var recId=component.get("v.INVLIRecordid");
        console.log('===Recordid after==='+recId);           
        if(recId!=null){
            var INVLIfilds = event.getParam("recordUi");
            // helper.CreateINVLIRecord(component, event, helper); 
            // helper.getGLCode(component, event, helper);
            
            // setTimeout($A.getCallback(function() {
            component.find("GLCId").set("v.value",INVLIfilds.record.fields.GL_Code__c.value);
            console.log('==Vendor__c Onload Id=='+component.find("GLCId").get("v.value"));
            // }), 500);
        }
        
    },
    
    saveSelectedPOLineItemsFromInvoice :function(component, event, helper) { 
        
        if(component.get("v.Selected_POLI")!=null && component.get("v.Selected_POLI")!=''){
            var Liaction=component.get("c.SavePoLineItemsSubmit");
            
            Liaction.setParams({
                selectedRec : component.get("v.Selected_POLI"),
                poid:component.get("v.simpleRecord.Purchase_Order__c")
            });
            
            Liaction.setCallback(this, function(res) {
                if (res.getState() === "SUCCESS") {
                    if(res.getReturnValue()=="OK"){
                        console.log('====Ok response==='+res.getReturnValue());
                        helper.saveRecordsInvfromPOInvoiceView(component,component.get("v.Selected_POLI"),component.get("v.simpleRecord.Id"),component.get("v.simpleRecord.Purchase_Order__c"),event,helper);
                    }
                    else{
                        console.log('====fale  response==='+res.getReturnValue());               
                        event.preventDefault();
                        var ToastMsg111 = $A.get("e.force:showToast");
                        ToastMsg111.setParams({
                            "type": "error",
                            "message":res.getReturnValue()
                        }); 
                        ToastMsg111.fire();
                    }
                }
            });
            $A.enqueueAction(Liaction);   
        }
        else{
            var ToastMsg111 = $A.get("e.force:showToast");
            ToastMsg111.setParams({
                "type": "error",
                "message":"No PO Line Items are available for this Invoice."
            }); 
            ToastMsg111.fire();
        }
        
    }
    
    
})