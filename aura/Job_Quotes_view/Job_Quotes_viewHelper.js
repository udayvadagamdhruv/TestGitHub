({
    fetchFieldLabels : function(component, event , helper){
        var isQuoteApproved= component.get("v.simpleRecord.Approved__c");
        var rowActions = helper.getRowActions.bind(this, component);  
        var Specactions=helper.getSpecRowActions.bind(this, component);
        var action=component.get("c.getObjectType");
        action.setParams({
            ObjNames:['Vendor_Quote__c','Quote_Spec_Item__c']
        });
        action.setCallback(this, function(res){
            if(res.getState() === "SUCCESS"){
                var tableHeaders=JSON.parse(res.getReturnValue());
                console.log('===Vendor Quote and Quote Specs====='+JSON.stringify(JSON.parse(res.getReturnValue())));
                component.set("v.ObjectType",JSON.parse(res.getReturnValue()));
                component.set('v.QuoteSpecColumns', [
                    {type: 'action', typeAttributes: { rowActions: Specactions }}, 
                    {label: tableHeaders.Quote_Spec_Item__c.Name.label, fieldName: 'Name', type: 'text',editable: true,sortable: true},
                    {label: tableHeaders.Quote_Spec_Item__c.Description__c.label, fieldName: 'Description__c', type:'text',sortable: true}
                    //{label:tableHeaders.Job_Spec__c.Sort_Order__c.label, fieldName: 'Sort_Order__c', type:'number',editable: true,initialWidth:150},
                    
                ]);
                component.set('v.columns', [
                     { type: 'action', typeAttributes: { rowActions: rowActions }},
                    //{label: 'VQ#', fieldName: 'VendorLink',sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: '_self',tooltip: { fieldName: 'Name' } }},
                    {label: tableHeaders.Vendor_Quote__c.Name.label, fieldName: 'Name',sortable: true, type:'text'},
                    {label: tableHeaders.Vendor_Quote__c.Vendor__c.label, fieldName: 'VendorNameLink',sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'VendorName' }, target: '_self' }},
                    {label: tableHeaders.Vendor_Quote__c.Date__c.label, fieldName: 'Date__c', editable:true, sortable: true, type: 'date-local' ,initialWidth:300,  cellAttributes: { iconName: 'utility:event', iconAlternativeText: tableHeaders.Vendor_Quote__c.Date__c.label} },
                    {label: tableHeaders.Vendor_Quote__c.Amount__c.label, fieldName: 'Amount__c',editable:true, sortable: true, type: 'currency',initialWidth:250 },
                    {label: tableHeaders.Vendor_Quote__c.Restrict__c.label, fieldName: 'Restrict__c',  sortable: true, type: 'boolean',initialWidth:250}
                ]); 
                
                var Quotelabels = {'Name':tableHeaders.Vendor_Quote__c.Name.label,
                                   'Vendor':tableHeaders.Vendor_Quote__c.Vendor__c.label,
                                   'Date':tableHeaders.Vendor_Quote__c.Date__c.label,
                                   'Amount':tableHeaders.Vendor_Quote__c.Amount__c.label,
                                   'Restrict':tableHeaders.Vendor_Quote__c.Restrict__c.label
                                  };
                component.set('v.DynamicLabelsQuote',Quotelabels);
                console.log('-----Quotelabels------'+JSON.stringify(Quotelabels));
                var Speclabels ={'Name':tableHeaders.Quote_Spec_Item__c.Name.label,
                                 'Description':tableHeaders.Quote_Spec_Item__c.Description__c.label
                                };
                component.set('v.DynamicLabelsSpec',Speclabels);
                
                helper.QuoteSpecsfetch(component, event);
                helper.VendorQuotefetch(component, event);
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',res.getError()[0].message);
                var errors = res.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction(action);
    },
    
    QuoteSpecsfetch : function(component, event, helper) {
        var recId = component.get("v.recordId");
        console.log("==== recId   ===="+recId);
        var action = component.get("c.getquotespecList");
        action.setParams({
            quoteId : recId
        });
        action.setCallback(this, function(response) {
            var rows=response.getReturnValue();
            console.log("=====spec records===="+JSON.stringify(rows));
            if (response.getState() === "SUCCESS") {
                component.set("v.QuotespecRecords",rows);
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    },
    
    productiontempList : function(component, event, helper) {
        var proTempaction = component.get("c.getProductionSpecTemplate");
        
        proTempaction.setCallback(this, function(proTempres){
            if (proTempres.getState() === "SUCCESS") {
                var proTempList=[];
                var res=proTempres.getReturnValue();
                for(var key in res){
                    proTempList.push({key:key,value:res[key]});
                }
                component.set("v.proTempList",proTempList);
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',proTempres.getError()[0].message);
                var errors = proTempres.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Production Spec Template has insufficient access.'
                }); 
            }
            
        });
        $A.enqueueAction(proTempaction);
    },
    
    ImportProductionTempHelper : function(component, event, helper) {
        var ProdTempId=component.find("ProTemplateId").get("v.value");
        var QuoteRecId=component.get("v.recordId");
        var ImporTempAction = component.get("c.importProTemplateSpecsForQuotes");
        console.log('==ProdTempId='+ProdTempId);
        console.log('==QuoteRecId='+QuoteRecId);
        
        ImporTempAction.setParams({
            QuoteId : QuoteRecId,
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
                helper.QuoteSpecsfetch(component, event, helper); 
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',Impresponse.getError()[0].message);
                var errors = Impresponse.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction(ImporTempAction);
    },
    
    
    
    VendorQuotefetch: function(component, event, helper) {
        var recId = component.get("v.recordId");
        console.log("==== recId   ===="+recId);
        
        console.log("====helper recId   ===="+component.get("v.recordId"));
        console.log("====helper quote recId   ===="+component.get("v.quoteRecordid"));
        
        var action = component.get("c.getVendorQuoteList");
        action.setParams({
            quoteId : recId
        });
        action.setCallback(this, function(response) {
            console.log("====getVendorQuoteList==", response.getState());
            console.log("====getVendorQuoteList==",JSON.stringify(response.getReturnValue()));
            if (response.getState() === "SUCCESS") {
                var rows=response.getReturnValue();
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    row.VendorLink = '/'+row.Id;
                    if(row.Vendor__c){
                        row.VendorNameLink='/'+row.Vendor__c;
                        row.VendorName=row.Vendor__r.Name;
                    }
                    if(row.Restrict__c){
                        component.set("v.columns[2][editable]",false);
                        component.set("v.columns[3][editable]",false);
                        component.set('v.VendorNewBtnMobile',false);
                    }
                    
                    
                    
                }
                
                component.set("v.data",rows);
                if(rows.length==0)
                    component.set("v.datalenght",true);
                else
                    component.set("v.datalenght",false);
                
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
    getRowActions: function (component, row, doneCallback) {
        var approved_Quote= component.get("v.simpleRecord.Approved__c");
        var actions = [];
        var approveAction = {
            'label': 'Approve',
            'iconName': 'action:approval',
            'name': 'Vendor_Approve',
            disabled:approved_Quote
        };
        
        var DeleteAction = {
            'label': 'Delete',
            'iconName': 'utility:delete',
            'name': 'Vendor_Delete',
            disabled:approved_Quote
        };
        
        var PrintQuote  = {
            'label': 'Print Quote',
            'iconName': 'utility:print',
            'name': 'Print_Quote',
            
        };
        actions.push(approveAction,DeleteAction,PrintQuote);
        setTimeout($A.getCallback(function () {
            doneCallback(actions);
        }), 200);
    },
    
    getSpecRowActions: function (component, row, doneCallback) {
        var approved_Quote= component.get("v.simpleRecord.Approved__c");
        var specactions=[
            {'label': 'Edit','iconName': 'action:edit','name': 'Edit_Quote_Spec_Item',disabled:approved_Quote},
            {'label': 'Delete','iconName': 'action:delete','name': 'Delete_Quote_Spec_Item',disabled:approved_Quote} 
        ];
        setTimeout($A.getCallback(function () {
            doneCallback(specactions);
        }), 200);
    },
    /*====================================================Data Table helpers ========================================================*/
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.data");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        if(fieldName=='VendorNameLink'){
              data.sort(this.sortBy('VendorName', reverse))
        } else{
            data.sort(this.sortBy(fieldName, reverse))
        }
        cmp.set("v.data", data);
    },
    sortDataforSpecs :function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.QuotespecRecords");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.QuotespecRecords", data);
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
    
    saveDataTableofSpecs : function(component, event, helper) {
        var editedRecords1 =component.find("QuoteSpecsTableId").get("v.draftValues");
        console.log('===Qutoe Specs=editedRecords======'+JSON.stringify(editedRecords1));
        //var totalRecordEdited = editedRecords.length;
        var action = component.get("c.updateQuoteSpecs");
        action.setParams({
            'editQuoteSpecsList' : editedRecords1
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //if update is successful
                if(response.getReturnValue() === 'OK'){
                    helper.showToast({
                        "title": "Record Update",
                        "type": "success",
                        "message": "Specs Records Updated"
                    });
                    helper.QuoteSpecsfetch(component, event);
                    component.find("QuoteSpecsTableId").set("v.draftValues", null);
                    
                } else{ //if update got failed
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": response.getReturnValue()
                    });
                    
                }      
            }
            
        });
        $A.enqueueAction(action);
    },    
    
    
    
    saveDataTable : function(component, event, helper) {
        var editedRecords =  component.find("VendorQuoteDataTable").get("v.draftValues");
        console.log('=====editedRecords======='+JSON.stringify(editedRecords));
        var totalRecordEdited = editedRecords.length;
        var action = component.get("c.updateVendorQuotes");
        action.setParams({
            'editedVendorQuoteList' : editedRecords
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //if update is successful
                if(response.getReturnValue() === 'true'){
                    helper.showToast({
                        "title": "Record Update",
                        "type": "success",
                        "message": totalRecordEdited+" Quote Records Updated"
                    });
                    
                    //helper.reloadDataTable();
                    helper.VendorQuotefetch(component, event, helper);
                    component.find("VendorQuoteDataTable").set("v.draftValues", null);
                    
                } else if(response.getReturnValue()=='Error, Vendor Quote Insufficient access to Update this record'){ //if update got failed
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": response.getReturnValue()
                    });
                }else{ //if update got failed
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": response.getReturnValue()
                    });
                    
                    var err_array =  response.getReturnValue().split(';');
                    component.set('v.errors', {
                        rows: {
                            b: {
                                title: 'We found errors.',
                                messages: [
                                    err_array[0],
                                    err_array[1].split(',')[1]
                                ],
                                fieldNames: ['Date__c','Amount__c', 'Restrict__c']
                            }
                        },
                        table: {
                            title: 'Your entry cannot be saved. Fix the errors and try again.',
                            messages: [
                                err_array[0],
                                err_array[1].split(',')[1]
                            ]
                        }
                    });
                    
                    
                }      
            }
        });
        $A.enqueueAction(action);
    },
    
    showToast : function(params){
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams(params);
            toastEvent.fire();
        } else{
            alert(params.message);
        }
    },
    
    reloadDataTable : function(){
        console.log('==========reloadData Table======');
        var refreshEvent = $A.get("e.force:refreshView");
        $A.get('e.force:refreshView').fire();
        if(refreshEvent){
            refreshEvent.fire();
        }
    },
    /*====================================================Data Table helpers ========================================================*/
    
    getVendorforVendorQuote:  function(component, event, helper){
        var recId = component.get("v.recordId");
        console.log("==== recId   ===="+recId);
        var actionVen = component.get("c.getVendorQuote");
        actionVen.setParams({
            quoteId :recId 
        });
        actionVen.setCallback(this, function(responseVen){
            var stateVen = responseVen.getState();
            console.log("===List of Vendors===" + responseVen.getReturnValue());
            var Ven=responseVen.getReturnValue();
            var Venlist=[];
            if(stateVen === "SUCCESS"){
                for (var key in Ven) {
                    Venlist.push({
                        key: key,
                        value: Ven[key]
                    });
                }
                component.set("v.VendorRecords", Venlist); 
                console.log("====vendor names ===="+Venlist);
            } 
        }); 
        $A.enqueueAction(actionVen);  
    },   
    getfieldsetvalues:  function(component, sobjname){
        var action = component.get("c.getFieldsforObject");
        console.log("=====second time sobjname==="+sobjname);
        action.setParams({
            sObjName : sobjname
        });
        action.setCallback(this, function(response) {
            console.log("===Quote_Spec_Item__c==Field set====", response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                component.set("v.fieldset",response.getReturnValue()); 
            }
        });
        $A.enqueueAction(action);
        
    },
    Vendor_Approved: function(component, event,helper,selectVendorId){
       // alert('approved');
        var action = component.get("c.vendorapproved");
        if(selectVendorId!=null || selectVendorId!=undefined){
            action.setParams({
                VendorquoteId : selectVendorId
            });
        }   
        else{
            var row = event.getParam('row');
            var vendorquoteid = row.Id;
            action.setParams({
                VendorquoteId : vendorquoteid
            });
        }
        action.setCallback(this, function(response) {
            console.log("===Quote_Spec_Item__c==Vendor_Approved====", response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                // component.set("v.fieldset",response.getReturnValue()); 
                if(response.getReturnValue()=='OK'){
                    helper.reloadDataTable();
                    component.set('v.VendorNewBtnMobile',false);
                    helper.VendorQuotefetch(component, event,helper);
                    console.log("===Successfully done the approve====", response.getReturnValue());
                }
                else{ //if update got failed
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": response.getReturnValue()
                    });
                }
            } else {
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
    
    Vendor_Delete: function(component, event,helper,selectVendorId){
        var action = component.get("c.vendorQuoteDelete");
        if(selectVendorId!=null || selectVendorId!=undefined){
            action.setParams({
                VendorquoteId : selectVendorId
            });
            
        }   
        else{
            var row = event.getParam('row');
            var vendorquoteid = row.Id;
            action.setParams({
                VendorquoteId : vendorquoteid
            });
        }
        
        action.setCallback(this, function(response) {
            console.log("===Vendoor Quote Delete=", response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                if(response.getReturnValue()=="OK"){
                    helper.VendorQuotefetch(component, event, helper);
                    console.log("===Successfully Deleted the approve====", response.getReturnValue());
                    helper.showToast({
                        "type": "success",
                        "message": "Record deleted."
                    });
                }
                else{
                    helper.showToast({
                        "title":"Error!!",
                        "type": "error",
                        "message": ""+response.getReturnValue()
                    }); 
                }
            }
            else{
                helper.showToast({
                    "title":"Error!!",
                    "type": "error",
                    "message": ""+response.getReturnValue()
                }); 
            }
        });
        $A.enqueueAction(action);
    },
    
    deleteQuoteSpecItem :function(component, event,helper,SpecRecId){
        var DelSpecAction = component.get("c.deleteQuoteSpec");
        DelSpecAction.setParams({
            SpecRecId: SpecRecId
        });
        
        DelSpecAction.setCallback(this, function(DelSpecResponse) {
            console.log('===Dele spec Reuturn==' + DelSpecResponse.getReturnValue());
            if (DelSpecResponse.getState() === "SUCCESS") {
                console.log('===Dele spec Reuturn==' + DelSpecResponse.getReturnValue());
                if(DelSpecResponse.getReturnValue()=='Deleted'){
                    helper.QuoteSpecsfetch(component, event);                    
                    var DeleteSpecMsg = $A.get("e.force:showToast");
                    DeleteSpecMsg.setParams({
                        "type": "success",
                        "message": "Spec Item Deleted Successfully"                        
                    });
                    DeleteSpecMsg.fire();  
                }else{
                    var DeleteSpecMsg = $A.get("e.force:showToast");
                    DeleteSpecMsg.setParams({
                        "type": "error",
                        "message":  DelSpecResponse.getReturnValue()                       
                    });
                    DeleteSpecMsg.fire(); 
                }
                
            }
        });
        $A.enqueueAction(DelSpecAction);
    }
    
})