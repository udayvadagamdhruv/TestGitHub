({
    getFieldLabels: function(component, event, helper) {
        
        var rowActions = helper.getRowActions.bind(this, component);
        var Objaction = component.get( "c.getObjectType" );
        Objaction.setParams({
            ObjNames : ['Shipment_Line_Item__c','Job__c']
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
                    {label: tableHeader.Shipment_Line_Item__c.Name.label, fieldName: 'ItemLink', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'ItemName' }, target: '_self' ,tooltip:{ fieldName: 'ItemName' }}},
                    {label: tableHeader.Shipment_Line_Item__c.Job_Name__c.label, fieldName: 'Job_Name__c', sortable: true, type: 'text'},
                    {label: tableHeader.Shipment_Line_Item__c.Job__c.label, fieldName: 'Job__c',sortable: true, type: 'text'},
                    {label: tableHeader.Shipment_Line_Item__c.Client_Name__c.label, fieldName: 'Client_Name__c',sortable: true, type: 'text'},
                    {label: tableHeader.Shipment_Line_Item__c.Item_Status__c.label, fieldName: 'Item_Status__c',sortable: true, type: 'text'},
                    {label: tableHeader.Shipment_Line_Item__c.Qty_Shipped__c.label, fieldName: 'Qty_Shipped__c',sortable: true, editable:'true',type: 'number',cellAttributes: {alignment: 'left' }}
                    
                ]); 
                var labels = {'Job':tableHeader.Shipment_Line_Item__c.Job_Name__c.label,
                              'ClientName':tableHeader.Shipment_Line_Item__c.Client_Name__c.label,
                              'Status':tableHeader.Shipment_Line_Item__c.Item_Status__c.label,
                              'Shipped':tableHeader.Shipment_Line_Item__c.Qty_Shipped__c.label,
                              };
                    component.set('v.DynamicLabels',labels);
                
                component.set('v.ShpLicolumns', [
                    {label: 'Line Item', fieldName: 'Name', type: 'text'},
                    {label: 'Job', fieldName: 'JobName', type: 'text'},
                    {label: 'Client', fieldName: 'ClientName', type: 'text'},
                    {label: 'Quantity', fieldName: 'Quantity__c', type: 'number',cellAttributes: {alignment: 'left' }}
                ]);
                
            } else {
                console.log('>>>>>> else >>>>>>>>>>');
                // console.error( 'Error calling action "' + actionName + '" with state: ' + response.getState() );
            }
        });
        $A.enqueueAction( Objaction ); 
        
        
         var action1 = component.get("c.geLabelforObject");
        action1.setParams({
            sObjName :  "Shipment_Line_Item__c"
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
    
    
    fetchShipmentLI : function(component, event, helper) {
        var recId=component.get("v.recordId");
        console.log('>>>> Shp Record ID >>>>>>>>>>>>'+recId);
        var fetchShpLI=component.get("c.getShipmentLIrecords");
        fetchShpLI.setParams({
            recordId:recId
        });
        fetchShpLI.setCallback(this, function(response){
            var state=response.getState();
            if(state === 'SUCCESS')
            {
                var rows=response.getReturnValue();
                console.log('>>>>Shp Rows >>>>>>>>>>>>'+JSON.stringify(rows));
                var ShoWPE=component.get("v.ShowProductionEstimate");
                console.log("====ShoWPE above===="+ShoWPE);
                
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    if(ShoWPE){
                        console.log("====ShoWPE below===="+ShoWPE);
                        if(row.Production_Estimate__c){
                            console.log('>>>>> If row PE Enter >>>>>>>>>>>>>>');
                            row.ItemLink='/'+row.Production_Estimate__c;
                            row.ItemName=row.Production_Estimate__r.Name;
                        }
                    }
                    else{
                        if(row.Estimate_Line_Item__c){
                            console.log('>>>>> If row Est Enter >>>>>>>>>>>>>>');
                            row.ItemLink='/'+row.Estimate_Line_Item__c;
                            row.ItemName=row.Estimate_Line_Item__r.Name;
                        }
                    }
                }
            }
            component.set("v.data",rows);
        });
        
        
        var CSettingAction = component.get("c.showProductionEstimate");
        CSettingAction.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                console.log('========ShowPE========='+response.getReturnValue());
                component.set("v.ShowProductionEstimate",response.getReturnValue());
                
            }
        });
        
        $A.enqueueAction(CSettingAction);    
        $A.enqueueAction(fetchShpLI);
    },
    
    AddShipmentLI : function(component, event, helper) {
        var recId=component.get("v.recordId");
        console.log('>>>> Shp Record ID >>>>>>>>>>>>'+recId);
        var AddShpLI=component.get("c.AddShipmentLIrecords");
        AddShpLI.setParams({
            recordId:recId
        });
        AddShpLI.setCallback(this, function(response){
            var state=response.getState();
            if(state === 'SUCCESS')
            {
                var rows=response.getReturnValue();
                console.log('>>>>Add Shp LI Rows >>>>>>>>>>>>'+JSON.stringify(rows));
                
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    
                    if(row.Job__c){
                        row.JobName=row.Job__r.Name;
                    }
                    
                    if(row.Job__r.JS_Client__c){
                        row.ClientName=row.Job__r.JS_Client__r.Name;
                    }
                }
                
                component.set("v.ShpLidata",rows);
				 console.log('>>>>Add Shp LI Rows >>>>>>>>>>>>'+JSON.stringify(component.get("v.ShpLidata")));
                 console.log('>>>>Add Shp LI colums >>>>>>>>>>>>'+JSON.stringify(component.get("v.ShpLicolumns")));
            }  
            
        });
        
        $A.enqueueAction(AddShpLI);
    },
    
    /*
     * This function get called when user clicks on Save button
     * user can get all modified records
     * and pass them back to server side controller
     * */
    saveDataTable : function(component, event, helper) {
        var editedRecords =  component.find("ShpDataTable").get("v.draftValues");
        var totalRecordEdited = editedRecords.length;
        var action = component.get("c.updateShpLI");
        action.setParams({
            'editedShpLIList' : editedRecords
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //if update is successful
                if(response.getReturnValue() === 'true'){
                    helper.showToast({
                        "title": "Record Update",
                        "type": "success",
                        "message": totalRecordEdited+"  Shipment Line Items Records Updated"
                    });
                    
                    helper.reloadDataTable();
                    helper.fetchShipmentLI(component, event, helper);
                    component.find("ShpDataTable").set("v.draftValues", null);
                    
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
    
    getRowActions: function (component, row, doneCallback) {
        var actions = [];
        
        var editAction = {
            'label': 'Edit',
            'iconName': 'utility:edit',
            'name': 'Edit_ShpLI'
        };
        
        var deleteAction = {
            'label': 'Delete',
            'iconName': 'utility:delete',
            'name': 'Delete_ShpLI'
        };
        
        actions.push(editAction,deleteAction);
        // simulate a trip to the server
        setTimeout($A.getCallback(function () {
            doneCallback(actions);
        }), 200);
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
    
    deleteJobShpLI: function(component, event, helper){
        var row = event.getParam('row');
        console.log('===Delete ShpLI Id=='+row.Id);     
        var DeleteShpLI=component.get("c.deleteShpLI");
        DeleteShpLI.setParams({ShpLIRecId :row.Id });
        DeleteShpLI.setCallback(this, function(DeleteShpLIres){
            var delstate = DeleteShpLIres.getState();
            if(delstate === "SUCCESS"){
                if(DeleteShpLIres.getReturnValue() === 'Deleted'){
                    helper.fetchShipmentLI(component, event, helper);
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
                        "message":DeleteShpLIres.getReturnValue()
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
                    "message":DeleteShpLIres.getReturnValue()
                });
                ToastMsg.fire();
            }
        });
        $A.enqueueAction(DeleteShpLI);  
    }
    
})