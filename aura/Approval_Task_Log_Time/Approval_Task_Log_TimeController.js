({
	doInit : function(component, event, helper) {
        var TaskId=component.get("v.taskId");  
        helper.fetchTaskInformation(component, event, helper);
        
	},
    
    TotalHrs:function(component, event, helper) {
        helper.getTotalHoursWorked(component, event, helper);
        helper.getTotalHrs(component, event, helper);
    },
    
    closeLogTimeModel :function(component, event, helper) {
       component.set("v.taskId",null); 
       component.set("v.taskInfo",null);
       component.set("v.LogTimePopUp",false);
        component.set("v.isStartEnd",false);  
    },
    refreshTaskData : function(component, event, helper) {
       component.set("v.LogTimePopUp",true);  
       helper.fetchTaskInformation(component, event, helper);  
    },
    
    LogTimeSubmit : function(component, event, helper) {
        event.preventDefault(); // Prevent default submit
        var TSDate=component.find("DT").get("v.value");
        var tskInfo=component.get("v.taskInfo"); 
        console.log('===Date==='+JSON.stringify(TSDate));
        
        
        if(TSDate==null || TSDate=='')
        {
            var ToastMsg1=$A.get("e.force:showToast");
            ToastMsg1.setParams({
                "title":"Date",
                "type": "error",
                "message":"Date Field is required."
            });   
            ToastMsg1.fire();
            event.preventDefault(); 
        }
        else
        {
            var TSfields = event.getParam("fields");
            TSfields["Job__c"]=tskInfo.Job__c;
            TSfields["Task_Name__c"]=tskInfo.Name;
            //TSfields["GL_Code__c"]=tskInfo.GL_Code__c;
            var STET=component.get('v.isStartEnd');
            if(STET)
            {
                TSfields["Hours_Worked__c"]=component.get("v.TotalHoursWorked");
            }
            TSfields["User__c"]=component.get("v.loginUserId[0]");
            /*var STET=component.get('v.isStartEnd');
                var recId=component.get("v.TSRecordid");
                if(recId==null)
                {
                    if(STET)
                    {
                        var HoursMintues = component.get("v.TotalHoursWorked");
                        var HM = HoursMintues.split(":");
                        var Hrmins=parseFloat(HM[0]) + parseFloat((HM[1]/60),10);
                        console.log('===HoursMintues==='+Hrmins);
                        console.log('===HM==='+HM);
                        TSfields["Hours_Worked__c"]= Hrmins;
                        console.log('===Hours_Worked__c==='+Hrmins);
                    }
                    else
                    {
                        var HoursMintues = component.find("THW").get("v.value");
                        var HM = HoursMintues.split(".");
                        var Hrmins=parseFloat(HM[0]) + parseFloat((HM[1]/60),10);
                        TSfields["Hours_Worked__c"]= Hrmins;
                    }
                }*/
            
            component.find("LogTimeEditForm").submit(TSfields);
            console.log('===form TSfields==='+JSON.stringify(TSfields));
        }
    },
    
     LogTimeSucess: function(component, event, helper) { 
        
        var ToastMsg11 = $A.get("e.force:showToast");
        ToastMsg11.setParams({
            "type": "success",
            "message":'Successfully Inserted TimeSheet Record for the Approval Task.'
            
        });
         ToastMsg11.fire();
         var appEvent=$A.get("e.c:UpdateRecordsforChanges");
         if(appEvent)
         {
         	appEvent.fire();
         }
         component.set("v.taskId",null); 
         component.set("v.taskInfo",null);
         component.set("v.LogTimePopUp",false);
         component.set("v.isStartEnd",false);
    },
    
    
    
})