({
    getFieldLabels: function(component, event, helper) {
       
        var Objaction = component.get( "c.getObjectType" );
        Objaction.setParams({
            ObjNames : 'Billboard__c'
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
                    {label: tableHeader.Billboard__c.Name.label, fieldName: 'BBLink', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: '_self', tooltip :{ fieldName: 'Name' }} },
                    {label: tableHeader.Billboard__c.PMT__c	.label, fieldName: 'PMT__c', sortable: true,  type: 'currency',cellAttributes:{ alignment: 'left'}},
                    {label: tableHeader.Billboard__c.Location__c.label, fieldName: 'Location__c',sortable: true, type: 'text'},
                    {label: tableHeader.Billboard__c.Client_Name__c.label, fieldName: 'ClientLink', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'Client' }, target: '_self', tooltip :{ fieldName: 'Client' }} },
                    {label: tableHeader.Billboard__c.Expiration_Date__c.label, fieldName: 'Expiration_Date__c', sortable: true, type: 'date-local', cellAttributes: { iconName: 'utility:event', iconAlternativeText: 'Expiration Date'}}
                ]);
                
            } else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Vendor Billboard has '+errors[0].message
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction( Objaction );   
    },
    
    
    fetchVBB : function(component,event,selectd) {
        var recId = component.get("v.recordId");
        console.log('>>>>>>>>>Vendor ID>>>>>>>>>>>>'+recId);
        var VBBRec = component.get("c.getvendorBB");
        VBBRec.setParams({
            "recordLimit": component.get("v.initialRows"),
            "recordOffset": component.get("v.rowNumberOffset"),
            "recordId" : recId,
            "Status": selectd
        });
        
        VBBRec.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var rows=response.getReturnValue();
                console.log('>>>>>>>>>Vendor BB Rowsssss >>>>>>>>>>>>'+JSON.stringify(rows));
               for (var i = 0; i < rows.length; i++) {
                    var row = rows[i]
                    row.BBLink = '/'+row.Id; 
                    row.Name = row.Name;
                   if(row.Client_Name__c!=undefined || row.Client_Name__c!=null){
                       row.ClientLink = '/'+row.Client_Name__c; 
                       row.Client = row.Client_Name__r.Name;
                   }
                  
                }
                component.set("v.data",rows);
                component.set("v.currentCount", component.get("v.initialRows"));
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
               var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Vendor Billboards has '+errors[0].message
                });
                toastEvent.fire();
            }
        });
        
        var action1 = component.get("c.geLabelforObject");
        action1.setParams({
            sObjName :  "Billboard__c"
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
               var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Vendor Billboard has '+errors[0].message
                });
                toastEvent.fire();
            }
        });
        
        $A.enqueueAction(action1);
        $A.enqueueAction(VBBRec);
    },
    
    getTotalNumberOfRecords : function(component,event,selectd) {
        var recId = component.get("v.recordId");
        console.log('>>>>>>>>>Vendor ID>>>>>>>>>>>>'+recId);
        var TotalRecaction = component.get("c.getTotalVBBRecords");
        TotalRecaction.setParams({
            "recordId" : recId,
            "Status": selectd
        });
        TotalRecaction.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" ) {
                var resultData = response.getReturnValue();
                component.set("v.totalNumberOfRows", resultData);
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Vendor Billboards has '+errors[0].message
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(TotalRecaction);
    },
  
    getMoreRec:  function(component, rows,selectd){
        return new Promise($A.getCallback(function(resolve, reject) {
            var action = component.get('c.getvendorBB');
            console.log('>>>>>getMoreRec>>>');
            var recordOffset = component.get("v.currentCount");
            console.log('>>>>>recordOffset>>>'+recordOffset);
            var recordLimit = component.get("v.initialRows");
            console.log('>>>>>recordLimit>>>'+recordLimit);
            var recId = component.get("v.recordId");
            console.log('>>>>>>>>>Client ID>>>>>>>>>>>>'+recId);
            action.setParams({
                "recordLimit": recordLimit,
                "recordOffset": recordOffset,
                "recordId" : recId,
                 "Status": selectd
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS"){
                    var resultData = response.getReturnValue();
                    resolve(resultData);
                    recordOffset = recordOffset+recordLimit;
                    component.set("v.currentCount", recordOffset);   
                }
                else {
                    console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                    var errors = response.getError();
                     var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!!",
                        "type": "error",
                        "message": 'Vendor Billboards has '+errors[0].message
                    });
                    toastEvent.fire();
                }
                
            });
            $A.enqueueAction(action);
        }));
    },
    
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.data");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        if(fieldName=='BBLink'){
             data.sort(this.sortBy('Name', reverse))
        }else if(fieldName=='ClientLink'){
            data.sort(this.sortBy('Client', reverse))
        } else{
            data.sort(this.sortBy(fieldName, reverse))
        }
        cmp.set("v.data", data);
    },
    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
        function(x) {return x[field]};
        //checks if the two rows should switch places
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
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
    }
    
})