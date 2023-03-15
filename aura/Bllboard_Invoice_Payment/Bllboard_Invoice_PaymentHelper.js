({
    
     getFieldLabels: function(component, event, helper) {
        
       var rowActions = helper.getRowActions.bind(this, component); 
       var Objaction = component.get( "c.FetchObjectType" );
        Objaction.setParams({
            ObjNames : 'BB_Invoice_Payment__c'
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
                    {label: tableHeader.BB_Invoice_Payment__c.Name.label, fieldName: 'NameLink', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: '_self' ,tooltip:{ fieldName: 'Name' }}},
                    {label: tableHeader.BB_Invoice_Payment__c.Check_New__c.label, fieldName: 'Check_New__c', sortable: true, type: 'text'},
                    {label: tableHeader.BB_Invoice_Payment__c.Check_Date__c.label, fieldName: 'Check_Date__c', sortable: true, type: 'date-local' , cellAttributes: { iconName: 'utility:event', iconAlternativeText: 'Check Date'} },
                    {label: tableHeader.BB_Invoice_Payment__c.Vendor__c.label, fieldName: 'Vendor__c',sortable: true, type: 'text'},
                    {label: tableHeader.BB_Invoice_Payment__c.Check_Amount__c.label, fieldName: 'Check_Amount__c', sortable: true, type: 'currency', cellAttributes: {alignment: 'left' }}
                    
                ]);  
                
            } else {
                console.log('>>>>>> else >>>>>>>>>>');
                // console.error( 'Error calling action "' + actionName + '" with state: ' + response.getState() );
            }
        });
        $A.enqueueAction(Objaction); 
       
        var action1 = component.get("c.geLabelforObject");
        action1.setParams({
            sObjName :  "BB_Invoice_Payment__c"
        });
        action1.setCallback(this, function(response){
            var state = response.getState();
            console.log("label name" + response.getReturnValue());
            if(state === "SUCCESS"){
                component.set("v.Labelname", response.getReturnValue());
            } 
        });
        
        $A.enqueueAction(action1);
        
    },
    
    
    
    fetchBBInvPayRec : function(component, event, helper) {
        var recId=component.get("v.recordId");
        console.log('>>>>Billboard Invoice Record ID >>>>>>>>>>>>'+recId);
        var fetchBBInvPayRec=component.get("c.getBBInvPayrecords");
        fetchBBInvPayRec.setParams({
            recordId:recId
        });
        fetchBBInvPayRec.setCallback(this, function(response){
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
                   /* if(row.GL_Department__c){
                        row.GLDLink='/'+row.GL_Department__c;    
                        row.GL_Department__c=row.GL_Department__r.Name;
                    }
                     if(row.GL_Code__c){
                        row.GLCLink='/'+row.GL_Code__c;    
                        row.GL_Code__c=row.GL_Code__r.Name;
                    }*/
                   
                }
                component.set("v.data",rows);
            }
        });
        $A.enqueueAction(fetchBBInvPayRec);
    },
    
    getRowActions: function (component, row, doneCallback) {
        var actions = [];
        var editAction = {
            'label': 'Edit',
            'iconName': 'utility:edit',
            'name': 'Edit_BBInvPay'
        };
        
        var deleteAction = {
            'label': 'Delete',
            'iconName': 'utility:delete',
            'name': 'Delete_BBInvPay'
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
            sObjName : "BB_Invoice_Payment__c"
        });
        action.setCallback(this, function(response) {
            console.log("=====Field set====", response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                component.set("v.fieldset",response.getReturnValue()); 
            }
        });
        
        $A.enqueueAction(action);
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
    
    deleteBBInvPay: function(component, event, helper){
        var row = event.getParam('row');
        console.log('===Delete BBInv Id=='+row.Id);     
        var deleteBBInvPay=component.get("c.DeleteBBInvPay");
        deleteBBInvPay.setParams({BBInvPayId :row.Id });
        deleteBBInvPay.setCallback(this, function(DeleteBBInvPayres){
            var delresult = DeleteBBInvPayres.getReturnValue();
            console.log('===delresult=='+JSON.stringify(delresult));
            if(DeleteBBInvPayres.getState() === "SUCCESS"){
                if(delresult[0]=="OK"){
                    helper.fetchBBInvPayRec(component, event, helper);
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
        $A.enqueueAction(deleteBBInvPay);  
    }
})