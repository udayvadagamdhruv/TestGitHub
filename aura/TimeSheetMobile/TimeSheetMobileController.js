({
    doInit: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value"); 
        helper.fetchTSRecords(component, pageNumber, pageSize);
        helper.getJobName(component, event, helper); 
    },
    
    handleNext: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        pageNumber++;
        helper.fetchTSRecords(component, pageNumber, pageSize);
    },
    
    handlePrev: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        pageNumber--;
        helper.fetchTSRecords(component, pageNumber, pageSize);
    },
    
    onSelectChange: function(component, event, helper) {
        var page = 1
        var pageSize = component.find("pageSize").get("v.value");
        helper.fetchTSRecords(component, page, pageSize);
    },
    
    
    TSCreate:function (component, event, helper) {
        component.set("v.isTSOpen", true);
        helper.getJobName(component, event, helper); 
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.isTSOpen", false);
        component.set('v.TSRecordid', null);
        component.set('v.JobName', null);
        component.set('v.TaskName', null);
        component.set('v.GLCodeofTask', null);
        component.set('v.TotalHours', null);
        component.set('v.RemainHours', 0);
        component.set("v.selectedLookUpRecord_User",{"Id":null, "Name":null});
    },
    
    TaskChange:function(component, event, helper) {
        helper.getTaskName(component, event, helper);
    },     
    
    GLCode:function(component, event, helper) {
        helper.getGLCode(component, event, helper);
    },
    
    TotalHrs:function(component, event, helper) {
        helper.getTotalHoursWorked(component, event, helper);
        helper.getTotalHrs(component, event, helper);
    },
    
    
    jobTSOnsubmit : function(component, event, helper) {
        
        var JobName=component.find("JobNameId").get("v.value");
        console.log('===JobName==='+JSON.stringify(JobName));
        
        var TaskName=component.find("TaskNameId").get("v.value");
        console.log('===TaskName==='+JSON.stringify(TaskName));
        
        var TSDate=component.find("DTValueauraId").get("v.value");
        console.log('===Date==='+JSON.stringify(TSDate));
        
        event.preventDefault(); // Prevent default submit
        
        if(JobName==null || JobName=='')
        {
            var ToastMsg2=$A.get("e.force:showToast");
            ToastMsg2.setParams({
                "title":"Job Name",
                "type": "error",
                "message":"Please select Job."
            });   
            ToastMsg2.fire();
            event.preventDefault(); 
        }
        else if(TaskName==null || TaskName=='')
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
                    console.log('========'+component.get("v.recordId"));
                    TSfields["Job__c"]=component.find("JobNameId").get("v.value");
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
    
    
    jobTSload:  function(component, event, helper) { 
        console.log('===record Load===');
        var recId=component.get("v.TSRecordid");
        
        console.log('===Recordid after==='+recId); 
        helper.getTaskName(component, event, helper); 
        helper.getTotalHrs(component, event, helper);
        if(recId==null){
            var today=component.get("v.today");
            var userID=component.get("v.loginUserId");
            var TSfilds = event.getParam("recordUi");
            console.log('>>>>>>>>>>>>>>>>>>>>>> TSfilds >>>>>>>>>>>>>>>>>>'+JSON.stringify(TSfilds));
            component.find("DTValueauraId").set("v.value",today);
           // component.find("auraUserId").set("v.value",userID);
            if(TSfilds.record.fields.User__c.value==null){
                var userCstLookup={"Id":userID[0], "Name":userID[1]};
                component.find("uCstLookup").sampleMethod(userCstLookup);
            }
        }
    },
    
    onTSRecordSuccess: function(component, event, helper) { 
        var TSId=component.get('v.TSRecordid');
        var msg;
        if(TSId=='undefined' || TSId==null ){
            msg='Successfully Inserted TimeSheet Record';
        }
        console.log('===record Success==='+TSId);
        var ToastMsg11 = $A.get("e.force:showToast");
        ToastMsg11.setParams({
            "title": "Sucess",
            "type": "success",
            "message":msg
            
        });
        
        setTimeout($A.getCallback(function () {
            component.set('v.TSRecordid',null);
            component.set('v.JobName', null);
            component.set('v.TaskName', null);
            component.set('v.GLCodeofTask', null);
            component.set('v.TotalHours', 0);
            component.set('v.RemainHours', 0);
            component.set("v.isTSOpen", false);
            var pageNumber = component.get("v.PageNumber");  
            var pageSize = component.find("pageSize").get("v.value"); 
            helper.fetchTSRecords(component, pageNumber, pageSize);
        }), 2000);
        ToastMsg11.fire();
    },
    
    
})