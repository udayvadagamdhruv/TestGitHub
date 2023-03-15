({
    fetchFieldLabels :function (component, event, helper){
      var action=component.get("c.getObjectFieldLabels");
        action.setParams({
            ObjNames:['Timesheet_Entries__c']
        });
        
        action.setCallback(this, function(res){
            if(res.getState() === "SUCCESS"){
                var tableHeaders=JSON.parse(res.getReturnValue());
                console.log('===Job_Task__c and JOb====='+JSON.stringify(JSON.parse(res.getReturnValue())));
                //component.set("v.ObjectType",JSON.parse(res.getReturnValue()));
                component.set("v.columns",[
                    { label:tableHeaders.Timesheet_Entries__c.Name.label, fieldName: 'TSId', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: '_self', tooltip:{ fieldName: 'Name' }}},
                    { label:tableHeaders.Timesheet_Entries__c.Job__c.label, fieldName: 'JobName', sortable: true, type: 'text'},
                    { label:tableHeaders.Timesheet_Entries__c.Task_Name__c.label, fieldName: 'Task_Name__c', type: 'text', sortable: true},
                    { label:tableHeaders.Timesheet_Entries__c.Date__c.label,fieldName: 'Date__c', type: 'date-local', sortable: true, cellAttributes: { iconName: 'utility:event', iconAlternativeText:tableHeaders.Timesheet_Entries__c.Date__c.label}},
                    { label:tableHeaders.Timesheet_Entries__c.Hours_Worked__c.label, fieldName: 'Hours_Worked__c', sortable: true, type: 'number', cellAttributes: {alignment:'left'}}
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
    
    MyTSrecordsfetch : function(component) {
        var action = component.get("c.getTsEnty");
        action.setParams({
            "recordLimit": component.get("v.initialRows"),
            "recordOffset": component.get("v.rowNumberOffset")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            var rows=response.getReturnValue();
            console.log('>>>>>>>>>>>Timesheet>>>>>>>>>>>>>>>'+JSON.stringify(rows));
            
            if (state === "SUCCESS") {
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    row.TSId= '/'+row.Id;
                    row.JobName=row.Job__r.Name
                }
                
                component.set("v.data",rows);
                component.set("v.currentCount", component.get("v.initialRows"));
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
            //event.getSource().set("v.isLoading", false);
        });
        
        var systoday = component.get("c.gettodaydate");
        systoday.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.today",response.getReturnValue());
            }
            else{
                console.log('>>>>>> systoday Error >>>>>>>>>>',response.getError()[0].message);
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
        
        var userinfo = component.get("c.getUserName");
        userinfo.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.loginUserId",response.getReturnValue());
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
        $A.enqueueAction(userinfo);
        $A.enqueueAction(systoday);
        $A.enqueueAction(action);
    },
    
    getTotalNumberOfRecords : function(component) {
        var TotalRecaction = component.get("c.getTotalRecords");
        TotalRecaction.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" ) {
                var resultData = response.getReturnValue();
                component.set("v.totalNumberOfRows", resultData);
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
        $A.enqueueAction(TotalRecaction);
    },
    
    getMoreRec: function(component , rows){
        return new Promise($A.getCallback(function(resolve, reject) {
            var action = component.get('c.getTsEnty');
            var recordOffset = component.get("v.currentCount");
            console.log('>>>>>recordOffset>>>'+recordOffset);
            var recordLimit = component.get("v.initialRows");
            console.log('>>>>>recordLimit>>>'+recordLimit);
            action.setParams({
                "recordLimit": recordLimit,
                "recordOffset": recordOffset 
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS"){
                    var resultData = response.getReturnValue();
                    resolve(resultData);
                    recordOffset = recordOffset+recordLimit;
                    component.set("v.currentCount", recordOffset);   
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
        }));
    },
    
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.data");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse))
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
    
    getJobName: function(component, event, helper){
        
        var Jobaction = component.get("c.getjobName");
        Jobaction.setCallback(this, function(Jobresponse) {
            console.log("=====Jobssss====", Jobresponse.getReturnValue());
            if(Jobresponse.getState() === "SUCCESS"){
                var JobNames=Jobresponse.getReturnValue();
                console.log('>>>>>>>>>>>>Job Name>>>>>>>>>>>>'+JSON.stringify(JobNames));
                component.set("v.JobName", JobNames);
            }
            else{
                console.log('>>>>>> Error >>>>>>>>>>',Jobresponse.getError()[0].message);
                var errors = Jobresponse.getError();
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                });
                toastEvent.fire();
                
            }
        });
        $A.enqueueAction(Jobaction);
    },
    
    getTaskName: function(component, event, helper){
        var JobRId = component.find("JobNameId").get("v.value");
        console.log('==JobRId==='+JobRId);
        //    var recId = component.get("v.recordId");
        //   console.log('==recId==='+recId);
        var action1 = component.get("c.getTaskName");
        action1.setParams({
            JobId : JobRId 
        });
        action1.setCallback(this, function(response1) {
            console.log("=====Tasksss====", response1.getReturnValue());
            if(response1.getState() === "SUCCESS"){
                var TaskNames=response1.getReturnValue();
                console.log('>>>>>>>>>>>>Task Name>>>>>>>>>>>>'+JSON.stringify(TaskNames));
                component.set("v.TaskName", TaskNames);
            }
            else{
                console.log('>>>>>> Error >>>>>>>>>>',response1.getError()[0].message);
                var errors = response1.getError();
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                });
                toastEvent.fire();
                
            }
        });
        $A.enqueueAction(action1);
    },
    
    getTotalHrs: function(component, event, helper){
        var Start=component.find("STWatch").get('v.value');
        var End=component.find("ETWatch").get('v.value');
        console.log('==========Start======'+Start);
        console.log('==========End======'+End);
        if(Start==null && End==null)
        {	
            console.log('========entered=======true=========');
            component.set("v.isStartEnd", false);
        }
        else
        {
            console.log('========entered=false====');
            component.set("v.isStartEnd", true);
        }
    },
    
    
    getGLCode: function(component, event, helper){
        var recId = component.get("v.recordId");
        console.log('==recId==='+recId);
        
        var JobRId = component.find("JobNameId").get("v.value");
        var TaskName = component.find("TaskNameId").get("v.value");
        var GLCode = component.get("c.getGLCodeOfTask");
        
        GLCode.setParams({
            JobId : JobRId , 
            JobTaskNameStr : TaskName
        });
        GLCode.setCallback(this, function(response1) {
            console.log("=====GLCode====", +JSON.stringify(response1.getReturnValue()));
            if(response1.getState() === "SUCCESS"){
                var GLCode=response1.getReturnValue();
                console.log('>>>>>>>>>>>>GLCode>>>>>>>>>>>>'+JSON.stringify(GLCode));
                component.set("v.GLCodeofTask", GLCode[1]); 
                component.set("v.GLCodeofTaskid", GLCode[0]); 
                helper.getTotalHours(component, event, helper);
                
            }
            else{
                console.log('>>>>>> Error >>>>>>>>>>',response1.getError()[0].message);
                var errors = response1.getError();
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                });
                toastEvent.fire();
                
            }
        });
        $A.enqueueAction(GLCode);
    },
    
    
    getTotalHours: function(component, event, helper){
        var recId = component.find("JobNameId").get("v.value");
        console.log('==TotalHours recId==='+recId);
        //  var JobRId = component.find("JobNameId").get("v.value");
        var TaskName=component.find("TaskNameId").get('v.value');
        console.log('==TotalHours TaskName==='+TaskName);
        var GLCodeID=component.get('v.GLCodeofTaskid');
        console.log('==TotalHours GLCodeName==='+GLCodeID);
        
        var TotalHours = component.get("c.getTotalHours");
        TotalHours.setParams({
            JobNameStr : recId, 
            GLCode :GLCodeID
        });
        TotalHours.setCallback(this, function(response1) {
            console.log("=====Total Hours====", response1.getReturnValue());
            if(response1.getState() === "SUCCESS"){
                var TotalHours=response1.getReturnValue();
                console.log('>>>>>>>>>>>>Total Hours>>>>>>>>>>>>'+JSON.stringify(TotalHours));
                component.set("v.TotalHours", TotalHours); 
                helper.getRemainHours(component, event, helper);
            }
            else{
                console.log('>>>>>> Error >>>>>>>>>>',response1.getError()[0].message);
                var errors = response1.getError();
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                });
                toastEvent.fire();
                
            }
        });
        $A.enqueueAction(TotalHours);
    },
    
    
    getRemainHours: function(component, event, helper){
        var recId = component.find("JobNameId").get("v.value");
        console.log('==Remain Hours recId==='+recId);
        var GLCodeid=component.get('v.GLCodeofTaskid');
        console.log('==Remain Hours GLCode==='+GLCodeid);
        var TTH=component.get('v.TotalHours');
        
        var RemainHours = component.get("c.getRemainHours");
        RemainHours.setParams({
            JobNameStr : recId, 
            GLCodeId :GLCodeid,
            TaskTotalHr:TTH
        });
        RemainHours.setCallback(this, function(response1) {
            console.log("=====Remain Hours====", response1.getReturnValue());
            if(response1.getState() === "SUCCESS"){
                var RemainHours=response1.getReturnValue();
                console.log('>>>>>>>>>>>>Total Hours>>>>>>>>>>>>'+JSON.stringify(RemainHours));
                component.set("v.RemainHours", RemainHours); 
            }
            else{
                console.log('>>>>>> Error >>>>>>>>>>',response1.getError()[0].message);
                var errors = response1.getError();
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                });
                toastEvent.fire();
                
            }
        });
        $A.enqueueAction(RemainHours);
    },
    
    getTotalHoursWorked: function(component, event, helper){
        var ST = component.find("STWatch").get('v.value');
        console.log('==TotalHoursWorked Start Watch==='+ST);
        var ET = component.find("ETWatch").get('v.value');
        console.log('==TotalHoursWorked End Watch==='+ET);
        
        var HoursWorked = component.get("c.calcTimeDiff");
        HoursWorked.setParams({
            StWatch : ST, 
            EndWatch : ET
        });
        HoursWorked.setCallback(this, function(response1) {
            console.log("=====Total Hours Worked====", response1.getReturnValue());
            if(response1.getState() === "SUCCESS"){
                var HoursWorked=response1.getReturnValue();
                console.log('>>>>>>>>>>>>Total Hours Worked>>>>>>>>>>>>'+JSON.stringify(HoursWorked));
                component.set("v.TotalHoursWorked", HoursWorked); 
                var s =HoursWorked ;
                if(s!='0'){
                    if(s=='0:00'){ 
                        helper.showToast({
                            "title": "Error",
                            "type": "Error",
                            "message":  "End watch should  be greater than Start watch."
                        });
                    }              
                }
            }
            else{
                console.log('>>>>>> Error >>>>>>>>>>',response1.getError()[0].message);
                var errors = response1.getError();
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                });
                toastEvent.fire();
                
            }
        });
        $A.enqueueAction(HoursWorked);
    },
    
    
})