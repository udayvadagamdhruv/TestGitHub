({
    doInit : function(component, event, helper) {
        var today = new Date();
        //component.set('v.today', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());
        var TSAccess = component.get("c.getisAccessable");
        TSAccess.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                console.log('TS Accessable'+response.getReturnValue());
                component.set("v.TSAccessable",response.getReturnValue());
                var TSAccess=component.get('v.TSAccessable[0]');
                console.log('>>>>>>>>TS Doinit>>>>>>>>>>'+TSAccess);
                if(TSAccess==true){
                    helper.fetchJobTS(component, event, helper);
                    // helper.FetchFieldsfromFS(component, event, helper); 
                    helper.getTaskName(component, event, helper); 
                    helper.getTotalNumberOfRecords(component);
                    helper.getFieldLabels(component, event, helper);
                }
            }
        });
        $A.enqueueAction(TSAccess);
        var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
        console.log('--isMobile'+isMobile);
        if(isMobile){
            component.set("v.isMobile",true);
        }
        var helpTextRec= component.get("c.getHelpTextrecords"); 
        helpTextRec.setCallback(this, function(helpTextResponse){
            if (helpTextResponse.getState() === "SUCCESS") {
                console.log('=Help Text Values=='+JSON.stringify(helpTextResponse.getReturnValue()));
                component.set("v.helpText",helpTextResponse.getReturnValue());
            }
        }); 
        $A.enqueueAction(helpTextRec); 
       
    },
   
    refreshTS :function(component, event, helper) {
        console.log('=========refetching the TS from the application event=======');
        helper.fetchJobTS(component, event, helper);
    },
    
    handleRowAction: function(component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
                
            case 'Edit_TS':
               if(component.get('v.TSAccessable[4]')){
                   component.set('v.TSRecordid',row.Id);
                   component.set("v.isTSOpen", true);}
                 else{
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": 'Timesheet has insufficient access to edit/update'
                    }); 
                }
                break;
                
            case 'Delete_TS':
                helper.deleteJobTS(component, event, helper);
                break;
        }
    },
    
    
     handleLoadMoreRec: function (component, event, helper) {
         helper.loadingInstiate(component, event, helper);
    },
    
    
    recordsUpdateforchanges: function (cmp, event, helper) {
        // alert('fireing in TS section after records delete and insert');
        helper.fetchJobTS(cmp, event, helper);
    },
    
    
    updateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },
    
    onSave : function (component, event, helper) {
        helper.saveDataTable(component, event, helper);
    },
    
    GLCode:function(component, event, helper) {
        helper.getGLCode(component, event, helper);
    },
    
    TotalHrs:function(component, event, helper) {
        helper.getTotalHoursWorked(component, event, helper);
        helper.getTotalHrs(component, event, helper);
    },
    
    /*  Timecal:function(component, event, helper) {
        console.log('===Timecal===');
        var STET=component.get('v.isStartEnd');
        var HW=component.find("THW").get('v.value');
        console.log('===STET==='+STET);
        console.log('===HW==='+HW);
        if(!STET && HW!=null)
        {
            var HoursMintues = component.find("THW").get("v.value");
            var HM = HoursMintues.split(".");
            console.log('===HM==='+HM);
            var Hrmins=parseFloat(HM[0]) + parseFloat((HM[1]/60),10);
            console.log('===Hrmins==='+Hrmins);
             component.find("THW").set("v.value",Hrmins);
        }  
        
    },*/
    
    TSCreate:function (component, event, helper) {
        if(component.get('v.TSAccessable[4]')){
               component.set("v.isTSOpen", true);
        } else{
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": 'Time sheet has insufficient access to create'
                    }); 
                }
     
        
    },
    
    
    closeModel: function(component, event, helper) {
        component.set("v.isTSOpen", false);
        component.set('v.TSRecordid', null);
        component.set('v.TaskName', null);
        component.set('v.GLCodeofTask', null);
        component.set('v.TotalHours', null);
        component.set('v.RemainHours', 0);
        component.set("v.selectedLookUpRecord_User",{"Id":null, "Name":null});
    },
    
    
    jobTSOnsubmit : function(component, event, helper) {
        var TSK=component.find("TaskNameId");
        var TaskName=TSK.get("v.value");
        console.log('===TaskName==='+JSON.stringify(TaskName));
        
        var Tsdat=component.find("DTValueauraId");
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
                console.log('========'+component.get("v.recordId"));
                TSfields["Job__c"]=component.get("v.recordId");
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
            component.find("DTValueauraId").set("v.value",today);
            //component.find("auraUserId").set("v.value",userID);
            var userCstLookup={"Id":userID[0], "Name":userID[1]};
            component.find("uCstLookup").sampleMethod(userCstLookup);
        }
        else
        {   
            console.log('===Recordid 33333 after==='+recId);    
            var TSfilds = event.getParam("recordUi");
            console.log('-----TSfilds-----'+JSON.stringify(TSfilds));
            if(TSfilds.record.fields.User__c.value!=null){
                var userCstLookup={"Id":TSfilds.record.fields.User__r.value.fields.Id.value, "Name":TSfilds.record.fields.User__r.value.fields.Name.value};
                component.find("uCstLookup").sampleMethod(userCstLookup);
            }
            setTimeout($A.getCallback(function() {
                
                component.find("TaskNameId").set("v.value",TSfilds.record.fields.Task_Name__c.value);
                console.log('==Task_Name__c Onload Id=='+component.find("TaskNameId").get("v.value"));
                component.find("TaskNameId").get('v.value');
                helper.getGLCode(component, event, helper);
               
            }), 800);
            var STET=component.get('v.isStartEnd');
            if(STET)
            {
                component.find("oTHW").set("v.value",TSfilds.record.fields.Hours_Worked__c.value);
            }
        }
    },
    
    onTSRecordSuccess: function(component, event, helper) { 
        var TSId=component.get('v.TSRecordid');
        var msg;
        if(TSId=='undefined' || TSId==null ){
            msg='Successfully Inserted TimeSheet Record';
        }
        else{
            msg='Successfully Updated TimeSheet Record';
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
            component.set('v.TaskName', null);
            component.set('v.GLCodeofTask', null);
            component.set('v.TotalHours', 0);
            component.set('v.RemainHours', 0);
            component.set("v.isTSOpen", false);
            
            helper.fetchJobAllTS(component, event, helper);
            helper.loadingInstiate(component, event, helper);
            helper.fetchJobTS(component, event, helper);
            helper.getTotalNumberOfRecords(component);
        }), 2000);
        ToastMsg11.fire();
      
    },
    
    handleTsQuickAction : function(component, event, helper) { 
       var selectOption=event.getParam("value");
       var selectTsId=event.getSource().get("v.name");
        
         console.log('---selectTsId-'+selectTsId+'---option--'+selectOption);
        if(selectOption=='Edit'){
              component.set('v.TSRecordid',selectTsId);
                component.set("v.isTSOpen", true);
        }
        else{  
             helper.deleteJobTS(component, event, helper,selectTsId);
        }
    }
    
})