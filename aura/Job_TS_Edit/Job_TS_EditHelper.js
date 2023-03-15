({
    getObjectLabel : function(component, event, helper){
        var action1 = component.get("c.geLabelforObject");
        action1.setParams({
            sObjName : 'Timesheet_Entries__c'
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
    
    
    getObjFieldLabels: function(component, event, helper){
        var Objaction = component.get( "c.getObjectType" );
         Objaction.setParams({
            ObjNames : 'Timesheet_Entries__c'
        }); 
        Objaction.setCallback( helper, function( response ) {
            console.log('>>>>>> Enter >>>>>>>>>>');
            if(component.isValid() && response.getState() === 'SUCCESS' ) {
                // Parse the JSON string into an object
                component.set( 'v.ObjectType', JSON.parse( response.getReturnValue() ) );
                console.log('>>>>>> Result of labels >>>>>>>>>>'+JSON.stringify(JSON.parse( response.getReturnValue() )));
            } else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction( Objaction );   
    },
    
    
    getJobName: function(component, event, helper){
        
        var Jobaction = component.get("c.getUserjobName");
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
        
        var JobrecId=component.get("v.recordId");
        console.log('>>>>Rec Id>>>>>>'+JobrecId);
        if(JobrecId!=null || JobrecId!=undefined){
            console.log('>>>>Rec Id not nul>>>>>>');
            var recId = component.get("v.simpleRecord.Job__r.Id");
        }
        else{
            console.log('>>>>Rec Id nul>>>>>>');
            var recId = component.find("JobNameId").get("v.value");
             console.log('>>>>Job ID>>>>>>'+recId);
        }
        console.log('==Job recId Task==='+recId);
        
        var action1 = component.get("c.getTaskName");
        action1.setParams({
            recordId : recId 
        });
        action1.setCallback(this, function(response1) {
            
            console.log("=====Tasksss====", response1.getReturnValue());
            if(response1.getState() === "SUCCESS"){
                helper.getObjFieldLabels(component, event, helper);  
                var TaskNames=response1.getReturnValue();
                console.log('>>>>>>>>>>>>Task Name>>>>>>>>>>>>'+JSON.stringify(TaskNames));
                component.set("v.TaskName", TaskNames);
            }
            else {
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
       
        var JobrecId=component.get("v.recordId");
        console.log('>>>>Rec Id>>>>>>'+JobrecId);
        if(JobrecId!=null || JobrecId!=undefined){
            console.log('>>>>Rec Id not nul>>>>>>');
            var recId = component.get("v.simpleRecord.Job__r.Id");
        }
        else{
            console.log('>>>>Rec Id nul>>>>>>');
            var recId = component.find("JobNameId").get("v.value");
             console.log('>>>>Job ID>>>>>>'+recId);
        }
        console.log('==Job recId Task==='+recId);
        
        
        console.log('==Job recId GL Code==='+recId);
        var TaskName = component.find("TaskNameId").get("v.value");
        var GLCode = component.get("c.getGLCodeOfTask");
        
        GLCode.setParams({
            recordId : recId, 
            JobTaskNameStr : TaskName
        });
        GLCode.setCallback(this, function(response1) {
            console.log("=====GLCode====", +JSON.stringify(response1.getReturnValue()));
            if(response1.getState() === "SUCCESS"){
                var GLCodeVal=response1.getReturnValue();
                console.log('>>>>>>>>>>>>GLCode>>>>>>>>>>>>'+JSON.stringify(GLCodeVal));
                component.set("v.GLCodeofTask", GLCodeVal[1]); 
                component.set("v.GLCodeofTaskid", GLCodeVal[0]); 
                helper.getTotalHours(component, event, helper);
                
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response1.getError()[0].message);
                var errors = response1.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction(GLCode);
    },
    
    
    getTotalHours: function(component, event, helper){
       // var recId = component.get("v.simpleRecord.Job__r.Id");
       // console.log('==TotalHours recId==='+recId);
        
        var JobrecId=component.get("v.recordId");
        console.log('>>>>Rec Id>>>>>>'+JobrecId);
        if(JobrecId!=null || JobrecId!=undefined){
            console.log('>>>>Rec Id not nul>>>>>>');
            var recId = component.get("v.simpleRecord.Job__r.Id");
        }
        else{
            console.log('>>>>Rec Id nul>>>>>>');
            var recId = component.find("JobNameId").get("v.value");
            console.log('>>>>Job ID>>>>>>'+recId);
        }
        console.log('==Job recId Task==='+recId);
        
        
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
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response1.getError()[0].message);
                var errors = response1.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction(TotalHours);
    },
    
    
    getRemainHours: function(component, event, helper){
       // var recId = component.get("v.simpleRecord.Job__r.Id");
       // console.log('==Remain Hours recId==='+recId);
        
        var JobrecId=component.get("v.recordId");
        console.log('>>>>Rec Id>>>>>>'+JobrecId);
        if(JobrecId!=null || JobrecId!=undefined){
            console.log('>>>>Rec Id not nul>>>>>>');
            var recId = component.get("v.simpleRecord.Job__r.Id");
        }
        else{
            console.log('>>>>Rec Id nul>>>>>>');
            var recId = component.find("JobNameId").get("v.value");
            console.log('>>>>Job ID>>>>>>'+recId);
        }
        console.log('==Job recId Task==='+recId);
        
        
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
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response1.getError()[0].message);
                var errors = response1.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
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
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response1.getError()[0].message);
                var errors = response1.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction(HoursWorked);
    },
})