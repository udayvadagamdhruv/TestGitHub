({
    fetchFieldLabels : function(component, event , helper){
        //var rowActions = helper.getRowActions.bind(this, component);
       
        var CreateAppStepsSetting=component.get("c.CreateAppStepAtTaskJobTskSetting");
        CreateAppStepsSetting.setCallback(this, function(CreateAppStepsResponse){
            if (CreateAppStepsResponse.getState() === "SUCCESS") {
                console.log('=custom settings=='+JSON.stringify(CreateAppStepsResponse.getReturnValue()));
                component.set("v.isCreateAppSteps",CreateAppStepsResponse.getReturnValue());
            }
        });
        
        var action=component.get("c.getObjectFieldLabels");
        action.setParams({
            ObjNames:['Approval_Job_Task__c','Job__c']
        });
        
        action.setCallback(this, function(res){
            if(res.getState() === "SUCCESS"){
                var tableHeaders=JSON.parse(res.getReturnValue());
                console.log('===Approval_Job_Task__c and JOb====='+JSON.stringify(JSON.parse(res.getReturnValue())));
                component.set("v.columns",[
                    // { label: 'Color', fieldName: 'Color'},  
                   // { type: 'action', typeAttributes: {rowActions: rowActions}},
                    { label: tableHeaders.Approval_Job_Task__c.Job__c.label, fieldName: 'JobId', editable: true, sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'JobName' }, target: '_blank' , tooltip:{ fieldName: 'JobName' }}},
                    { label: tableHeaders.Approval_Job_Task__c.Name.label, fieldName: 'TaskId', sortable: true, type: 'url',cellAttributes: {class: { fieldName: "TaskColorcode" } }, typeAttributes: { label: { fieldName: 'TaskName' }, target: '_blank', tooltip:{ fieldName: 'TaskName' }}},
                    { label: tableHeaders.Approval_Job_Task__c.Due_Date__c.label, fieldName: 'TaskDue', type: 'date-local', sortable: true, cellAttributes: { iconName: 'utility:event', iconAlternativeText: tableHeaders.Approval_Job_Task__c.Revised_Due_Date__c.label} },
                    { label: tableHeaders.Approval_Job_Task__c.File_Name__c.label, fieldName: 'FileName', type: 'text', sortable: true },
                    { label: tableHeaders.Job__c.Job_Auto_Number__c.label, fieldName: 'JobIdNo', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'JobNum' }, target: '_blank', tooltip:{ fieldName: 'JobNum' }}}
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
        $A.enqueueAction(CreateAppStepsSetting); 
        $A.enqueueAction(action); 
    },
    
    MyTaskrecordsfetch : function(component, event,helper) {
        var cusSetVal=component.get("v.isCreateAppSteps");
        console.log('>>>>cusSetValcusSetVal>>>>>>>>'+cusSetVal);
        var action = component.get("c.getMyApproveTaskData");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            var rows=response.getReturnValue();
            console.log('>>>>>>>>>>>Taskssssssssssss>>>>>>>>>>>>>>>'+JSON.stringify(rows));
            
            if (state === "SUCCESS") {
                if(cusSetVal){
                    for (var i = 0; i < rows.length; i++) {
                        var row = rows[i];
                        console.log('>>>>>>>>>>>>'+JSON.stringify(row));
                        
                        row.JobId= '/'+row.Task__r.Job__c;
                        row.JobIdNo= '/'+row.Task__r.Job__c;
                        row.TaskId= '/'+row.Id;
                        row.JobName=row.Task__r.Job__r.Name;
                        row.TaskName=row.Name;
                        row.TaskDue=row.Revised_Due_Date__c;
                        row.FileName=row.File_Name__c;
                        row.JobNum=row.Task__r.Job__r.Job_Auto_Number__c;
                    }
                    component.set("v.data",rows);
                }
                else{
                    for (var i = 0; i < rows.length; i++) {
                        var row = rows[i];
                        console.log('>>>>>>>>>>>>'+JSON.stringify(row));
                        row.JobId= '/'+row.Job__c;
                        row.JobIdNo= '/'+row.Job__c;
                        row.TaskId= '/'+row.Id;
                        row.JobName=row.Job__r.Name;
                        row.TaskName=row.Name;
                        row.TaskDue=row.Revised_Due_Date__c;
                        row.FileName=row.File_Name__c;
                        row.JobNum=row.Job__r.Job_Auto_Number__c;
                    }
                    component.set("v.data",rows);
                }
            }else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                var ToastMsg = $A.get("e.force:showToast");
                ToastMsg.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message                
                });
                ToastMsg.fire();
                
            }
            
        });
        
       /* var TSAccess = component.get("c.getisAccessable");
        TSAccess.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                console.log('TS Accessable'+response.getReturnValue());
                component.set("v.TSAccessable",response.getReturnValue());
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
            
        });*/
        
       // $A.enqueueAction(TSAccess);
        $A.enqueueAction(action);
    },
    
    /*getRowActions: function (component, row, doneCallback) {
        var actions = [];
        
        var TaskDoneAction = {
            'label': 'Task Done',
            'iconName': 'action:approval',
            'name': 'Task_Done'
        };
        
        var TimesheetAction = {
            'label': 'Log Time',
            'iconName': 'action:defer',
            'name': 'Timesheet_Entry',
            'disabled':!component.get("v.TSAccessable")
        };
        
        
        actions.push(TaskDoneAction,TimesheetAction);
        setTimeout($A.getCallback(function () {
            doneCallback(actions);
        }), 200);
    },*/
    
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.data");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        //data.sort(this.sortBy(fieldName, reverse))
        if(fieldName=='JobId'){
            data.sort(this.sortBy('JobName', reverse))
        }
        else if(fieldName=='TaskId'){
            data.sort(this.sortBy('TaskName', reverse))
        }
            else if(fieldName=='JobIdNo'){
                  data.sort(this.sortBy('JobNum', reverse))
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