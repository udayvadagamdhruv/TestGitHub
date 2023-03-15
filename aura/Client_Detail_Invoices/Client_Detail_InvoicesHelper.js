({
    getFieldLabels: function(component, event, helper) {
       
        var Objaction = component.get( "c.getObjectType" );
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
                    {label: tableHeader.Client_Invoice__c.Name.label, fieldName: 'InvLink', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'Invoice' }, target: '_self', tooltip :{ fieldName: 'Invoice' }} },
                    {label: tableHeader.Client_Invoice__c.Job__c.label, fieldName: 'JobLink', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'JobName' }, target: '_self', tooltip :{ fieldName: 'JobName' }} },
                    {label: tableHeader.Client_Invoice__c.Invoice_Date__c.label, fieldName: 'Invoice_Date__c',sortable: true, type: 'date-local', cellAttributes: { iconName: 'utility:event', iconAlternativeText: 'Start Date'}},
                    {label: tableHeader.Client_Invoice__c.Date_Due__c.label, fieldName: 'Date_Due__c',sortable: true, type: 'date-local', cellAttributes: { iconName: 'utility:event', iconAlternativeText: 'Completion Date'}},
                    {label: tableHeader.Client_Invoice__c.Invoice_Total__c.label, fieldName: 'Invoice_Total__c',sortable: true, type: 'currency'},
                    {label: tableHeader.Client_Invoice__c.Invoice_Status__c.label, fieldName: 'Invoice_Status__c', sortable: true,  type: 'text'},
                    {label: tableHeader.Client_Invoice__c.Term__c.label, fieldName: 'Term__c',sortable: true, type: 'text'},
                    {label: tableHeader.Client_Invoice__c.Notes__c.label, fieldName: 'Notes__c',sortable: true, type: 'text'}
                ]);  
                               
            } else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                this.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Client Invoice has '+errors[0].message
                }); 
            }
        });
        $A.enqueueAction( Objaction );   
    },
    
    
    fetchCInv : function(component, event,selectd){
        
        var recId = component.get("v.recordId");
        console.log('>>>>>>>>>Client ID>>>>>>>>>>>>'+recId);
        console.log('>>>>>>>>>Status>>>>>>>>>>>>'+selectd);
		var CInvRec = component.get("c.getClientInvs");
      
        CInvRec.setParams({
            "recordLimit": component.get("v.initialRows"),
            "recordOffset": component.get("v.rowNumberOffset"),
            "recordId" : recId
        });
        
        CInvRec.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var rows=response.getReturnValue();
                console.log('>>>>>>>>>Client Inv Rowsssss >>>>>>>>>>>>'+JSON.stringify(rows));
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i]
                    row.InvLink = '/'+row.Id;
                    row.Invoice = row.Name;
                    row.JobLink = '/'+row.Job__c;
                    row.JobName = row.Job__r.Name;
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
                    "message":'Client Invoice has '+errors[0].message
                });
                toastEvent.fire();
                
            }
        });
        
        var action1 = component.get("c.geLabelforObject");
        action1.setParams({
            sObjName :  "Client_Invoice__c"
        });
        action1.setCallback(this, function(response){
            var state = response.getState();
            console.log("label name" + response.getReturnValue());
            if(state === "SUCCESS"){
                component.set("v.ClientInvLabelname", response.getReturnValue());
            } 
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                this.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Client Invoice has '+errors[0].message
                }); 
            }
        });
        
        $A.enqueueAction(action1);
		$A.enqueueAction(CInvRec);
    },
    
    getTotalNumberOfRecords : function(component) {
        var recId = component.get("v.recordId");
        console.log('>>>>>>>>>Client ID>>>>>>>>>>>>'+recId);
        var TotalRecaction = component.get("c.getTotalCInvRecords");
        TotalRecaction.setParams({
            "recordId" : recId
           // "JobStatusString": selectd
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
                    "message":'Client Invoice has '+errors[0].message
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(TotalRecaction);
    },
    
    getMoreRec: function(component , rows){
        return new Promise($A.getCallback(function(resolve, reject) {
            var action = component.get('c.getClientInvs');
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
                "recordId" : recId
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
                this.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Client Invoice has '+errors[0].message
                }); 
            }                
            });
            $A.enqueueAction(action);
        }));
    },
    
     sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.data");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
      //  data.sort(this.sortBy(fieldName, reverse))
         if(fieldName=='InvLink'){
              data.sort(this.sortBy('Invoice', reverse))
         }else if(fieldName=='JobLink'){
             data.sort(this.sortBy('JobName', reverse))
         }else{
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