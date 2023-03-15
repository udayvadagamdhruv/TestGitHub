({
    doInit: function(component, event, helper) {
        helper.fetchFieldLabels(component,event,helper);
        helper.getTotalNumberOfRecords(component);
        helper.MyTSrecordsfetch(component);
        helper.getJobName(component, event, helper); 
       
    },
    
    handleLoadMoreRec: function (component, event, helper) {
        event.getSource().set("v.isLoading", true);
        component.set('v.loadMoreStatus', 'Loading....');
        if (component.get('v.data').length != component.get('v.totalNumberOfRows')) {
            helper.getMoreRec(component, component.get('v.rowsToLoad')).then($A.getCallback(function (data) {
                if (component.get('v.data').length == component.get('v.totalNumberOfRows')) {
                    event.getSource().set("v.isLoading", false);
                    component.set('v.enableInfiniteLoading', false);
                    component.set('v.loadMoreStatus', 'No more data to load');
                } else {
                    var currentData = component.get('v.data');
                    var newData = currentData.concat(data);
                    for (var i = 0; i < newData.length; i++) {
                        var row = newData[i];
                        row.TSId= '/'+row.Id;
                        row.JobName=row.Job__r.Name
                    }
                    
                    //component.set("v.data",rows);
                    //console.log('>>>>>>>>>>>'+)
                    component.set('v.data', newData);
                    component.set('v.loadMoreStatus', 'Please scroll down to load more data');
                }
                event.getSource().set("v.isLoading", false);
            }));
        }
        else
        {
         //   event.getSource().set("v.isLoading", false);
            component.set('v.enableInfiniteLoading', false);
            component.set('v.loadMoreStatus', 'No more data to load');
        }
    },
    
    refreshdataforLogTime :function (component, event, helper) {
     helper.MyTSrecordsfetch(component);   
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
    
    updateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
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
                    
                    component.find("TSEditform").submit(TSfields);
                    console.log('===form TSfields==='+JSON.stringify(TSfields));
                }
    },
    
    
    jobTSload:  function(component, event, helper) { 
        console.log('===record Load===');
        var recId=component.get("v.TSRecordid");
        
        console.log('===Recordid after==='+recId); 
       // helper.getTaskName(component, event, helper); 
       // helper.getTotalHrs(component, event, helper);
        if(recId==null){
            var today=component.get("v.today");
            var userID=component.get("v.loginUserId");
            component.find("DTValueauraId").set("v.value",today);
            component.find("auraUserId").set("v.value",userID);
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
            helper.getTotalNumberOfRecords(component);
        helper.MyTSrecordsfetch(component);
        }), 2000);
        ToastMsg11.fire();
    },
    
    
})