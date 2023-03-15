({
    getFieldLabels: function(component, event, helper) {
        var rowActions = helper.getRowActions.bind(this, component);
        var Objaction = component.get( "c.getObjectType" );
        Objaction.setParams({
            ObjNames : 'Invoice__c'
        }); 
        Objaction.setCallback( helper, function( response ) {
            console.log('>>>>>> Enter >>>>>>>>>>');
            if(component.isValid() && response.getState() === 'SUCCESS' ) {
                var tableHeaders=JSON.parse(response.getReturnValue());
                component.set( 'v.ObjectType', JSON.parse( response.getReturnValue() ) );
                console.log('>>>>>> Result of labels >>>>>>>>>>'+JSON.stringify(JSON.parse( response.getReturnValue() )));
                
                component.set('v.columns', [
                    {type: 'action', typeAttributes: {rowActions: rowActions}},
                    {label: tableHeaders.Invoice__c.Name.label, fieldName: 'InvLink', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: '_self' } },
                    {label: tableHeaders.Invoice__c.Vendor__c.label, fieldName: 'Vendor__c', sortable: true, type: 'text'},
                    {label: tableHeaders.Invoice__c.Purchase_Order__c.label, fieldName: 'Purchase_Order__c',sortable: true, type: 'text'},
                    {label: tableHeaders.Invoice__c.Date_Received__c.label, fieldName: 'Date_Received__c', editable:'true', sortable: true, type: 'date-local' , cellAttributes: { iconName: 'utility:event', iconAlternativeText:tableHeaders.Invoice__c.Date_Received__c.label} },
                    {label: tableHeaders.Invoice__c.Total_Amount__c.label, fieldName: 'Total_Amount__c', sortable: true, type: 'currency',cellAttributes: {alignment: 'left' } }
                    
                ]);  
                
                var VdInvlabels = {'Name':tableHeaders.Invoice__c.Name.label,
                                   'Vendor':tableHeaders.Invoice__c.Vendor__c.label,
                                   'PO':tableHeaders.Invoice__c.Purchase_Order__c.label,
                                   'DateReceived':tableHeaders.Invoice__c.Date_Received__c.label,
                                   'Amount':tableHeaders.Invoice__c.Total_Amount__c.label
                                  };
                component.set('v.DynamicLabels',VdInvlabels);
                
            } else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                this.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction( Objaction );   
        
        var action1 = component.get("c.geLabelforObject");
        action1.setParams({
            sObjName :  "Invoice__c"
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
                this.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        
        $A.enqueueAction(action1);
        
    },
    
    fetchJobInv : function(component, event, helper) {
        
        var recId = component.get("v.jobrecordId");
        var InvRec = component.get("c.getVendorInvRecords");
        
        
        InvRec.setParams({
            recordId : recId 
        });
        
        
        InvRec.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var rows=response.getReturnValue();
                 console.log('---rows---'+JSON.stringify(rows));
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                   
                    var InvLIrowcount=(row.Invoice_Line_Items__r!=null);
                    console.log('>>>>InvRec with row Related List>>>>>>>>'+JSON.stringify(InvLIrowcount));
                    console.log('>>>>InvRec with row Related List Boolean>>>>>>>>'+InvLIrowcount);
                    row.InvLink = '/'+row.Id;    
                    if (row.Vendor__c) row.Vendor__c = row.Vendor__r.Name;
                    if (row.Purchase_Order__c) row.Purchase_Order__c = row.Purchase_Order__r.Name;
                    row.isInvLI = InvLIrowcount;
                    console.log('>>>>InvRec with row Related List length>>>>>>>>'+(InvLIrowcount!=null));
                }
                component.set("v.data",rows);
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                this.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        
        var sumAction = component.get("c.getTotalAmountForSections");
        sumAction.setParams({
            ObjectName : "Inv",
            Jobid:component.get("v.jobrecordId")
        });
        sumAction.setCallback(this, function(res) {
            if (res.getState() === "SUCCESS") {
                component.set("v.TotalAmount",res.getReturnValue());
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',res.getError()[0].message);
                var errors = res.getError();
                this.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        
        
        $A.enqueueAction(sumAction);
        $A.enqueueAction(InvRec);
    },
    
    
    getRowActions: function (component, row, doneCallback) {
        
        var actions = [];
        var editAction = {
            'label': 'Edit',
            'iconName': 'utility:edit',
            'name': 'Edit_Inv'
        };
        
        var deleteAction = {
            'label': 'Delete',
            'iconName': 'utility:delete',
            'name': 'Delete_Inv'
        };
        if(row.isInvLI)
        {
            deleteAction['disabled'] = 'true';
        }
        
        actions.push(editAction,deleteAction);
        
        // simulate a trip to the server
        setTimeout($A.getCallback(function () {
            doneCallback(actions);
        }), 200);
    },
    
    /*
     * This function get called when user clicks on Save button
     * user can get all modified records
     * and pass them back to server side controller
     * */
    saveDataTable : function(component, event, helper) {
        var editedRecords =  component.find("InvDataTable").get("v.draftValues");
        var totalRecordEdited = editedRecords.length;
        var action = component.get("c.updateInv");
        action.setParams({
            'editedInvList' : editedRecords
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //if update is successful
                if(response.getReturnValue() === 'true'){
                    this.showToast({
                        "title": "Record Update",
                        "type": "success",
                        "message": totalRecordEdited+" Invoice Records Updated"
                    });
                    
                    // helper.reloadDataTable();
                    helper.fetchJobInv(component, event, helper);
                    component.find("InvDataTable").set("v.draftValues", null);
                    
                } else{ //if update got failed
                    this.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": response.getReturnValue()
                    });
                    
                }      
            }
        });
        $A.enqueueAction(action);
    },
    
    /*
     * Show toast with provided params
     * */
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
    
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.data");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        if(fieldName=='InvLink'){
            data.sort(this.sortBy('Name', reverse))
        } else{
            data.sort(this.sortBy(fieldName, reverse))
        }
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
    
    CreateInvRecord:  function(component, event, helper){
        var action = component.get("c.getFieldsforObject");
        action.setParams({
            sObjName : "Invoice__c"
        });
        action.setCallback(this, function(response) {
            console.log("=====Field set====", response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                component.set("v.fieldset",response.getReturnValue()); 
            }
             else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                this.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        
        $A.enqueueAction(action);
    },
    
    getVendor:  function(component, event, helper){
        var actionVen = component.get("c.getInvVendors");
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
            } 
             else {
                console.log('>>>>>> Error >>>>>>>>>>',responseVen.getError()[0].message);
                var errors = responseVen.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        }); 
        $A.enqueueAction(actionVen);  
    },
    
    deleteJobInv: function(component, event, helper,selectVdInvId){
        var DeleteInv=component.get("c.deleteInv");
        if(selectVdInvId!=null || selectVdInvId!=undefined){
            DeleteInv.setParams({InvRecId :selectVdInvId });
        }else{
            var row = event.getParam('row');
            console.log('===Delete Inv Id=='+row.Id);
            DeleteInv.setParams({InvRecId :row.Id });
        }
        
        DeleteInv.setCallback(this, function(DeleteInvRes){
            var delresult = DeleteInvRes.getReturnValue();
            console.log('=====delresult====='+JSON.stringify(delresult));
            if(DeleteInvRes.getState() === "SUCCESS"){
                if(delresult[0]=="OK"){
                    helper.fetchJobInv(component, event, helper);
                    var ToastMsg = $A.get("e.force:showToast");
                    ToastMsg.setParams({
                        "type": "success",
                        "message":'Record Deleted Successfully.'
                    });
                    ToastMsg.fire();
                }
                else
                {
                    var ToastMsg = $A.get("e.force:showToast");
                    ToastMsg.setParams({
                        "title": "Error!!",
                        "type": "error",
                        "message":delresult[1]
                    });
                    ToastMsg.fire();
                }
            }
            else
            {
                var ToastMsg = $A.get("e.force:showToast");
                ToastMsg.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message":delresult[1]
                });
                ToastMsg.fire();
            }
        });
        $A.enqueueAction(DeleteInv);  
    },
    
})