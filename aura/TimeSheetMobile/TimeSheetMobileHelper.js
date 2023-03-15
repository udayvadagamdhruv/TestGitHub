({
    fetchTSRecords : function(component, pageNumber, pageSize) {
        console.log('>>>>>>>>>>>Enter Fetch records>>>>>>>>>>>>>>>');
        var action = component.get("c.getMobTsEntyRecs");
        action.setParams({
            "pageNumber": pageNumber,
            "pageSize": pageSize
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var rows=response.getReturnValue();
                console.log('>>>>>>>>>>>Timesheet>>>>>>>>>>>>>>>'+JSON.stringify(rows));
                component.set("v.TSRecords", rows.TSList);
                component.set("v.PageNumber", rows.pageNumber);
                component.set("v.TotalRecords", rows.totalRecords);
                component.set("v.RecordStart", rows.recordStart);
                component.set("v.RecordEnd", rows.recordEnd);
                component.set("v.TotalPages", Math.ceil(rows.totalRecords / pageSize));
            }
        });
        
        var systoday = component.get("c.gettodaydate");
        systoday.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.today",response.getReturnValue());
            }
        });
        
        var userinfo = component.get("c.getUserName");
        userinfo.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.loginUserId",response.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);
        $A.enqueueAction(systoday);
        $A.enqueueAction(userinfo);
       
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
        });
        $A.enqueueAction(HoursWorked);
    },
    
})