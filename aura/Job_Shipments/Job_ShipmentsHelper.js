({
    
    getFieldLabels: function(component, event, helper) {
        
         var rowActions = helper.getRowActions.bind(this, component);
        var Objaction = component.get( "c.getObjectType" );
        Objaction.setParams({
            ObjNames : 'Shipment__c'
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
                    {label: tableHeader.Shipment__c.Name.label, fieldName: 'ShpLink', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'Shipment_Name__c' }, target: '_self' ,tooltip:{ fieldName: 'Shipment_Name__c' }}},
                    {label: tableHeader.Shipment__c.Shipping_Method__c.label, fieldName: 'Shipping_Method__c', sortable: true, type: 'text'},
                    {label: tableHeader.Shipment__c.Tracking_Number__c.label, fieldName: 'tracklink',sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'Tracking_Number__c' }, target: '_self'}},
                    {label: tableHeader.Shipment__c.Shipment_Status__c.label, fieldName: 'Shipment_Status__c',sortable: true, type: 'text'}
                    
                ]); 
                 var labels = {'ShpMethod':tableHeader.Shipment__c.Shipping_Method__c.label,
                               'TrackingNumber':tableHeader.Shipment__c.Tracking_Number__c.label,
                               'Status':tableHeader.Shipment__c.Shipment_Status__c.label
                              };
                    component.set('v.DynamicLabels',labels);
                
            } else {
                console.log('>>>>>> else >>>>>>>>>>');
                // console.error( 'Error calling action "' + actionName + '" with state: ' + response.getState() );
            }
        });
        $A.enqueueAction( Objaction ); 
        
        
         var action1 = component.get("c.geLabelforObject");
        action1.setParams({
            sObjName :  "Shipment__c"
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
    
    fetchJobShipments : function(component, event, helper) {
        var recId=component.get("v.jobrecordId");
        console.log('>>>> Shp Record ID >>>>>>>>>>>>'+recId);
        var fetchShp=component.get("c.getShipmentrecords");
        fetchShp.setParams({
            recordId:recId
        });
        fetchShp.setCallback(this, function(response){
            var state=response.getState();
            if(state === 'SUCCESS')
            {
                var rows=response.getReturnValue();
                console.log('>>>>Shp Rows >>>>>>>>>>>>'+JSON.stringify(rows));
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    console.log('>>>>>>>>>>>>'+JSON.stringify(row));
                    if(row.Shipment_Name__c){
                        row.ShpLink='/'+row.Id;    
                        row.ShpName=row.Shipment_Name__c;
                    }
                     if(row.Tracking_Number__c){
                        row.tracklink='https://www.ups.com/track?loc=en_US&tracknum='+row.Tracking_Number__c+'&requester=WT/trackdetails';    
                         //row.ShpName=row.Shipment_Name__c;
                    }
                }
                component.set("v.data",rows);
            }
        });
        $A.enqueueAction(fetchShp);
    },
    
    getRowActions: function (component, row, doneCallback) {
        var actions = [];
        var editAction = {
            'label': 'Edit',
            'iconName': 'utility:edit',
            'name': 'Edit_Shp'
        };
        
        var deleteAction = {
            'label': 'Delete',
            'iconName': 'utility:delete',
            'name': 'Delete_Shp'
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
            sObjName : "Shipment__c"
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
        if(fieldName=='ShpLink'){
          data.sort(this.sortBy('Shipment_Name__c', reverse))  
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
    
    deleteShp: function(component, event, helper, selectShpId){
        
        var DeleteShp=component.get("c.DeleteShp");
        if(selectShpId!=null || selectShpId!=undefined){
            DeleteShp.setParams({
                ShpId :selectShpId
            });
        }
        else{
            var row = event.getParam('row');
            DeleteShp.setParams({
                ShpId :row.Id
            });
            console.log('===Delete Shipment Id=='+row.Id);   
        }  
        DeleteShp.setCallback(this, function(DeleteShpres){
            var delresult = DeleteShpres.getReturnValue();
            console.log('===delresult for Shipment=='+JSON.stringify(delresult));
            if(DeleteShpres.getState() === "SUCCESS"){
                if(delresult[0]=="OK"){
                    helper.fetchJobShipments(component, event, helper);
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
        $A.enqueueAction(DeleteShp);  
    }
})