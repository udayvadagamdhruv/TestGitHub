({
   getFieldLabels: function(component, event, helper) {
        
       var rowActions = helper.getRowActions.bind(this, component); 
       var Objaction = component.get( "c.FetchObjectType" );
        Objaction.setParams({
            ObjNames : 'Billboard_Invoice__c'
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
                    {label: tableHeader.Billboard_Invoice__c.Name.label, fieldName: 'NameLink', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: '_self' ,tooltip:{ fieldName: 'Name' }}},
                    {label: tableHeader.Billboard_Invoice__c.Billboard_Vendor__c.label, fieldName: 'BBVenLink', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'Billboard_Vendor__c' }, target: '_self' ,tooltip:{ fieldName: 'Billboard_Vendor__c' }}},
                    {label: tableHeader.Billboard_Invoice__c.Billboard__c.label, fieldName: 'BBLink', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'Billboard__c' }, target: '_self' ,tooltip:{ fieldName: 'Billboard__c' }}},
                    {label: tableHeader.Billboard_Invoice__c.Location__c.label, fieldName: 'Location__c',sortable: true, type: 'text'},
                    {label: tableHeader.Billboard_Invoice__c.BB_Invoice_Due_Date__c.label, fieldName: 'BB_Invoice_Due_Date__c', sortable: true, type: 'date-local', cellAttributes: { iconName: 'utility:event', iconAlternativeText: 'Date Due'} }
                    
                ]);  
                
                
            } else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                this.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Billboard Invoice has '+errors[0].message
                }); 
            }
        });
        $A.enqueueAction(Objaction); 
       
        var action1 = component.get("c.geLabelforObject");
        action1.setParams({
            sObjName :  "Billboard_Invoice__c"
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
                    "message": 'Billboard Invoice has '+errors[0].message
                }); 
            }
        });
        
        $A.enqueueAction(action1);
        
    },
    
    
    fetchBBInvRec : function(component, event, helper) {
        var recId=component.get("v.recordId");
        console.log('>>>>Billboard Record ID >>>>>>>>>>>>'+recId);
        var fetchBBInvRec=component.get("c.getBBInvrecords");
        fetchBBInvRec.setParams({
            recordId:recId
        });
        fetchBBInvRec.setCallback(this, function(response){
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
                    if(row.Billboard_Vendor__c){
                        row.BBVenLink='/'+row.Billboard_Vendor__c;    
                        row.Billboard_Vendor__c=row.Billboard_Vendor__r.Name;
                    }
                     if(row.Billboard__c){
                        row.BBLink='/'+row.Billboard__c;    
                        row.Billboard__c=row.Billboard__r.Name;
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
                    "message": 'Billboard Invoice has '+errors[0].message
                }); 
            }
        });
        $A.enqueueAction(fetchBBInvRec);
    },
    
    getRowActions: function (component, row, doneCallback) {
        var actions = [];
        var editAction = {
            'label': 'Edit',
            'iconName': 'utility:edit',
            'name': 'Edit_BBInv'
        };
        
        var deleteAction = {
            'label': 'Delete',
            'iconName': 'utility:delete',
            'name': 'Delete_BBInv'
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
            sObjName : "Billboard_Invoice__c"
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
                    "message": 'Billboard Invoice has '+errors[0].message
                }); 
            }
        });
        
        $A.enqueueAction(action);
    },
    
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.data");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        if(fieldName=='NameLink'){
           data.sort(this.sortBy('Name', reverse)) 
        }else if(fieldName=='BBVenLink'){
           data.sort(this.sortBy('Billboard_Vendor__c', reverse)) 
        }else if(fieldName=='BBLink'){
            data.sort(this.sortBy('Billboard__c', reverse))
        }else{
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
    
    deleteBBInv: function(component, event, helper){
        var row = event.getParam('row');
        console.log('===Delete BBInv Id=='+row.Id);     
        var DeleteBBInv=component.get("c.DeleteBBInv");
        DeleteBBInv.setParams({BBInvId :row.Id });
        DeleteBBInv.setCallback(this, function(DeleteBBInvres){
            var delresult = DeleteBBInvres.getReturnValue();
            console.log('===delresult for SHipment=='+JSON.stringify(delresult));
            if(DeleteBBInvres.getState() === "SUCCESS"){
                if(delresult[0]=="OK"){
                    helper.fetchBBInvRec(component, event, helper);
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
                    "message": 'Billboard Invoice has '+errors[0].message
                }); 
            }
        });
        $A.enqueueAction(DeleteBBInv);  
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