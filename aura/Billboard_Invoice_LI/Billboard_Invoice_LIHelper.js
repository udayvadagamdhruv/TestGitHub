({
    getFieldLabels: function(component, event, helper) {
        
       var rowActions = helper.getRowActions.bind(this, component); 
       var Objaction = component.get( "c.FetchObjectType" );
        Objaction.setParams({
            ObjNames : 'Billboard_Invoice_Line_Item__c'
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
                    {label: tableHeader.Billboard_Invoice_Line_Item__c.Name.label, fieldName: 'NameLink', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: '_self' ,tooltip:{ fieldName: 'Name' }}},
                    {label: tableHeader.Billboard_Invoice_Line_Item__c.GL_Department__c.label, fieldName: 'GLDLink', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'GL_Department__c' }, target: '_self' ,tooltip:{ fieldName: 'GL_Department__c' }}},
                    {label: tableHeader.Billboard_Invoice_Line_Item__c.GL_Code__c.label, fieldName: 'GLCLink', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'GL_Code__c' }, target: '_self' ,tooltip:{ fieldName: 'GL_Code__c' }}},
                    {label: tableHeader.Billboard_Invoice_Line_Item__c.GL_Code_No__c.label, fieldName: 'GL_Code_No__c',sortable: true, type: 'text'},
                    {label: tableHeader.Billboard_Invoice_Line_Item__c.Unit_Type__c.label, fieldName: 'Unit_Type__c',sortable: true, type: 'text'},
                    {label: tableHeader.Billboard_Invoice_Line_Item__c.Quantity__c.label, fieldName: 'Quantity__c',sortable: true, type: 'number',editable:true, cellAttributes: {alignment: 'left' }},
                    {label: tableHeader.Billboard_Invoice_Line_Item__c.Amount__c.label, fieldName: 'Amount__c', sortable: true, type: 'currency',editable:true, cellAttributes: {alignment: 'left' }}
                    
                ]); 
                
                
            } else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                this.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'BB Invoice Line Item has '+errors[0].message
                }); 
            }
        });
        $A.enqueueAction(Objaction); 
       
        var action1 = component.get("c.geLabelforObject");
        action1.setParams({
            sObjName :  "Billboard_Invoice_Line_Item__c"
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
                    "message": 'BB Invoice Line Item has '+errors[0].message
                }); 
            }
        });
        
        $A.enqueueAction(action1);
        
    },
    
    
    fetchBBInvLIRec : function(component, event, helper) {
        var recId=component.get("v.recordId");
        console.log('>>>>Billboard Invoice Record ID >>>>>>>>>>>>'+recId);
        var fetchBBInvLIRec=component.get("c.getBBInvLIrecords");
        fetchBBInvLIRec.setParams({
            recordId:recId
        });
        fetchBBInvLIRec.setCallback(this, function(response){
            var state=response.getState();
            if(state === 'SUCCESS')
            {
                var rows=response.getReturnValue();
                console.log('>>>> Rows >>>>>>>>>>>>'+JSON.stringify(rows));
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    console.log('>>>>>>>>>>>>'+JSON.stringify(row));
                    if(row.Name){
                        row.NameLink='/'+row.Id;    
                        row.Name=row.Name;
                    }
                    if(row.GL_Department__c){
                        row.GLDLink='/'+row.GL_Department__c;    
                        row.GL_Department__c=row.GL_Department__r.Name;
                    }
                     if(row.GL_Code__c){
                        row.GLCLink='/'+row.GL_Code__c;    
                        row.GL_Code__c=row.GL_Code__r.Name;
                    }
                   
                }
                component.set("v.data",rows);
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                this.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'BB Invoice Line Item has '+errors[0].message
                }); 
            }
        });
        $A.enqueueAction(fetchBBInvLIRec);
    },
    
    getRowActions: function (component, row, doneCallback) {
        var actions = [];
        var editAction = {
            'label': 'Edit',
            'iconName': 'utility:edit',
            'name': 'Edit_BBInvLI'
        };
        
        var deleteAction = {
            'label': 'Delete',
            'iconName': 'utility:delete',
            'name': 'Delete_BBInvLI'
        };
        
        actions.push(editAction,deleteAction);
        // simulate a trip to the server
        setTimeout($A.getCallback(function () {
            doneCallback(actions);
        }), 200);
    },
    
     FetchFieldfromFS :  function(component, event, helper){
        var action = component.get("c.getFieldsforObject");
        action.setParams({
            sObjName : "Billboard_Invoice_Line_Item__c"
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
                    "message": 'BB Invoice Line Item has '+errors[0].message
                }); 
            }
        });
        
        $A.enqueueAction(action);
    },
    
     /*********************************************************************************************************************************************
     * This function get called when user clicks on Save button.
     * user can get all modified records.
     * and pass them back to server side controller.
     * *******************************************************************************************************************************************/
    
    saveDataTable : function(component, event, helper) {
        var editedRecords =  component.find("BBInvLIDatatable").get("v.draftValues");
        console.log('=====editedRecords======='+JSON.stringify(editedRecords));
        var totalRecordEdited = editedRecords.length;
        var action = component.get("c.updateBBInvLI");
        action.setParams({
            'editedBBInvLIList' : editedRecords
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //if update is successful
                if(response.getReturnValue() === 'true'){
                    this.showToast({
                        "title": "Record Update",
                        "type": "success",
                        "message": totalRecordEdited+" Records Updated"
                    });
                    
                    //helper.reloadDataTable();
                    helper.fetchBBInvLIRec(component, event, helper);
                    component.find("BBInvLIDatatable").set("v.draftValues", null);
                    
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
    
    deleteBBInvLI: function(component, event, helper){
        var row = event.getParam('row');
        console.log('===Delete BBInv Id=='+row.Id);     
        var DeleteBBInvLI=component.get("c.DeleteBBInvLI");
        DeleteBBInvLI.setParams({BBInvLIId :row.Id });
        DeleteBBInvLI.setCallback(this, function(DeleteBBInvres){
            var delresult = DeleteBBInvres.getReturnValue();
            console.log('===delresult=='+JSON.stringify(delresult));
            if(DeleteBBInvres.getState() === "SUCCESS"){
                if(delresult[0]=="OK"){
                    helper.fetchBBInvLIRec(component, event, helper);
                    var ToastMsg = $A.get("e.force:showToast");
                    ToastMsg.setParams({
                        "type": "success",
                        "message":'Record Deleted Successfully.'
                    });
                    ToastMsg.fire();
                }
                else{
                    var ToastMsg = $A.get("e.force:showToast");
                    ToastMsg.setParams({
                        "title": "Error!!",
                        "type": "error",
                        "message":delresult[0]
                    });
                    ToastMsg.fire();
                }
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',DeleteBBInvres.getError()[0].message);
                var errors = DeleteBBInvres.getError();
                this.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'BB Invoice Line Item has '+errors[0].message
                }); 
            }
        });
        $A.enqueueAction(DeleteBBInvLI);  
    }
})