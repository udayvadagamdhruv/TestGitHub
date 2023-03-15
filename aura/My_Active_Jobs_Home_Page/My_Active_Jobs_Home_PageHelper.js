({
    fetchFieldLabels : function(component, event , helper){
        var action=component.get("c.getObjectFieldLabels");
        action.setParams({
            ObjNames:['Job__c']
        });
        
        action.setCallback(this, function(res){
            if(res.getState() === "SUCCESS"){
                var tableHeaders=JSON.parse(res.getReturnValue());
                console.log('===Estimate_Spec_Item__c====='+JSON.stringify(JSON.parse(res.getReturnValue())));
                //component.set("v.ObjectType",JSON.parse(res.getReturnValue()));
                
                component.set("v.columns",[
                    { label: tableHeaders.Job__c.Job_Auto_Number__c.label, fieldName: 'JobLink', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'jobNo' }, target: '_self', tooltip:{ fieldName: 'jobNo' }}},
                    { label: tableHeaders.Job__c.Name.label, fieldName: 'JobLinkName', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'jobName' }, target: '_self' , tooltip:{ fieldName: 'jobName' }}},
                    { label: tableHeaders.Job__c.JS_Client__c.label, fieldName: 'clientDisplay', type: 'text', sortable: true },
                    { label: tableHeaders.Job__c.Due_Date__c.label, fieldName: 'jobDuedate', type: 'date-local', sortable: true, cellAttributes: { iconName: 'utility:event', iconAlternativeText: tableHeaders.Job__c.Due_Date__c.label}},
                    { label: 'Next Task Name', fieldName: 'TaskLink', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'taskName' }, target: '_self' , tooltip:{ fieldName: 'taskName' }}},
                    { label: 'Next Task Due', fieldName: 'jobtaskDuedate', type: 'date-local', sortable: true, cellAttributes: { iconName: 'utility:event', iconAlternativeText: 'Task Due'} }
                    
                ]);
            }
            else{
                console.log('>>>>>> Error >>>>>>>>>>',res.getError()[0].message);
                var errors = res.getError();
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                });
                toastEvent.fire();
                
            }
        });
        $A.enqueueAction(action);
    },
    
    Jobrecordsfetch : function(component, event,selectd) {
        console.log('>>>>>>>>>>>Selectd>>>>>>>>>>>>>>>'+selectd);
        var action = component.get("c.getMyJobData");
        action.setParams({
            "JobStatusString": selectd
        });
        
        action.setCallback(this, function(response) {
            console.log('==  response.getState() .log=='+  response.getState());
            console.log('====Job Status response.getReturnValue()==' + JSON.stringify(response.getReturnValue()));
            
            var state = response.getState();
            var rows=response.getReturnValue();
            if (state === "SUCCESS") {
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    console.log('>>>>>>>>>>>>'+JSON.stringify(row));
                    row.JobLink = '/'+row.jobId;
                    row.JobLinkName='/'+row.jobId;
                    if(row.taskName!='')
                    {
                        row.TaskLink = '/'+row.taskId; 
                    }
                }
                component.set("v.data",rows);
            }
            else{
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                });
                toastEvent.fire();
                
            }
            
        });
        $A.enqueueAction(action);
    },
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.data");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        if(fieldName=='JobLink'){
            data.sort(this.sortBy('jobNo', reverse))
        }
        else if(fieldName=='JobLinkName'){
            data.sort(this.sortBy('jobName', reverse))
        }
            else if(fieldName=='TaskLink'){
                data.sort(this.sortBy('taskName', reverse))
            }
                else{
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
})