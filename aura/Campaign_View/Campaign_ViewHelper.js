({
      fetchFieldLabels : function(component, event, helper) {
      var action=component.get("c.getObjectFieldLabel");
        action.setParams({
            ObjNames:['Job__c']
        });
        
        action.setCallback(this, function(res){
            if(res.getState() === "SUCCESS"){
                var tableHeaders=JSON.parse(res.getReturnValue());
                console.log('===Job_Task__c and JOb====='+JSON.stringify(JSON.parse(res.getReturnValue())));
                //component.set("v.ObjectType",JSON.parse(res.getReturnValue()));
                component.set("v.columns",[
                    { label: tableHeaders.Job__c.Job_Auto_Number__c.label, fieldName: 'JobNameLink', type: 'url', sortable: true,initialWidth:150, typeAttributes: { label: { fieldName: 'Job_Auto_Number__c' }, target: '_self', tooltip:{ fieldName: 'Job_Auto_Number__c' } }},
                    { label: tableHeaders.Job__c.Name.label, fieldName: 'JobNameLink', type: 'url', sortable: true  , typeAttributes: { label: { fieldName: 'Name' }, target: '_self', tooltip:{ fieldName: 'Name' } } },
                    { label: tableHeaders.Job__c.Status__c.label, fieldName: 'Status__c', type: 'text', sortable: true,initialWidth:150},
                    { label: tableHeaders.Job__c.Budgeted_Cost__c.label, fieldName: 'Budgeted_Cost__c', type: 'currency', sortable: true,initialWidth:150 },
                    { label: tableHeaders.Job__c.Estimate_Total__c.label, fieldName: 'Estimate_Total__c', type: 'currency', sortable: true,initialWidth:150}, 
                    { label: tableHeaders.Job__c.Invoice_Actual_Amounts__c.label, fieldName: 'Invoice_Actual_Amounts__c', type: 'currency', sortable: true,initialWidth:150},      
                ]);
                    
                var labels = {'Status':  tableHeaders.Job__c.Status__c.label,
                              'BudgetedCost':tableHeaders.Job__c.Budgeted_Cost__c.label,
                              'EstimateTotal':tableHeaders.Job__c.Estimate_Total__c.label,
                    		  'InvoiceActualAmounts':tableHeaders.Job__c.Invoice_Actual_Amounts__c.label
                             };
                
                component.set('v.DynamicLabels',labels);
                console.log('-----labels--'+JSON.stringify(labels));    
            } 
        });
        
        $A.enqueueAction(action);
    },

    
	Jobrecordsfetch : function(component, event,selectd) {
        if(selectd=='All Jobs'){
          component.find("pickJob").set("v.value",'All Jobs');
        }
        
        var action = component.get("c.RefreshJobNotes");
        action.setParams({
            "recordId": component.get("v.recordId"),
            "JobStatus": selectd
        });
        
        action.setCallback(this, function(response) {
            console.log('====Job Status response.getReturnValue()==' + response.getReturnValue());
            var state = response.getState();
            if (state === "SUCCESS") {
                var jobdata = [];
                var jobs = [];
                var jobnotes = [];
                var jobattchs = [];
                var JobChatfiles= [];
                var conts = response.getReturnValue();
                  console.log("====constant values==" + JSON.stringify(conts));
                for (var key in conts) {
                    if (key == "Jobs") {
                        jobs.push({
                            key: key,
                            value: conts[key]
                        });
                        jobdata=conts[key];
                    } else if (key == "Job__Notes") {
                        jobnotes.push({
                            key: key,
                            value: conts[key]
                        });
                    } else if (key == "Job__Attachments") {
                        jobattchs.push({
                            key: key,
                            value: conts[key]
                        });
                    } else if (key == "Job__ChatterFiles") {
                        JobChatfiles.push({
                            key: key,
                            value: conts[key]
                        });
                    }
                    
                }
                
                console.log("====job records===" + jobs);
                console.log("====job data records===" + Object.values(jobs));
                console.log("====job Notes===" + jobnotes);
                console.log("====job Job__Attachment===" + jobattchs);
                console.log("====job JobChatfiles===" + JSON.stringify(JobChatfiles));
                component.set("v.jobRecords", jobs);
                //component.set("v.data", jobdata);
                component.set("v.jobNotes", jobnotes);
                component.set("v.jobAttachs", jobattchs);
                component.set("v.jobChatterFiles", JobChatfiles);
                
                var rows=jobdata;
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    row.JobNameLink = '/'+row.Id;    
                }
                component.set("v.data",rows);
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
    
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.data");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        if(fieldName='JobNameLink'){
         data.sort(this.sortBy('Name', reverse))   
        }else{
            data.sort(this.sortBy(fieldName, reverse))
        }
        cmp.set("v.data", data);
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