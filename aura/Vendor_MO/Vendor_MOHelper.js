({
    getFieldLabels: function(component, event, helper) {
        var rowActions = helper.getRowActions.bind(this, component);
        var Objaction = component.get( "c.getObjectType" );
        Objaction.setParams({
            ObjNames : 'Material_Order__c'
        }); 
        Objaction.setCallback( helper, function( response ) {
            console.log('>>>>>> Enter >>>>>>>>>>');
            if(response.getState() === 'SUCCESS' ) {
                var tableHeaders=JSON.parse(response.getReturnValue());
                component.set( 'v.ObjectType', JSON.parse( response.getReturnValue()));
                console.log('>>>>>> Result of labels >>>>>>>>>>'+JSON.stringify(JSON.parse( response.getReturnValue() )));
                component.set('v.columns', [
                    {type: 'action', typeAttributes: {rowActions: rowActions}},
                    {label: tableHeaders.Material_Order__c.Name.label, fieldName: 'ProEstLink',  type: 'url', sortable: true,  typeAttributes: { label: { fieldName: 'Name' }, target: '_self', tooltip :{ fieldName: 'Name' }} },
                    {label: tableHeaders.Material_Order__c.Vendor_Name__c.label, fieldName: 'Vendor_Name__c', sortable: true, type: 'text',initialWidth:200},
                    {label: tableHeaders.Material_Order__c.Issue_Date__c.label, fieldName: 'Issue_Date__c', initialWidth:200, sortable: true, type: 'date-local'  },
                    {label: tableHeaders.Material_Order__c.MO_Due_Date__c.label, fieldName: 'MO_Due_Date__c', initialWidth:200, sortable: true, type: 'date-local' },
                    {label: tableHeaders.Material_Order__c.Status__c.label, fieldName: 'Status__c',sortable: true, type: 'text',initialWidth:150 }
                    
                ]);
                var labels = {
                    'Name':tableHeaders.Material_Order__c.Name.label,
                    'Vendor':tableHeaders.Material_Order__c.Vendor_Name__c.label,
                    'IssueDate': tableHeaders.Material_Order__c.Issue_Date__c.label,
                    'DueDate':tableHeaders.Material_Order__c.MO_Due_Date__c.label,
                    'Status':tableHeaders.Material_Order__c.Status__c.label
                };
                component.set('v.DynamicLabels',labels);
                console.log('-----labels--'+JSON.stringify(labels));
                
                
            } else {
                console.log('>>>>ERROR>>>>',response.getError()[0].message);
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
            sObjName :  "Material_Order__c"
        });
        action1.setCallback(this, function(response){
            var state = response.getState();
            console.log("label name" + response.getReturnValue());
            if(state === "SUCCESS"){
                console.log("stateeeeee ===" +state);
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
    
    getRowActions: function (component, row, doneCallback) {
        var actions = [];
        
        var editAction = {
            'label': 'Edit',
            'iconName': 'utility:edit',
            'name': 'Edit_MO'
        };
        
        var deleteAction = {
            'label': 'Delete',
            'iconName': 'utility:delete',
            'name': 'Delete_MO'
        };
        
        /** if(row.Invoice_Created__c!='No'){
            deleteAction['disabled']=true;
            editAction['disabled']=true;
        }*/
        
        actions.push(editAction,deleteAction);
        
        // simulate a trip to the server
        setTimeout($A.getCallback(function () {
            doneCallback(actions);
        }), 200);
    },
    
    CreateMORecord :  function(component, event, helper){
        var action = component.get("c.getFieldsforObject");
        action.setParams({
            sObjName : "Material_Order__c"
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
    
    deleteMO  : function(component, event, helper,Moid){
       // alert('Moid == '+Moid);
        var action = component.get("c.deleteMOrcd");
        action.setParams({
            rcdids : Moid 
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
                    "message":  "Material Order Record Deleted Successfully."
                }); 
                    // helper.fetchMO(component, event, helper);
                }
                else{
                   helper.showToast({
                    "type":"Error",
                    "message":  "Unable to delete record."
                }); 
                    
                }
            }
        });
        $A.enqueueAction(action); 
    },
    
    fetchMO   :  function(component, event, helper){
        var recId = component.get("v.recordId");
        var MORec = component.get("c.getMORecords");
        MORec.setParams({
            recordId : recId 
        });
        MORec.setCallback(this, function(response) {
            console.log("stateee===="+response.getState());
            if (response.getState() === "SUCCESS") {
                var rows=response.getReturnValue();
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    
                    if(row.Name)row.ProEstLink='/'+row.Id; 
                    
                    if (row.Vendor_Name__c) row.Vendor_Name__c = row.Vendor_Name__r.Name;
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
                console.log('>>>>>> Error perr >>>>>>>>>>',response.getError()[0].message);
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