({
	
    getFieldLabels: function(component, event, helper) {
        
        var rowActions = helper.getRowActions.bind(this, component);
        var Objaction = component.get( "c.FetchObjectType" );
        Objaction.setParams({
            ObjNames : 'Client_Invoice__c'
        }); 
        Objaction.setCallback( helper, function( response ) {
            console.log('>>>>>> Enter >>>>>>>>>>');
            if(component.isValid() && response.getState() === 'SUCCESS' ) {
                // Parse the JSON string into an object
                component.set( 'v.ObjectType', JSON.parse( response.getReturnValue() ) );
                console.log('>>>>>> Result of labels >>>>>>>>>>'+JSON.stringify(JSON.parse( response.getReturnValue() )));
                
                var tableHeader=component.get('v.ObjectType');
                console.log('>>>Field Name Dynamically >>>>>>>>>>>>>'+tableHeader);
                
                component.set('v.columns', [
                    {type: 'action', typeAttributes: {rowActions: rowActions}},
                    {label: tableHeader.Client_Invoice__c.Name.label, fieldName: 'CLILink', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: '_self' ,tooltip:{ fieldName: 'Name' }}},
                    {label: tableHeader.Client_Invoice__c.Client_Name__c.label, fieldName: 'ClientLink', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'ClientName' }, target: '_self' ,tooltip:{ fieldName: 'ClientName' }}},
                    {label: tableHeader.Client_Invoice__c.Payment_Term__c.label, fieldName: 'Payment_Term__c',sortable: true, type: 'text'},
                    {label: tableHeader.Client_Invoice__c.Invoice_Date__c.label, fieldName: 'Invoice_Date__c', editable:'true', sortable: true, type: 'date-local' , cellAttributes: { iconName: 'utility:event', iconAlternativeText: 'Invoice Date'}},
                    {label: tableHeader.Client_Invoice__c.Date_Due__c.label, fieldName: 'Date_Due__c', editable:'true', sortable: true, type: 'date-local' , cellAttributes: { iconName: 'utility:event', iconAlternativeText: 'Date Due'} },
                    {label: tableHeader.Client_Invoice__c.Invoice_Status__c.label, fieldName: 'Invoice_Status__c',sortable: true, type: 'text'},
                    {label: tableHeader.Client_Invoice__c.Invoice_Total_new__c.label, fieldName: 'Invoice_Total_new__c',sortable: true, type: 'currency'}
                    
                ]);  
                 var labels = {'ClientName':tableHeader.Client_Invoice__c.Client_Name__c.label,
                               'Payment':tableHeader.Client_Invoice__c.Payment_Term__c.label,
                               'InvoiceDate':tableHeader.Client_Invoice__c.Invoice_Date__c.label,
                               'DueDate':tableHeader.Client_Invoice__c.Date_Due__c.label,
                               'Status':tableHeader.Client_Invoice__c.Invoice_Status__c.label,
                               'Total':tableHeader.Client_Invoice__c.Invoice_Total_new__c.label
                              };
                    component.set('v.DynamicLabels',labels);
                
                
            } else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError());
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction( Objaction );
        
        var action1 = component.get("c.geLabelforObject");
        action1.setParams({
            sObjName :  "Client_Invoice__c"
        });
        action1.setCallback(this, function(response){
            var state = response.getState();
            console.log("label name" + response.getReturnValue());
            if(state === "SUCCESS"){
                component.set("v.Labelname", response.getReturnValue());
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError());
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
    
    
    ClientInvAccess : function(component, event, helper) {
        
    },
    
    fetchJobCLI : function(component, event, helper) {
        
        var recId = component.get("v.recordId");
        console.log('==recId==='+recId);
		var CLIRec = component.get("c.getCLIrecords");
        CLIRec.setParams({
            recordId : recId 
        });
        CLIRec.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
               var rows=response.getReturnValue();
                for (var i = 0; i < rows.length; i++) {
                var row = rows[i];
                    console.log('>>>>>>>>>>>>'+JSON.stringify(row));
                row.CLILink = '/'+row.Id;    
                 if(row.Client_Name__c){
                        row.ClientLink='/'+row.Client_Name__c;
                        row.ClientName=row.Client_Name__r.Name;
                    }
                    
               }
                component.set("v.data",rows);
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError());
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Client Invoice has '+errors[0].message
                }); 
            }
        });
        
        
        $A.enqueueAction(CLIRec);
    },
    
    
    getRowActions: function (component, row, doneCallback) {
        var actions = [];
        
        var editAction = {
            'label': 'Edit',
            'iconName': 'utility:edit',
            'name': 'Edit_CLI'
        };
        
        var deleteAction = {
            'label': 'Delete',
            'iconName': 'utility:delete',
            'name': 'Delete_CLI'
        };
        
        var PrintAction = {
            'label': 'Print',
            'iconName': 'utility:print',
            'name': 'Print_CLI'
        };
        
      actions.push(editAction,deleteAction,PrintAction);
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
        var editedRecords =  component.find("CLIDataTable").get("v.draftValues");
        var totalRecordEdited = editedRecords.length;
        var action = component.get("c.updateCLI");
        action.setParams({
            'editCLIList' : editedRecords
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //if update is successful
                if(response.getReturnValue() === 'true'){
                    helper.showToast({
                        "title": "Record Update",
                        "type": "success",
                        "message": totalRecordEdited+" Client Invoice Records Updated"
                    });
                    
                   // helper.reloadDataTable();
                    helper.fetchJobCLI(component, event, helper);
                    component.find("CLIDataTable").set("v.draftValues", null);
                    
                } else{ //if update got failed
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": response.getReturnValue()
                    });
                   
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
    
    FetchFieldsfromFS:  function(component, event, helper){
        var action = component.get("c.getFieldsforObject");
        action.setParams({
            sObjName : "Client_Invoice__c"
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
    
    getClient: function(component, event, helper){
         var action1 = component.get("c.getClients");
         action1.setCallback(this, function(response1) {
            console.log("=====Client List====", response1.getReturnValue());
            var Cli=response1.getReturnValue();
            var clients=[];
            if(response1.getState() === "SUCCESS"){
                for (var key in Cli) {
                    clients.push({
                        key: key,
                        value: Cli[key]
                    });
                }
                component.set("v.ClientRecords", clients); 
            } 
            else {
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
    
    deleteJobCLI: function(component, event, helper){
        var row = event.getParam('row');
        console.log('===Delete CLI Id=='+row.Id);     
        var DeleteCLII=component.get("c.DeleteCLI");
        DeleteCLII.setParams({CLId :row.Id });
        DeleteCLII.setCallback(this, function(DeleteCLIres){
            var delresult = DeleteCLIres.getReturnValue();
            console.log('===State=='+DeleteCLIres.getState());
            console.log('===delelteresult for the client invoice=='+JSON.stringify(delresult));
            if(DeleteCLIres.getState() === "SUCCESS"){
                console.log('>>>>>Success>>>>');
                if(delresult[0]=="OK"){
                    console.log('>>>>>OK>>>>');
                    helper.fetchJobCLI(component, event, helper);
                    var ToastMsg = $A.get("e.force:showToast");
                    ToastMsg.setParams({
                        "type": "success",
                        "message":'Record Deleted Successfully.'
                    });
                    ToastMsg.fire();
                }
                else{
                    console.log('>>>>>Error>>>>',delresult[0]);
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
        $A.enqueueAction(DeleteCLII);  
    }
    
      
})