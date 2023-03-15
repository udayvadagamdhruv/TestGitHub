({
	 getFieldLabels: function(component, event, helper) {
       
        var Objaction = component.get( "c.getObjectType" );
        Objaction.setParams({
            ObjNames : 'Job__c'
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
                    {label: tableHeader.Job__c.Job_Auto_Number__c.label, fieldName: 'Job_Auto_Number__c', sortable: true, type: 'integer'},
                    {label: tableHeader.Job__c.Name.label, fieldName: 'JobLink', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: '_self', tooltip :{ fieldName: 'Name' }} },
                    {label: tableHeader.Job__c.Start_Date__c.label, fieldName: 'Start_Date__c',sortable: true,sortable: true, type: 'date-local' , cellAttributes: { iconName: 'utility:event', iconAlternativeText: 'Start Date'}},
                    {label: tableHeader.Job__c.Completion_Date__c.label, fieldName: 'Completion_Date__c', sortable: true, type: 'date-local' , cellAttributes: { iconName: 'utility:event', iconAlternativeText: 'Completion Date'}},
                    {label: tableHeader.Job__c.Due_Date__c.label, fieldName: 'Due_Date__c', sortable: true, type: 'date-local' , cellAttributes: { iconName: 'utility:event', iconAlternativeText: 'Due Date'}},
                    {label: tableHeader.Job__c.Status__c.label, fieldName: 'Status__c',sortable: true, type: 'text'},
                ]);  
            } else {
                    console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                this.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Client Contact jobs has '+errors[0].message
                });
            }
        });
        $A.enqueueAction( Objaction );   
    },
    
    
    fetchCConJobs : function(component, event, helper) {
        
        var recId = component.get("v.recordId");
        console.log('>>>>>>>>>Client Contact ID>>>>>>>>>>>>'+recId);
        console.log('>>>>>>>>>initialRows>>>>>>>>>>>'+component.get("v.initialRows"));
       console.log('>>>>>>>>>rowNumberOffset>>>>>>>>>>>'+component.get("v.rowNumberOffset"));
		var CConRec = component.get("c.ClientContactJobs");
        CConRec.setParams({         
            "recordLimit": component.get("v.initialRows"),
            "recordOffset": component.get("v.rowNumberOffset"),
            "recordId" : recId
        });
        CConRec.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var rows=response.getReturnValue();
                console.log('>>>>>>>>> Rowsssss >>>>>>>>>>>>'+JSON.stringify(rows));
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i]
                    row.JobLink = '/'+row.Id; 
                    row.Name = row.Name; 
                }
                component.set("v.data",rows);
                console.log('----rows length---'+rows.length);
                component.set("v.currentCount", component.get("v.initialRows"));
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                this.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Client Contact jobs has '+errors[0].message
                }); 
            }
        });
		$A.enqueueAction(CConRec);
    },
    
    getTotalNumberOfRecords : function(component) {
        var recId = component.get("v.recordId");
        console.log('>>>>>>>>>Client contact ID>>>>>>>>>>>>'+recId);
        var TotalRecaction = component.get("c.getTotalClientContactJobs");
        TotalRecaction.setParams({
            "recordId" : recId
           // "JobStatusString": selectd
        });
        TotalRecaction.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" ) {
                var resultData = response.getReturnValue();
                console.log('--resultData---'+resultData);
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
            var action = component.get('c.ClientContactJobs');
            console.log('>>>>>getMoreRec>>>');
            var recordOffset = component.get("v.currentCount");
            console.log('>>>>>recordOffset>>>'+recordOffset);
            var recordLimit = component.get("v.initialRows");
            console.log('>>>>>recordLimit>>>'+recordLimit);
            var recId = component.get("v.recordId");
            console.log('>>>>>>>>>Client contact ID>>>>>>>>>>>>'+recId);
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
        if(fieldName=='JobLink'){
          data.sort(this.sortBy('Name', reverse))  
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