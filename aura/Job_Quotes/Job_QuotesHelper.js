({
    getFieldLabels: function(component, event, helper) {
        
        var rowActions = helper.getRowActions.bind(this, component);
        var Objaction = component.get( "c.getObjectType" );
        Objaction.setParams({
            ObjNames : 'Quote__c'
        }); 
        Objaction.setCallback( helper, function( response ) {
            console.log('>>>>>> Enter >>>>>>>>>>');
            if(component.isValid() && response.getState() === 'SUCCESS' ) {
                // Parse the JSON string into an object
                component.set( 'v.ObjectType', JSON.parse( response.getReturnValue() ) );
                console.log('>>>>>> Result of labels >>>>>>>>>>'+JSON.stringify(JSON.parse( response.getReturnValue() )));
                
                var tableHeader=component.get('v.ObjectType');
                console.log('>>>Field Name Dynamically >>>>>>>>>>>>>'+JSON.stringify(tableHeader));
                component.set('v.columns', [
                    { type: 'action', typeAttributes: { rowActions: rowActions }},
                    {label: tableHeader.Quote__c.Name.label, fieldName: 'QuoteLink',sortable: true, type: 'url', initialWidth:180,typeAttributes: { label: { fieldName: 'Name' }, target: '_self' ,tooltip:{ fieldName: 'Name' } }},
                    {label: tableHeader.Quote__c.GL_Department__c.label, fieldName: 'GLDepartment', initialWidth:180,sortable: true, type: 'text'},
                    {label: tableHeader.Quote__c.GL_Code__c.label, fieldName: 'GLCode', sortable: true,initialWidth:150, type: 'text'},
                    {label: tableHeader.Quote__c.Unit_Type__c.label, fieldName: 'Unit_Type__c',sortable: true,initialWidth:130, type: 'text'},
                    {label: tableHeader.Quote__c.Request_Date__c.label, fieldName: 'Request_Date__c', editable:true, sortable: true, initialWidth:160,type: 'date-local' , cellAttributes: {class: { fieldName: 'QuoteInlineEditReq' }, iconName: 'utility:event', iconAlternativeText:'Request Date'} },
                    {label: tableHeader.Quote__c.Due_Date__c.label, fieldName: 'Due_Date__c', editable:true, sortable: true,initialWidth:160, type: 'date-local' ,cellAttributes: { class: { fieldName: 'QuoteInlineEditDue' }, iconName: 'utility:event', iconAlternativeText:'Due Date'} },
                    {label: tableHeader.Quote__c.Amount__c.label, fieldName: 'Amount__c', sortable: true, type: 'currency' ,initialWidth:150,cellAttributes: {alignment: 'left' }},
                    {label: tableHeader.Quote__c.Approved__c.label, fieldName: 'Approved__c', sortable: true, type: 'boolean',initialWidth:80}
                ]); 
                var labels = {'Amount':  tableHeader.Quote__c.Amount__c.label,
                              'DueDate':tableHeader.Quote__c.Due_Date__c.label,
                              'Status':tableHeader.Quote__c.Approved__c.label
                             };
                component.set('v.DynamicLabels',labels);
                console.log('-----labels--'+JSON.stringify(labels));
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
        $A.enqueueAction(Objaction); 
        var action1 = component.get("c.geLabelforObject");
        action1.setParams({
            sObjName :  "Quote__c"
        });
        action1.setCallback(this, function(response){
            var state = response.getState();
            console.log("label name" + response.getReturnValue());
            if(state === "SUCCESS"){
                component.set("v.Labelname", response.getReturnValue());
            } 
            else
            {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction(action1);
    },
    
    fetchJobQuotes : function(component, event, helper) {
        var recId = component.get("v.jobrecordId");
        var action = component.get("c.getquoterecords");
        action.setParams({
            recordId : recId
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var rows=response.getReturnValue();
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    row.QuoteLink = '/'+row.Id;
                    if (row.GL_Department__c) row.GLDepartment = row.GL_Department__r.Name;
                    if (row.GL_Code__c) row.GLCode = row.GL_Code__r.Name;
                    if(row.Approved__c){
                        if (row.Request_Date__c) row.QuoteInlineEditReq ='QuoteNonEditable';
                        if (row.Due_Date__c) row.QuoteInlineEditDue ='QuoteNonEditable';
                    }
                    else{  // slds-cell-edit slds-is-edited
                        if (row.Request_Date__c) row.QuoteInlineEditReq ='QuoteEditable';
                        if (row.Due_Date__c) row.QuoteInlineEditDue ='QuoteEditable';
                    }
                }
                component.set("v.data",rows);
                component.set("v.rawData",rows);
            }
            else
            {
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
        var actions = [];
        
        var editAction = {
            'label': 'Edit',
            'iconName': 'utility:edit',
            'name': 'Edit_Quote'
        };
        
        var deleteAction = {
            'label': 'Delete',
            'iconName': 'utility:delete',
            'name': 'Delete_Quote'
        };
        var unAppoveQuote = {
            'label': 'Unapprove',
            'iconName': 'action:close',
            'name': 'UnApprv_Quote',
        };
        //console.log('===row approve in the array=='+row['Approved__c']);
        console.log('===row approve in the array=='+row['Approved__c']);
        console.log('===row approve=='+row.Approved__c);
        if (row['Approved__c']) {
            editAction['disabled']= 'true';
            deleteAction['disabled'] = 'true';
            actions.push(editAction,deleteAction,unAppoveQuote);
        } else {
            unAppoveQuote['disabled']='true';
            actions.push(editAction,deleteAction,unAppoveQuote);
        }
        
        // simulate a trip to the server
        setTimeout($A.getCallback(function () {
            doneCallback(actions);
        }), 200);
    },
    
    
    
    /*********************************************************************************************************************************************
     * This function get called when user clicks on Save button.
     * user can get all modified records.
     * and pass them back to server side controller.
     * *******************************************************************************************************************************************/
    
   saveDataTable : function(component, event, helper) {
        var editedRecords =  component.find("QuoteDataTable").get("v.draftValues");
        console.log('=====editedRecords======='+JSON.stringify(editedRecords));
        var totalRecordEdited = editedRecords.length;
        var action = component.get("c.updateQuotes");
        action.setParams({
            'editedQuoteList' : editedRecords
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
                    helper.fetchJobQuotes(component, event, helper);
                    component.find("QuoteDataTable").set("v.draftValues", null);
                    
                } else{ //if update got failed
                    if(response.getReturnValue()==='Error, quote has insufficient access to update'){
                        helper.showToast({
                            "title": "Error!!",
                            "type": "error",
                            "message": response.getReturnValue()
                        });
                    }else{ 
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
                                    fieldNames: ['Request_Date__c', 'Due_Date__c']
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
            }
            else
            {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError());
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
        if(refreshEvent){
            refreshEvent.fire();
        }
    },
    
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.data");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.data", data);
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
    CreateQuoteRecord :  function(component, event, helper){
        var action = component.get("c.getFieldsforObject");
        action.setParams({
            sObjName : "Quote__c"
        });
        action.setCallback(this, function(response) {
            console.log("=====Field set====", response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                component.set("v.fieldset",response.getReturnValue()); 
            }
            else
            {
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
    getGLDepartment: function(component, event, helper){
        var action1 = component.get("c.getGLDepartments");
        action1.setCallback(this, function(response1) {
            console.log("=====GLD List====", response1.getReturnValue());
            var GLD=response1.getReturnValue();
            var GLDept=[];
            if(response1.getState() === "SUCCESS"){
                for (var key in GLD) {
                    GLDept.push({
                        key: key,
                        value: GLD[key]
                    });
                }
                component.set("v.GL_DepartmentRecords", GLDept); 
            } 
            else{
                console.log('>>>>>> Error >>>>>>>>>>',response1.getError()[0].message);
                var errors = response1.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction(action1);
    },
    getGLCode :  function(component, event, helper){
        var GLDId=component.find("GLDSelectId").get('v.value');
        console.log('===GLDId==='+GLDId);
        var actionCC = component.get("c.getGLCodes");
        
        actionCC.setParams({
            GLDName :GLDId 
        });
        actionCC.setCallback(this, function(responseCC){
            var stateCC = responseCC.getState();
            console.log("===List of GLC===" + responseCC.getReturnValue());
            var CC=responseCC.getReturnValue();
            var CClist=[];
            if(stateCC === "SUCCESS"){
                for (var key in CC) {
                    CClist.push({
                        key: key,
                        value: CC[key]
                    });
                }
                component.set("v.GL_CodeRecords", CClist); 
            } 
            else
            {
                console.log('>>>>>> Error >>>>>>>>>>',responseCC.getError()[0].message);
                var errors = responseCC.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        }); 
        $A.enqueueAction(actionCC);  
    },
    
    deleteJobQuote: function(component, event, helper,selectQtkId){
        var DleQuote=component.get("c.DeleteQuote");
        if(selectQtkId!=null || selectQtkId!=undefined){
            DleQuote.setParams({
                quoteId :selectQtkId
            });
        }
        else{
            var row = event.getParam('row');
            DleQuote.setParams({
                quoteId :row.Id
            });
            console.log('===Delete QUOTE Id=='+row.Id);
        }  
        
        DleQuote.setCallback(this, function(delequoteres){
            var quotreslut=delequoteres.getReturnValue();
            if(delequoteres.getState() === "SUCCESS"){
                console.log("=====quotreslut====="+JSON.stringify(quotreslut));
                if(quotreslut[0]=="OK"){
                    helper.fetchJobQuotes(component, event, helper);  
                    var ToastMsg1 = $A.get("e.force:showToast");
                    ToastMsg1.setParams({
                        "type": "success",
                        "message": "Successfully Deleted Job Quote Record"
                        
                    });ToastMsg1.fire();
                }
                else{
                    var ToastMsg1 = $A.get("e.force:showToast");
                    ToastMsg1.setParams({
                        "title": "Error!!",
                        "type": "error",
                        "message":quotreslut[1] 
                        
                    });
                    ToastMsg1.fire();
                }
            }
            else{
                var ToastMsg1 = $A.get("e.force:showToast");
                ToastMsg1.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message":quotreslut[1] 
                    
                });
                ToastMsg1.fire();
            }
        });
        $A.enqueueAction(DleQuote);  
    },
    
    unApporveQuote : function(component, event, helper,selectQtkId){
        var vqUnapp = component.get("c.vendorUnapproved");
        if(selectQtkId!=null || selectQtkId!=undefined){
            vqUnapp.setParams({
                quoteId: selectQtkId
            });
        }
        else{
            var row = event.getParam('row');
            vqUnapp.setParams({
                quoteId: row.Id
            });
            console.log('===QuotRecId======' + row.Id);
        }  
        vqUnapp.setCallback(this, function(vqUnappRes) {
            console.log('===state======' + vqUnappRes.getState());
            var VqUnstate = vqUnappRes.getState();
            var ToastMsg = $A.get("e.force:showToast");
            if (VqUnstate === "SUCCESS") {
                if(vqUnappRes.getReturnValue()=='OK'){
                    helper.reloadDataTable();
                    helper.fetchJobQuotes(component, event, helper);   
                    ToastMsg.setParams({
                        "type": "success",
                        "message": 'Quote is Unapproved successfully.'
                    });
                    ToastMsg.fire();
                    // this application event fire to update estimate records
                    $A.get("e.c:UpdateRecordsforChanges").fire();  
                }
                else{
                    ToastMsg.setParams({
                        "title" :"Error!!",
                        "type": "error",
                        "message": vqUnappRes.getReturnValue()
                    });
                    ToastMsg.fire();   
                    
                }
            }
            else{
                ToastMsg.setParams({
                    "title" :"Error!!",
                    "type": "error",
                    "message": vqUnappRes.getReturnValue()
                });
                ToastMsg.fire();   
                
            }
        });  
        
        $A.enqueueAction(vqUnapp);    
    }
    
})