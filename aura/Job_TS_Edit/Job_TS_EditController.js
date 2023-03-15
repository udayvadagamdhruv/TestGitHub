({
    doInit : function(component, event, helper) {
        //helper.getObjFieldLabels(component, event, helper); 
         console.log('===doInit===');
        var recId=component.get("v.recordId");
        console.log('>>>rec ID Donit>>>'+recId);
        helper.getObjectLabel(component, event, helper); 
        if(recId!=null || recId!=undefined){
            helper.getTaskName(component, event, helper);  
        }else{
            helper.getJobName(component, event, helper); 
            helper.getTaskName(component, event, helper);
            var systoday = component.get("c.gettodaydate");
            systoday.setCallback(this, function(response) {
                if (response.getState() === "SUCCESS") {
                    console.log('today>>>>>>>>>>'+JSON.stringify(response.getReturnValue()));
                    component.set("v.today",response.getReturnValue());
                }
            });
            var userinfo = component.get("c.getUserName");
            userinfo.setCallback(this, function(response) {
                if (response.getState() === "SUCCESS") {
                    console.log('user>>>>>>>>>>'+JSON.stringify(response.getReturnValue()));
                    component.set("v.loginUserId",response.getReturnValue());
                    var userID=component.get("v.loginUserId");
                    var userCstLookup={"Id":userID[0], "Name":userID[1]};
                    component.find("uCstLookup").sampleMethod(userCstLookup);
                }
            });
            $A.enqueueAction(userinfo);
            $A.enqueueAction(systoday);
        }
    },
    
    TaskChange:function(component, event, helper) {
        console.log('>>>>Task Change Fire>>>>>>>');
        helper.getTaskName(component, event, helper);
    }, 
    
    GLCode:function(component, event, helper) {
        console.log('>>>>GL Code Change Fire>>>>>>>');
        helper.getGLCode(component, event, helper);
    },
    
    TotalHrs:function(component, event, helper) {
        helper.getTotalHoursWorked(component, event, helper);
        helper.getTotalHrs(component, event, helper);
    },
    
    
    onloadrecord : function(component, event, helper) {
        console.log('===record Load===');
        var recId = component.get("v.recordId");
        // helper.getTaskName(component, event, helper); 
        helper.getTotalHrs(component, event, helper);
        if(recId!=null){
            console.log('===Recordid 33333 after==='+recId);    
            var TSfilds = event.getParam("recordUi");
            if(TSfilds.record.fields.User__c.value!=null){
                var userCstLookup={"Id":TSfilds.record.fields.User__r.value.fields.Id.value, "Name":TSfilds.record.fields.User__r.value.fields.Name.value};
                component.find("uCstLookup").sampleMethod(userCstLookup);
            }
            setTimeout($A.getCallback(function() {
                helper.getTaskName(component, event, helper); 
            }), 300);
            setTimeout($A.getCallback(function() {
                // helper.getTaskName(component, event, helper); 
                // helper.getTotalHrs(component, event, helper);
                component.find("TaskNameId").set("v.value",TSfilds.record.fields.Task_Name__c.value);
                console.log('==Task_Name__c Onload Id=='+component.find("TaskNameId").get("v.value"));
                component.find("DT").set("v.value",TSfilds.record.fields.Date__c.value);
                console.log('==Date__c Onload Id=='+component.find("DT").get("v.value"));
                helper.getGLCode(component, event, helper);
                helper.getTotalHrs(component, event, helper);
                
            }), 800);
            
            var STET=component.get('v.isStartEnd');
            console.log('==isStartEnd Onload Id=='+component.get('v.isStartEnd'));
            if(STET)
            {
                console.log('==HR Onload Id=='+TSfilds.record.fields.Hours_Worked__c.value);
                component.find("oTHW").set("v.value",TSfilds.record.fields.Hours_Worked__c.value);
                console.log('==HR Onload Id1=='+component.find("oTHW").get("v.value"));
            }
            
        }
    },
    
    RecordSubmit: function(component, event, helper) {
        var recId=component.get("v.recordId");
        if(recId==null || recId==undefined){
            var Job=component.find("JobNameId");
            var JobName=Job.get("v.value");
            console.log('===JobName==='+JSON.stringify(JobName));
            
            if(JobName==null || JobName=='')
            {
                var ToastMsg=$A.get("e.force:showToast");
                ToastMsg.setParams({
                    "title":"Job Name",
                    "type": "error",
                    "message":"Please select Job Name."
                });   
                ToastMsg.fire();
                event.preventDefault(); 
            }
            
        }
        var TSK=component.find("TaskNameId");
        var TaskName=TSK.get("v.value");
        console.log('===TaskName==='+JSON.stringify(TaskName));
        
        var Tsdat=component.find("DT");
        var TSDate=Tsdat.get("v.value");
        console.log('===Date==='+JSON.stringify(TSDate));
        
        event.preventDefault(); // Prevent default submit
        
        if(TaskName==null || TaskName=='')
        {
            var ToastMsg=$A.get("e.force:showToast");
            ToastMsg.setParams({
                "title":"Task Name",
                "type": "error",
                "message":"Please select Task Name."
            });   
            ToastMsg.fire();
            event.preventDefault(); 
        }
        else if(TSDate==null || TSDate=='')
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
                console.log('====Recid===='+component.get("v.recordId"));
                
                if(recId!=null || recId!=undefined){
                    TSfields["Job__c"]=component.get("v.simpleRecord.Job__r.Id");
                }
                else
                {
                    TSfields["Job__c"]=component.find("JobNameId").get("v.value");
                }
                
                TSfields["Task_Name__c"]=component.find("TaskNameId").get("v.value");
                TSfields["GL_Code__c"]=component.get("v.GLCodeofTaskid");
                var STET=component.get('v.isStartEnd');
                if(STET)
                {
                    TSfields["Hours_Worked__c"]=component.get("v.TotalHoursWorked");
                }
                if(component.get("v.selectedLookUpRecord_User").Id==null){
                    TSfields["User__c"]="";
                } 
                else{
                    TSfields["User__c"]=component.get("v.selectedLookUpRecord_User").Id;
                }
                component.find("TSEditform").submit(TSfields);
                console.log('===form TSfields==='+JSON.stringify(TSfields));
            }
    },
    
    onRecordSuccess: function(component, event, helper) {
        
        console.log('===onRecordSuccess===');
        console.log('===Rec Id==='+component.get("v.recordId"));
        if(component.get("v.recordId")!=null)
        {
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": component.get("v.recordId")
            });
            navEvt.fire();
            
            var ToastMsg1 = $A.get("e.force:showToast");
            ToastMsg1.setParams({
                "title": "Sucess",
                "type": "success",
                "message": "Successfully Updated Timesheet Record"
                
            });
            ToastMsg1.fire();
        }
        else
        {
            var navEvt = $A.get("e.force:navigateToObjectHome");
            navEvt.setParams({
                "scope":component.get("v.sObjectName")
            });
            navEvt.fire();
        }
        
    },
    
    doCancel:function(component, event, helper) {
        component.set("v.selectedLookUpRecord_User",{"Id":null, "Name":null});
        if(component.get("v.recordId")!=null)
        {
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": component.get("v.recordId")
            });
        }
        else
        {
            var navEvt = $A.get("e.force:navigateToObjectHome");
            navEvt.setParams({
                "scope":component.get("v.sObjectName")
            });
        }
        navEvt.fire();
    }
})