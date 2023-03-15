({
	fetchTaskInformation : function(component, event, helper) {
         var TaskId=component.get("v.taskId");
         var action=component.get("c.getTaskInformation");
        action.setParams({
            taskId: TaskId
        });
        
        action.setCallback(this, function(res){
            console.log('===TaskInfomration======'+JSON.stringify(res.getReturnValue()));
           var state=res.getState();
            if(state === "SUCCESS"){
               component.set("v.taskInfo",res.getReturnValue());
                //helper.getTotalHoursWorked(component, event, helper);
                //helper.getTotalHrs(component, event, helper);
               // helper.getTotalHours(component, event, helper);
                
            }
        });
        
         var systoday = component.get("c.gettodaydatev1");
        systoday.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.today",response.getReturnValue());
            }
        });
        
        var userinfo = component.get("c.getUserName");
        userinfo.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                console.log('--->usename----'+JSON.stringify(response.getReturnValue()));
                 component.set("v.loginUserId",response.getReturnValue());
            }
        });
        
        $A.enqueueAction(userinfo);
        $A.enqueueAction(systoday);
        $A.enqueueAction(action);
        
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
                if(s!=0){
                    if(s==0.00){ 
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
    
   /* getTotalHours: function(component, event, helper){
        var tskInfo=component.get("v.taskInfo");
         var JobId = tskInfo.Job__c;
         console.log('==TotalHours JobId==='+JobId);
         
         var GLCodeID=tskInfo.GL_Code__c;
         console.log('==TotalHours GLCodeName==='+GLCodeID);
       
		var TotalHours = component.get("c.getTotalHours");
        TotalHours.setParams({
            JobNameStr : JobId, 
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
        var tskInfo=component.get("v.taskInfo");
         var JobId = tskInfo.Job__c;
         console.log('==TotalHours JobId==='+JobId);
         
         var GLCodeID=tskInfo.GL_Code__c;
         console.log('==TotalHours GLCodeName==='+GLCodeID);
        var TTH=component.get('v.TotalHours');
        
        var RemainHours = component.get("c.getRemainHours");
        RemainHours.setParams({
            JobNameStr : JobId, 
            GLCodeId :GLCodeID,
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
    },*/
    
    showToast : function(params){
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams(params);
            toastEvent.fire();
        } else{
            alert(params.message);
        }
    },
    
    
    
})