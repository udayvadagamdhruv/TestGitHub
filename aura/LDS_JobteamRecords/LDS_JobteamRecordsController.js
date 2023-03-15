({
    afterScriptsLoaded: function(cmp,evt,helper){
        helper.fetchCalenderEvents(cmp,evt,helper); 
        helper.getStatusList(cmp,evt,helper);
        
    },
    
    ResourceLoadscriptsLoaded : function(component, event, helper) {
        var SelUserRole='';
        helper.WorkloadGraphfetch(component, event, helper,SelUserRole);
    },
    
    doInit: function(component, event, helper) {
        
        helper.fetchCustomSettingdata(component, event, helper);// fetch custom setting data and Object Accessibility.
        helper.fetchFieldLabels(component,event,helper);  
        
        var JobCostAccess = component.get("c.getisAccessable");
        JobCostAccess.setCallback(this, function(JobCostresponse) {
            if (JobCostresponse.getState() === "SUCCESS") {
                console.log('Job Cost Accessable'+JobCostresponse.getReturnValue());
                component.set("v.JobDetailAccessible",JobCostresponse.getReturnValue());
            }
            if(component.get("v.JobDetailAccessible[2]")){
                helper.JobSpecsfetch(component, event); //List of records displaying in Spec section
                helper.JobSpecTemplate(component, event); //Piclist Values in job specs section
            }
            if(component.get("v.JobDetailAccessible[0]")){
                helper.JobTeamsfetch(component, event, helper);//fetch the Job Tasks for the Job.
            }
        });
        $A.enqueueAction(JobCostAccess);
        
        helper.JobTasksfetch(component, event);        
        
        var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
        var PEValue=component.get("v.CST[0].Active__c");
        console.log('----isMobile-not if---'+isMobile);
        if(isMobile){// && PEValue){
            console.log('----isMobile----'+isMobile);
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
    
    handleRowSelection:function(component, event, helper) {
        var selRows=event.getParam('selectedRows');
        console.log('===selectedRows======'+selectedRows);
        var taskIdList=[];
        for(var i=0;i<selRows.length;i++){
            taskIdList.push(selRows[i].Id);
        }
        component.set("v.selectedTasksforMarkDone",taskIdList);
        //console.log('====selected Rows='+JSON.stringify(selRows));
        //console.log('====setvalues Rows='+JSON.stringify(component.get("v.selectedTasksforMarkDone")));
        // helper.MarkAllSelectedTasks(selRows);
    },
    
    MarkSelectedTasks : function(component, event, helper) {
        if(component.get("v.JobDetailAccessible[7]")){ 
            var action=component.get("c.MarkAllSelectedTasks");
            var taskIdList=component.get("v.selectedTasksforMarkDone");
            console.log('====seletedRows==='+JSON.stringify(taskIdList));
            action.setParams({
                taskIdList : taskIdList
            });
            action.setCallback(this, function(res){
                console.log('===state==='+res.getState());
                console.log('===state==='+res.getReturnValue());
                if(res.getState()==="SUCCESS"){
                    if(res.getReturnValue()=="OK"){
                        helper.showToast({
                            "type": "success",
                            "message": "Marked Done selected Tasks."
                        }); 
                        component.set("v.selectedTasksforMarkDone",null);
                        component.set("v.selectedRows",[]);
                        helper.JobTasksfetch(component,event);
                    }
                    else{
                        helper.showToast({
                            "title":"Error!!",
                            "type": "error",
                            "message": res.getReturnValue()
                        }); 
                    }
                }
                else{
                    helper.showToast({
                        "title":"Error!!",
                        "type": "error",
                        "message": res.getReturnValue()
                    }); 
                }
            });
            
            $A.enqueueAction(action); 
        }else{
            helper.showToast({
                "title": "Error!!",
                "type": "error",
                "message": 'Tasks have insufficient access to edit/update'
            }); 
        }
    },
    
    refreshJobTasks :function(component, event, helper) {
        helper.JobTasksfetch(component, event);
    },
    
    WorkLoadUserRoleChange : function(component, event, helper) {
        var SelUserRole=component.find("WorkLoadid").get("v.value");
        helper.WorkloadGraphfetch(component, event, helper,SelUserRole);
    },
    
    
    // ******************************************************** Doinit Close ****************************************************** 
    
    // ********************************************* Add Spec records from the template onchange **************************************************** 
    
    jobAddSpecTemp: function(component, event, helper) {
        
        var recId = component.get("v.recordId");
        var ToastMsg = $A.get("e.force:showToast");
        var jobAddSpecTemp = component.get("c.addJobSpecTemplates");
        jobAddSpecTemp.setParams({
            recordId: recId,
            selectedJSTemp: component.find("jSpecSelectId").get("v.value")
        });
        
        jobAddSpecTemp.setCallback(this, function(jAddSpecTempResponse) {
            console.log('===jSpecAddTemp======' + jAddSpecTempResponse.getReturnValue());
            var jAddSpecTempState = jAddSpecTempResponse.getState();
            if (jAddSpecTempState === "SUCCESS" && jAddSpecTempResponse.getReturnValue() === "Successfully Imported Specification Template Records") {
                console.log('====ImportTemplate  success==' + jAddSpecTempResponse.getReturnValue());
                ToastMsg.setParams({
                    "title": "Import Specs",
                    "type": "success",
                    "message": jAddSpecTempResponse.getReturnValue()
                    
                });
                helper.JobSpecsfetch(component, event);
                ToastMsg.fire();
                component.find("jSpecSelectId").set("v.value", null);
                console.log('===jSpecAddTemp======' + jAddSpecTempResponse.getReturnValue());
                //component.set("v.addJobSpecTemplates",jAddSpecTempResponse.getReturnValue()); 
            } else {
                ToastMsg.setParams({
                    "title": "Error",
                    "type": "error",
                    "message": jAddSpecTempResponse.getReturnValue()
                });
                ToastMsg.fire();
            }
        });
        $A.enqueueAction(jobAddSpecTemp);
    },
    
    NavigateToAddEditTeam :function(component, event, helper){
        var JobId = component.get("v.recordId");
        
        var urlTeamEdit = $A.get("e.force:navigateToURL");
        urlTeamEdit.setParams({
            "url": '/apex/JobTeamAddEditStaff_Lightning?id='+JobId 
        });
        urlTeamEdit.fire();
    },
    
    CancelAddEditModal : function(component, event, helper){
        component.set("v.isAddEditTeamMembers",false);
    },
    
    /************** popup open after click the update button in TEAM section on job detail page ***********************/
    
    CopyStafftoOtherJobs : function(component, event, helper){
        helper.copyTeamhelper(component, event, helper);
        component.set("v.isCopyStaff", true);
    },
    
    /************** update the selected values in the list of jobs related campaign *********************************/
    
    updateCopyTeamSelectedJobs: function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        cmp.set('v.selected_CopyTeamJobs', selectedRows);   
        cmp.set('v.selCopyTeamRowsCount', selectedRows.length);
    },
    
    /********************* Cancel button on the popup update team button *******************************/
    
    CancelCopyStafftoOtherJobs : function(component, event, helper){
        component.set("v.isCopyStaff", false);
        component.set("v.selected_CopyTeamJobs",null);
        component.set('v.selCopyTeamRowsCount',null);
    },
    
    /************************* Save Copy Team members to selected jobs ********************************/
    
    SavecopyTeam : function(component, event, helper) {
        var selcted=component.get("v.selected_CopyTeamJobs");
        if(selcted!=null){
            helper.helpSavecopyTeam(component, event, helper);   
        }
        else{
            var ToastMsg1 = $A.get("e.force:showToast");
            ToastMsg1.setParams({
                "title": "Error",
                "type": "error",
                "message": "Please Select at least one Job to Copy Team."
            });  
            ToastMsg1.fire();
        }
        
    },
    
    
    JobTeamAddEditStaff : function(component, event, helper){
        if(component.get("v.JobDetailAccessible[3]")){      
            component.set("v.isAddEditTeamMembers",true);
            var recId = component.get("v.recordId");
            var teamEdit = component.get("c.JobTeamAddEditStaffCont");
            teamEdit.setParams({
                recordId: recId
            });
            
            teamEdit.setCallback(this, function(TeamEditresponse) {
                var TeamEditstate = TeamEditresponse.getState();
                console.log("State of Team Eidt" + TeamEditstate);
                if (TeamEditstate === "SUCCESS") {
                    console.log('===All Staff Wrappers====='+ JSON.stringify(TeamEditresponse.getReturnValue()));
                    component.set("v.AllstaffWrappersJobTeam",TeamEditresponse.getReturnValue());
                }
                else if (TeamEditstate === "ERROR") {
                    var errors = TeamEditresponse.getError(); 
                    console.log("Error message: " + errors);
                    if (errors) { 
                        if (errors[0] && errors[0]) { 
                            console.log("Error message --: " + JSON.stringify(errors));
                        }
                    } 
                    else { 
                        console.log("Unknown error"); 
                    } 
                }
                
            });
            
            $A.enqueueAction(teamEdit);
        }                else{
            helper.showToast({
                "title": "Error!!",
                "type": "error",
                "message": 'Team has insufficient access to create'
            });   
        }
    },
    
    addStafftoJobTeam : function(component, event, helper){
        var recId = component.get("v.recordId");
        var allstaffWrappers=component.get("v.AllstaffWrappersJobTeam");
        var StaffWrapperString = JSON.stringify(allstaffWrappers);
        console.log('====allstaffWrappers====='+allstaffWrappers);
        console.log('====Json String====='+StaffWrapperString);
        var AddStaffMembers = component.get("c.AddstafftoJobTeam");
        AddStaffMembers.setParams({
            jobId: recId,
            selectedJobTeam: StaffWrapperString
            
        });
        
        AddStaffMembers.setCallback(this, function(addResponse) {
            var addResState = addResponse.getState();
            console.log("=====addResState===" + addResState);
            if (addResState === "SUCCESS") {
                if(addResponse.getReturnValue()==='OK'){
                    helper.JobTeamsfetch(component, event, helper);
                    helper.JobTasksfetch(component, event);
                    component.set("v.isAddEditTeamMembers",false);
                    helper.showToast({ 
                        "type": "success",
                        "message": "Job Team Members are Updated."
                    });
                    var appEvent=$A.get("e.JobSuite:UpdateRecordsforChanges");
                    if(appEvent)
                    {
                        appEvent.fire();
                    }
                    
                }
                else{
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": addResponse.getReturnValue()
                    });   
                }
                
                
            }
            else if (addResState === "ERROR") {
                var errors = addResponse.getError(); 
                console.log("Error message: " + errors);
                if (errors) { 
                    if (errors[0] && errors[0]) { 
                        console.log("Error message --: " + JSON.stringify(errors));
                    }
                } 
                else { 
                    console.log("Unknown error"); 
                } 
            }
            
        });
        
        $A.enqueueAction(AddStaffMembers);
        
    },
    
    onChangeStaffType : function(component, event, helper){
        var selectType=component.find("staffselect").get("v.value");
        var recId = component.get("v.recordId");
        var allstaffWrappers=component.get("v.AllstaffWrappersJobTeam");
        var StaffWrapperString = JSON.stringify(allstaffWrappers);
        console.log('====onChangeStaffType allstaffWrappers====='+JSON.stringify(allstaffWrappers));
        
        //console.log('===JobTeamAddEditStaff===recId=='+recId+'  '+typeof(recId));
        var serchStaff = component.get("c.SerachStaff");
        serchStaff.setParams({
            jobId: recId,
            StatusString:selectType
        });
        
        serchStaff.setCallback(this, function(searchResponse) {
            var searchState = searchResponse.getState();
            console.log("===searchState==" + searchState);
            if (searchState === "SUCCESS") {
                //console.log('===searchState All Staff Wrappers====='+ JSON.stringify(searchResponse.getReturnValue()));
                component.set("v.AllstaffWrappersJobTeam",searchResponse.getReturnValue());
            }
            else if (searchState === "ERROR") {
                var errors = searchResponse.getError(); 
                console.log("Error message: " + errors);
                if (errors) { 
                    if (errors[0] && errors[0]) { 
                        console.log("Error message --: " + JSON.stringify(errors));
                    }
                } 
                else { 
                    console.log("Unknown error"); 
                } 
            }
            
        });
        
        $A.enqueueAction(serchStaff);
    },
    
    updateColumnSorting: function(cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        //alert('fieldName === '+fieldName + 'sortDirection === '+sortDirection);
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },
    
    openModel: function(component, event, helper) {
        if(component.get("v.JobDetailAccessible[4]")){  
            component.set("v.isOpen", true);}
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!!",
                "type": "error",
                "message": "Spec has insufficient access to create"
            });
            toastEvent.fire();
        }
    },
    
    YesAction : function(component,event,helper) {
        //  alert('yes action');
        var editRecord =  component.find("TaskTable").get("v.draftValues");
        console.log('====editedRecords======'+JSON.stringify(editRecord));
        var totalRecordEdited = editRecord.length;
        
        console.log('====total Records======'+totalRecordEdited);
        console.log('==Revised date id=='+editRecord[0].Revised_Due_Date__c);
        console.log('==row id=='+editRecord[0].Id);
        console.log('==row days=='+editRecord[0].Days__c);
        
        var taskId1=editRecord[0].Id;
        var days1=editRecord[0].Days__c;
        var revdate=editRecord[0].Revised_Due_Date__c;
        if(days1!=null){
            helper.updateScheduleOnDays(component, event, helper, taskId1,days1,true);
        }
        else if(revdate!=null){
            helper.updateRestSchedule(component, event, helper, taskId1,revdate,true); 
        }
    },
    
    NoAction : function(component,event,helper) {
        // alert('NoAction');
        var editRecord =  component.find("TaskTable").get("v.draftValues");
        console.log('====editedRecords======'+JSON.stringify(editRecord));
        var totalRecordEdited = editRecord.length;
        console.log('====totalRecordEdited======'+totalRecordEdited);
        console.log('==Task name =='+editRecord[0].Name);
        console.log('==Revised date id=='+editRecord[0].Revised_Due_Date__c);
        console.log('==row id=='+editRecord[0].Id);
        console.log('==NoAction row days=='+editRecord[0].Days__c); 
        
        var taskId1=editRecord[0].Id;
        var days1=editRecord[0].Days__c;
        var revdate=editRecord[0].Revised_Due_Date__c;
        console.log('taskId1 === '+taskId1+'days1 === '+days1+'revdate === '+revdate+'\n');
        if(days1!=null){
            console.log('days1 === '+days1+'\n');
            helper.updateScheduleOnDays(component,event,helper,taskId1,days1,false);
        }
        else if(revdate!=null){
            console.log('revdate === '+revdate+'\n');
            helper.updateRestSchedule(component, event, helper, taskId1,revdate,false);    
        }
    },
    
    YesEditDaysAction : function(component,event,helper) {
        //alert('YesEditDaysAction === ');
        component.set("v.isDaysChanged",true);
        component.get('v.overlayPanel').then(
            function (modal) {
                modal.close();
            }
        );
    },
    
    NoEditDaysAction : function(component,event,helper) {
        // alert('NoEditDaysAction === ');
        component.set("v.isDueDateFieldChanged",false);//this line is for edit task quick action by manindra on 3 - 2 - 2023
        component.set("v.isDaysChanged",false);
        component.get('v.overlayPanel').then(
            function (modal) {
                modal.close();
            }
        );
    },
    
    EditDaysChanged : function(component,event,helper) {
        var Days=event.getParam('value');
        //alert('EditDaysChanged === '+Days);
        console.log('=== changed value==='+Days!=null);
        console.log('===Days second changed value==='+(Days!=''));
        if(Days!=null && Days!=''  ){          
            helper.EditTaskDaysChanged(component,event,helper);
        }
        
    },
    
    YesEditDateAction : function(component,event,helper) {
        component.set("v.isDueDateChanged",true);
        component.get('v.overlayPanel').then(
            function (modal) {
                modal.close();
            }
        );
    },
    
    NoEditDateAction : function(component,event,helper) {
        component.set("v.isDueDateChanged",false);
        component.set("v.isDueDateFieldChanged",true);//this line is for edit task quick action by manindra on 3 - 2 - 2023
        component.get('v.overlayPanel').then(
            function (modal) {
                modal.close();
            }
        );
    },
    
    EditDueDateChanged : function(component,event,helper) {
        var Date=event.getParam('value');
        console.log('=== changed value==='+Date!=null);
        console.log('===Days second changed value==='+(Date!=''));
        if(Date!=null && Date!=''  ){          
            helper.EditTaskDateChanged(component,event,helper);
        }
    },
    
    printSchedule : function(component, event, helper) {
        var jobid=component.get("v.recordId");
        window.open('/one/one.app#/alohaRedirect/apex/ScheduleReport?id='+jobid,'_blank'); 
    },
    
    copySchedule : function(component, event, helper) {
        if(component.get("v.JobDetailAccessible[6]")){
            helper.copyScheudlehelper(component, event);
            component.set("v.isCopyOpen", true); 
        }else{
            helper.showToast({
                "title": "Error!!",
                "type": "error",
                "message": 'Error, Tasks have insufficient access to create'
            }); 
        }
        
    },
    
    
    copyCampSchedule : function(component, event, helper) {
        if(component.get("v.JobDetailAccessible[6]")){
            helper.copyCampScheudlehelper(component, event);
            component.set("v.isCampSchCopyOpen", true); 
        }else{
            helper.showToast({
                "title": "Error!!",
                "type": "error",
                "message": 'Error, Tasks have insufficient access to create'
            }); 
        }
        
    },
    
    SavecopySchedule : function(component, event, helper) {
        var selcted=component.get("v.selected_CopyScheJobs");
        if(selcted!=null){
            helper.helpSavecopySchedule(component, event, helper);   
        }
        else{
            var ToastMsg1 = $A.get("e.force:showToast");
            ToastMsg1.setParams({
                "title": "Error",
                "type": "error",
                "message": "Please Select at least one Job to Copy Schedule."
            });  
            ToastMsg1.fire();
        }
        
    },
    
    SavecopyCampSchedule : function(component, event, helper) {
        var selcted=component.get("v.selected_CopyCampScheJobs");
        if(selcted!=null){
            helper.helpSavecopyCampSchedule(component, event, helper);   
        }
        else{
            var ToastMsg1 = $A.get("e.force:showToast");
            ToastMsg1.setParams({
                "title": "Error",
                "type": "error",
                "message": "Please Select at least one Job to Copy Schedule."
            });  
            ToastMsg1.fire();
        }
        
    },
    
    
    OnchangeStatus : function(component, event, helper) {
        $('#calendar').fullCalendar('rerenderEvents');
    },
    
    CancelcopySchedule : function(component, event, helper) {
        component.set("v.isCopyOpen", false);
        component.set("v.selected_CopyScheJobs",null);
        component.set('v.selCopyScheRowsCount',null);
    },
    
    CancelcopyCampSchedule : function(component, event, helper) {
        component.set("v.isCampSchCopyOpen", false);
        component.set("v.selected_CopyCampScheJobs",null);
        component.set('v.selCampCopyScheRowsCount',null);
    },
    
    updateCopySelectedJobs: function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        cmp.set('v.selected_CopyScheJobs', selectedRows);   
        cmp.set('v.selCopyScheRowsCount', selectedRows.length);
    },
    
    updateCampSchCopySelectedJobs: function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        cmp.set('v.selected_CopyCampScheJobs', selectedRows);   
        cmp.set('v.selCampCopyScheRowsCount', selectedRows.length);
    },
    
    showCalenderView: function(component, event, helper) {
        //helper.fetchCalenderEvents(component, event, helper);
        component.set("v.isListview", false);
    },
    
    showListView: function(component, event, helper) {
        helper.JobTasksfetch(component, event); 
        component.set("v.isListview", true);
    },
    
    insertatEnd : function(component, event, helper) {
        if(component.get("v.JobDetailAccessible[7]")){
            component.set("v.isBelowInsert",true);}
        else{
            helper.showToast({
                "title":"Error!!",
                "type": "error",
                "message": 'Task has insufficient access to create'
            }); 
        }
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.isOpen", false);
        component.set("v.specrecordId", null);
    },
    
    closeTaskModel: function(component, event, helper) {
        component.set("v.EditTaskId",null);
        component.set("v.isTaskEdit",false);
    },
    
    closeAboveTaskModel: function(component, event, helper) {
        component.set("v.isAboveInsert",false);
    },
    
    closeBelowTaskModel: function(component, event, helper) {
        component.set("v.isBelowInsert",false);
    },
    
    
    handleSaveEdition : function (component, event, helper) {
        helper.saveDataTableofTasks(component, event, helper);
    },
    
    handleSaveSpecs : function (component, event, helper) {
        helper.saveDataTableofSpecs(component, event, helper);
    },
    
    handlecreateSchedule : function(component, event, helper){
        component.set("v.ShowScheduleBtn",true);
        if(component.get("v.JobDetailAccessible[6]")){
            var takslenght=component.get("v.taskdata").length;
            console.log('======takslenght==='+takslenght);
            if(takslenght!=0){
                if(!confirm("This will delete tasks on current schedule and recreate new schedule")){
                    return false;
                }
                component.set("v.ShowScheduleBtn",true);
                helper.createSchedule(component, event, helper);  
            }
            else{
                helper.createSchedule(component, event, helper);  
            }
            
        }else{
            component.set("v.ShowScheduleBtn",false);
            helper.showToast({
                "title": "Error!!",
                "type": "error",
                "message": 'Error, Tasks have insufficient access to create'
            }); 
        }
    },
    
    handleCellChangeAction :function (component, event, helper) {
        var editRecord =  component.find("TaskTable").get("v.draftValues");
        console.log('====editedRecords======'+JSON.stringify(editRecord));
        var totalRecordEdited = editRecord.length;
        console.log('totalRecordEdited === '+totalRecordEdited);
        console.log('==row days=='+editRecord[0].Days__c); 
        console.log('==due date=='+editRecord[0].Revised_Due_Date__c); 
        var markdone=false;
        var dayAll=false;
        var reveAll=false;
        
        for (var i = 0; i < editRecord.length; i++) {
            var ss= editRecord[i].Marked_Done__c;
            if(ss!=null){
                markdone=true;
                break;
            }
        }
        for (var i = 0; i < editRecord.length; i++) {
            var sd= editRecord[i].Days__c;
            var srev= editRecord[i].Revised_Due_Date__c;
            if(sd!=null || srev!=null){
                dayAll=true;
                reveAll=true;
                break;
            }
        }
        
        var days1=editRecord[0].Days__c;
        var revdate=editRecord[0].Revised_Due_Date__c;
        
        if(revdate==''){
            // alert('Please select the date');
            // return false; 
        }if(days1==''){
            //alert('Please enter value for days.');
            // return false;
        }
        
        if( dayAll || reveAll){
            if(markdone){
                component.find("TaskTable").set("v.draftValues", null);   
            }
            else{
                if(component.get("v.JobDetailAccessible[7]")){ 
                    helper.cellChangeValues(component, event, helper);  
                }  else{
                    helper.showToast({
                        "title":"Error!!",
                        "type": "error",
                        "message": 'Task has insufficient access to edit/update'
                    }); 
                }
            }
            
        }
        
    },
    
    jobspecOnsubmit: function(component, event, helper) {
        event.preventDefault(); // Prevent default submit
        var Jobspecfields = event.getParam("fields");
        Jobspecfields["Job__c"] = component.get("v.recordId");
        
        var missField = "";
        var reduceReutrn = component.find('JobSpecField').reduce(function(validFields, inputCmp) {
            if (inputCmp.get("v.fieldName") == "Name") {
                var SpecName = inputCmp.get("v.value");
                if (SpecName == null || SpecName == '') {
                    missField = "Spec Name";
                }
            }
        }, true);
        
        var ToastMsg = $A.get("e.force:showToast");
        ToastMsg.setParams({
            "title": "Name",
            "type": "error",
            "message": missField + " Field is required."
            
        });
        
        
        if (missField == "Spec Name") {
            ToastMsg.fire();
            event.preventDefault();
        } else {
            component.find("JobSpecEditform").submit(Jobspecfields);
        }
    },
    
    JobSpecSucess: function(component, event, helper) {
        var specId=component.get("v.specrecordId");
        var textmsg;
        if(specId==null || specId==''){
            textmsg='Successfully Inserted Job Spec Record.';
        }
        else{
            textmsg='Successfully Updated Job Spec Record.';
        }
        component.set("v.specrecordId",null);
        component.set("v.isOpen", false);        
        var ToastMsg1 = $A.get("e.force:showToast");
        ToastMsg1.setParams({
            "title": "Success",
            "type": "success",
            "message": textmsg
            
        });
        ToastMsg1.fire();
        helper.JobSpecsfetch(component, event);
        
    },
    
    SpecPrint: function(component, event, helper) {
        var jobid=component.get("v.recordId");
        window.open('/one/one.app#/alohaRedirect/apex/creativebriefreport?Id='+jobid,'_blank'); 
    },
    handleSpecRowActions: function(component, event, helper) {
        
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'Edit_JobSpec':
                if(component.get("v.JobDetailAccessible[5]")){ 
                    component.set("v.specrecordId", row.Id);
                    component.set("v.isOpen", true);
                }else{
                    var ToastMsg1 = $A.get("e.force:showToast");
                    ToastMsg1.setParams({
                        "title": "ERROR",
                        "type": "error",
                        "message": 'Spec has insufficient access to edit'                        
                    });
                    ToastMsg1.fire();
                }
                break;
            case 'view_details':
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": row.Id,
                    "slideDevName": "detail"
                });
                navEvt.fire();
                break;
            case 'Delete_JobSpec':
                helper.DeleteSpec(component, event, helper);
                break;
        }
    },
    
    handleTaskRowActions: function(component, event, helper) {
        // DeleteTask  ActiveTask CompleteTask tskid
        var action = event.getParam('action');
        console.log('===action======'+action);
        var row = event.getParam('row');
        console.log('===row======'+JSON.stringify(row));
        switch (action.name) {
            case 'Task_Done':
                if(component.get("v.JobDetailAccessible[7]")){ 
                    helper.CompleteTask(component, event, helper);}
                else{
                    helper.showToast({
                        "title":"Error!!",
                        "type": "error",
                        "message": 'Task has insufficient access to edit/update'
                    }); 
                }
                break;
                
                
                /***************************************** Approval Process Starts***********************************************/    
                
            case 'FileAttach':
                component.set("v.isFileAttach",true);
                component.set("v.JobTaskIdforApprovals",row.Id);
                var recId = component.get("v.recordId");
                var FetchFiles = component.get("c.getAttachments");
                FetchFiles.setParams({
                    recordId : recId
                });
                FetchFiles.setCallback(this, function(Response) {
                    console.log('===FilesState======'+Response.getReturnValue());
                    var FilesState = Response.getState();
                    if (FilesState === "SUCCESS") {
                        var Files=Response.getReturnValue();
                        console.log('===Files======'+Files);
                        var FileList=[];
                        for(var key in Files){
                            FileList.push({ key: key, value:Files[key]});
                        }
                        component.set("v.JobFileList",FileList);
                        
                    }
                });
                $A.enqueueAction(FetchFiles);
                break;       
                
                /*******************************below Newly added for file preview****************************/
                /* case 'FilePreview':
                let compDefinition = {
            componentDef: "JobSuite:pdftronWvInstanceTask",
            attributes: {
                recordId: row.Id
            }
        };*/
                // Base64 encode the compDefinition JS object
                let encodedCompDef = btoa(JSON.stringify(compDefinition));
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": "/one/one.app#" + encodedCompDef
                });
                urlEvent.fire();
                break;
                
            case 'Create_Approval_Process':
                component.set("v.isCreateApprovalProcess",true);
                component.set("v.JobTaskIdforApprovals",row.Id);
                var recId = component.get("v.recordId");
                var FetchFiles = component.get("c.getAttachments");
                FetchFiles.setParams({
                    recordId : recId
                });
                FetchFiles.setCallback(this, function(Response) {
                    console.log('===FilesState======'+Response.getReturnValue());
                    var FilesState = Response.getState();
                    if (FilesState === "SUCCESS") {
                        var Files=Response.getReturnValue();
                        var FileList=[];
                        for(var key in Files){
                            FileList.push({ key: key, value:Files[key]});
                        }
                        component.set("v.JobFileList",FileList);
                        
                    }
                });
                $A.enqueueAction(FetchFiles);
                
                var ApprovalSchTemp = component.get("c.getApprovalSchTemplates");
                
                ApprovalSchTemp.setCallback(this, function(Response) {
                    console.log('===getApprovalSchTemplates State======'+Response.getReturnValue());
                    var AschtempState = Response.getState();
                    if (AschtempState === "SUCCESS") {
                        var Appschtemp=Response.getReturnValue();
                        var AppschtempList=[];
                        for(var key in Appschtemp){
                            AppschtempList.push({ key: key, value:Appschtemp[key]});
                        }
                        component.set("v.AppschedTempList",AppschtempList);
                        
                    }
                });
                $A.enqueueAction(ApprovalSchTemp);
                break;
                /***************************************** Approval Process Ends***********************************************/
                
            case 'Task_Open':
                if(component.get("v.JobDetailAccessible[7]")){
                    helper.ActiveTask(component, event, helper);}
                else{
                    helper.showToast({
                        "title":"Error!!",
                        "type": "error",
                        "message": 'Task has insufficient access to edit/update'
                    }); 
                }
                break;
                
            case 'Task_AddEdit':
                if(component.get("v.JobDetailAccessible[8]")){
                    component.set("v.AddEditStaffTaskId",row.Id);
                    component.set("v.isaddEditStaff",true);
                    component.find("AddEditStaffMembers").refreshStaffMembers();
                }
                else{
                    helper.showToast({
                        "title":"Error!!",
                        "type": "error",
                        "message": 'Task role has insufficient access to edit/update'
                    }); 
                }
                break;
                
            case 'Task_LogTime':
                if(component.get("v.JobDetailAccessible[9]")){
                    component.set("v.LogTaskId",row.Id);
                    component.set("v.isTaskLogTime",true); 
                    component.find("LogTimeId").refreshTaskData();}
                else{
                    helper.showToast({
                        "title":"Error!!",
                        "type": "error",
                        "message": 'Time sheet entry has insufficient access to create'
                    });  
                }
                
                break;
                
            case 'Task_Edit':
                if(component.get("v.JobDetailAccessible[7]")){
                    component.set("v.EditTaskId",row.Id);
                    component.set("v.isTaskEdit",true);}
                else{
                    helper.showToast({
                        "title":"Error!!",
                        "type": "error",
                        "message": 'Task has insufficient access to edit/update'
                    });   
                }
                
                break;
                
            case 'Task_Above':
                if(component.get("v.JobDetailAccessible[6]")){
                    component.set("v.AboveTaskRecordId",row.Id);
                    component.set("v.isAboveInsert",true);}
                else{
                    helper.showToast({
                        "title":"Error!!",
                        "type": "error",
                        "message": 'Task has insufficient access to create'
                    });   
                }
                break;
                
            case 'Task_Delete':
                helper.DeleteTask(component, event, helper);
                break;
                
            case 'HasApprovals':
                console.log('>>>>>>HasApprovals popup>>>>>>>>>>>>>');
                component.set("v.isViewApprovalProcess",true);
                var jobtskId = row.Id;
                helper.HasApprovalssteps(component, event, helper, jobtskId);
                break;
                
        }
    },
    
    TaskOnLoad : function(component, event, helper){
        var TaskrecId=component.get("v.EditTaskId");
        console.log('===record Load==='+TaskrecId);
        if(TaskrecId!=null){
            var Taskfields = event.getParam("recordUi");
             console.log('===Taskfields==='+JSON.stringify(Taskfields));
            component.set("v.isTaskLocked",Taskfields.record.fields.Locked__c.value);
            component.set("v.isLoadedDate",Taskfields.record.fields.Revised_Due_Date__c.value);
            component.set("v.isLoadedDays",Taskfields.record.fields.Days__c.value); 
          //  console.log('===ID==='+Taskfields.record.fields.GL_Code__r.value.fields.Id.value);
           // console.log('===Name==='+Taskfields.record.fields.GL_Code__r.value.fields.Name.value);
          /*  if(Taskfields.record.fields.GL_Code__c.value!=null ){
                var GLcodeObj={"Id":Taskfields.record.fields.GL_Code__r.value.fields.Id.value, "Name":Taskfields.record.fields.GL_Code__r.value.fields.Name.value};
                component.find("GL_CodeId").sampleMethod(GLcodeObj);
            }*/
        }
    },
    
    TaskOnsubmit : function(component, event, helper){
        event.preventDefault(); // Prevent default submit
        var fields = event.getParam("fields");
        console.log('===fields=='+JSON.stringify(fields));
        //fields["Job_Description__c"] = 'This is a default description'; // Prepopulate Description field
        var NameField="";
        var StausField="";
        var DueDateField="";
        var reduceReutrn=component.find('JobTaskFields').reduce(function (validFields, inputCmp) {
            if(inputCmp.get("v.fieldName") == "Name"){
                var TaskName =inputCmp.get("v.value");
                if(TaskName==null || TaskName==''){
                    NameField="Name";
                }
            }
            else if(inputCmp.get("v.fieldName") == "Status__c"){
                var status =inputCmp.get("v.value");
                if(status==null || status==''){
                    StausField="Status";
                }
                else if(status=='Completed')
                {
                    if(fields["Completion_Date__c"] == null)
                    {
                        var today = component.get("v.todayDate");
                        fields["Completion_Date__c"]=today;
                    }
                    fields["Marked_Done__c"]=true;
                }
                    else if(status=='Active'|| status=='Requested')
                    {
                        fields["Marked_Done__c"]=false;
                        fields["Completion_Date__c"]=null;
                    }
            }
                else if(inputCmp.get("v.fieldName") == "Revised_Due_Date__c"){
                    var DueDate =inputCmp.get("v.value");
                    if(DueDate==null || DueDate==''){
                        DueDateField="Due Date";
                    }
                }
        }, true);
        var ToastMsg=$A.get("e.force:showToast");
        ToastMsg.setParams({
            "title":NameField,
            "type": "error",
            "message": NameField+" Field is required."
            
        });
        var ToastMsg1=$A.get("e.force:showToast");
        ToastMsg1.setParams({
            "title":StausField,
            "type": "error",
            "message": StausField+" Field is required."
            
        });
        var ToastMsg2=$A.get("e.force:showToast");
        ToastMsg2.setParams({
            "title":DueDateField,
            "type": "error",
            "message": DueDateField+" Field is required."
            
        });
        if(NameField=="Name"){
            ToastMsg.fire();
            event.preventDefault();
        }
        else if(StausField=="Status"){
            ToastMsg1.fire();
            event.preventDefault();
        }
            else if(DueDateField=="Due Date"){
                ToastMsg2.fire();
                event.preventDefault();
            }
                else{
                    if(typeof(component.get("v.selectedLookUpRecord_GLCode").Id)==="undefined"){
                        fields["GL_Code__c"]="";
                    }
                    else{
                        fields["GL_Code__c"]=component.get("v.selectedLookUpRecord_GLCode").Id;  
                    }
                    console.log('===fields last=='+JSON.stringify(fields));
                    component.find("TaskEditForm").submit(fields);
                }
    },
    
    TaskOnSuccess : function(component, event, helper){
        var TaskId=component.get("v.EditTaskId");
        var UpdateRestDays=component.get("v.isDaysChanged");
        var UpdateRestDates=component.get("v.isDueDateChanged");
        var UpdateDueDateField=component.get("v.isDueDateFieldChanged");
        helper.TaskEditSucess(component, event, helper,TaskId,UpdateRestDays,UpdateRestDates,UpdateDueDateField);
    }, 
    
    TaskAboveOnsubmit : function(component, event, helper){
        event.preventDefault(); // Prevent default submit
        var RoleString='';
        var x=document.getElementById("RolesList");
        for (var i = 0; i < x.options.length; i++) {
            if(x.options[i].selected ==true){
                if(x.options[i].value!=''){
                    RoleString+=x.options[i].value+';'
                }
            }
        }
        
        if (RoleString.endsWith(";")) {
            RoleString = RoleString.substring(0, RoleString.length - 1);
        }
        
        console.log('======RoleString=='+RoleString);
        
        var fields = event.getParam("fields");
        fields["Job__c"]=component.get("v.recordId");
        console.log('===fields=='+JSON.stringify(fields));
        //fields["Job_Description__c"] = 'This is a default description'; // Prepopulate Description field
        var NameField="";
        var reduceReutrn=component.find('JobTaskAboveFields').reduce(function (validFields, inputCmp) {
            if(inputCmp.get("v.fieldName") == "Name"){
                var TaskName =inputCmp.get("v.value");
                if(TaskName==null || TaskName==''){
                    NameField="Name";
                }
            }
        }, true);
        var ToastMsg=$A.get("e.force:showToast");
        ToastMsg.setParams({
            "title":NameField,
            "type": "error",
            "message": NameField+" Field is required."
        });
        if(NameField=="Name"){
            ToastMsg.fire();
            event.preventDefault();
        }
        else{
            if(typeof(component.get("v.selectedLookUpRecordAbove_GLCode").Id)==="undefined"){
                fields["GL_Code__c"]="";
            }
            else{
                fields["GL_Code__c"]=component.get("v.selectedLookUpRecordAbove_GLCode").Id;  
            }
            // alert('AboveTaskRecordId === '+component.get("v.AboveTaskRecordId"));
            var Aboveaction=component.get("c.InsertAboveLoad");
            Aboveaction.setParams({
                taskid : component.get("v.AboveTaskRecordId"),
                days :fields["Days__c"],
                RolesList: RoleString
            });
            Aboveaction.setCallback(this, function(AboveResponse){
                if (AboveResponse.getState() === "SUCCESS") {
                    var rows=AboveResponse.getReturnValue();
                    console.log('=======AboveResponse====='+JSON.stringify(rows));
                    fields["Task_Order__c"]=rows[0];
                    //the below if condition added on 19 - 12 - 2022 by manindra otherwise only else conditions are there
                    console.log('rows[5] === '+rows[5]+'rows[4] === '+rows[4]+'rows[3] === '+rows[3]+'rows[2] === '+rows[2]+'rows[1] === '+rows[1]+'\n');
                    if(rows[5]){
                        console.log('rows[5] === '+rows[5]);
                        if(rows[4] == 'End Date'){
                            console.log('End date === ');
                            fields["Start_Date__c"]=rows[1];
                            fields["Due_Date__c"]=rows[2];
                            fields["Revised_Due_Date__c"]=rows[2];
                        }
                        else{
                            console.log('start date === ');
                            fields["Start_Date__c"]=rows[1];
                            fields["Due_Date__c"]=rows[2];
                            fields["Revised_Due_Date__c"]=rows[2];  
                        }
                    }
                    else{
                        console.log('else rows[5] === '+rows[5]);
                        if(rows[4] == 'End Date'){
                            console.log('End date === ');
                            fields["Start_Date__c"]=rows[2];
                            fields["Due_Date__c"]=rows[1];
                            fields["Revised_Due_Date__c"]=rows[1];
                        }
                        else{
                            console.log('start date === ');
                            fields["Start_Date__c"]=rows[1];
                            fields["Due_Date__c"]=rows[2];
                            fields["Revised_Due_Date__c"]=rows[2];  
                        }  
                    }
                    
                    /*  if(rows[4] == 'End Date'){
                        console.log('End date === ');
                        fields["Start_Date__c"]=rows[2];
                        fields["Due_Date__c"]=rows[1];
                        fields["Revised_Due_Date__c"]=rows[1];
                    }
                    else{
                        console.log('start date === ');
                        fields["Start_Date__c"]=rows[1];
                        fields["Due_Date__c"]=rows[2];
                        fields["Revised_Due_Date__c"]=rows[2];  
                    }*/
                    
                    fields["Schedule_Roles__c"]=rows[3];    
                    console.log('===fields last=='+JSON.stringify(fields));
                    component.find("TaskAboveEditForm").submit(fields);
                }
            }); 
            
            $A.enqueueAction(Aboveaction); 
        }
        
    },
    
    TaskAboveOnSuccess : function(component, event, helper){
        var Oldtaskid=component.get("v.AboveTaskRecordId");
        var NewTaskId=event.getParams().response.id;
        var strid=component.get("v.recordId");
        helper.InsertAboveSucess(component, event,helper,Oldtaskid,NewTaskId,strid);  
    },
    
    TaskBelowOnsubmit : function(component, event, helper){
        event.preventDefault(); // Prevent default submit
        var RoleStringBelow='';
        var x=document.getElementById("RolesListBelow");
        console.log('===document.getElementById("RolesListBelow");=='+x);
        for (var i = 0; i < x.options.length; i++) {
            if(x.options[i].selected ==true){
                if(x.options[i].value!=''){
                    RoleStringBelow+=x.options[i].value+';'
                    console.log('RoleStringBelow in for === '+RoleStringBelow);
                }
            }
        }
        
        if (RoleStringBelow.endsWith(";")) {
            RoleStringBelow = RoleStringBelow.substring(0, RoleStringBelow.length - 1);
        }
        
        console.log('======RoleString=='+RoleStringBelow);
        //  alert('======RoleString=='+RoleStringBelow);
        
        var fields = event.getParam("fields");
        fields["Job__c"]=component.get("v.recordId");
        console.log('===fields=='+JSON.stringify(fields));
        //fields["Job_Description__c"] = 'This is a default description'; // Prepopulate Description field
        
        var NameField="";
        var reduceReutrn=component.find('JobTaskBelowFields').reduce(function (validFields, inputCmp) {
            if(inputCmp.get("v.fieldName") == "Name"){
                var TaskName =inputCmp.get("v.value");
                if(TaskName==null || TaskName==''){
                    NameField="Name";
                }
            }
            
        }, true);
        
        var ToastMsg=$A.get("e.force:showToast");
        ToastMsg.setParams({
            "title":NameField,
            "type": "error",
            "message": NameField+" Field is required."
            
        });
        
        if(NameField=="Name"){
            ToastMsg.fire();
            event.preventDefault();
        }
        else{
            
            if(typeof(component.get("v.selectedLookUpRecordBelow_GLCode").Id)==="undefined"){
                fields["GL_Code__c"]="";
            }
            else{
                fields["GL_Code__c"]=component.get("v.selectedLookUpRecordBelow_GLCode").Id;  
            }
            
            var Belowaction=component.get("c.InsertBelowLoad");
            
            Belowaction.setParams({
                jobid : component.get("v.recordId"),
                days :fields["Days__c"],
                RolesList: RoleStringBelow
                
            });
            
            Belowaction.setCallback(this, function(belowResponse){
                if (belowResponse.getState() === "SUCCESS") {
                    var rows=belowResponse.getReturnValue();
                    console.log('=======BelowAction Load===='+JSON.stringify(rows));
                    fields["Task_Order__c"]=rows[0];
                    fields["Start_Date__c"]=rows[1];
                    fields["Due_Date__c"]=rows[2];
                    fields["Revised_Due_Date__c"]=rows[2];
                    fields["Schedule_Roles__c"]=rows[3];    
                    console.log('===TaskBelowEditForm fields last=='+JSON.stringify(fields));
                    component.find("TaskBelowEditForm").submit(fields);
                }
            }); 
            
            $A.enqueueAction(Belowaction); 
            
        }
        
    },
        
    TaskBelowOnSuccess : function(component, event, helper){
        var event = event.getParams();
         console.log('===event====='+JSON.stringify(event));
        //console.log('===Insert below response====='+JSON.stringify(event.getParams().response.fields));
       // console.log('===Json below Start Date above response====='+JSON.stringify(event.getParams().response.fields.Start_Date__c.value));
       // console.log('===Json below Task Order above response====='+JSON.stringify(event.getParams().response.fields.Task_Order__c.value));
        var Taskid=event.getParams().response.id;
        console.log('===Taskid====='+Taskid);
        var strid=component.get("v.recordId");
        
        var TaskOrder=event.getParams().response.fields.Task_Order__c.value;
        var StartDate=event.getParams().response.fields.Start_Date__c.value;
        //alert('Task id === '+Taskid+''+'Rcd id === '+strid+''+'TaskOrder === '+TaskOrder+''+'StartDate === '+''+StartDate);
        helper.InsertBlowSucess(component, event,helper,Taskid,strid,TaskOrder,StartDate);  
    },
        
    /************** Mobile Action ******************************/
    
    MarkdoneTskMob: function(component, event, helper){
        var tskId = event.getSource().get("v.name");
        var tskMarked = event.getSource().get("v.value");
        
        console.log('=== tskId ====='+tskId);
        console.log('=== tskMarked ====='+tskMarked);
        
        if(tskMarked)
        {
            helper.CompleteTask(component, event, helper,tskId);
        }
        else
        {
            helper.ActiveTask(component, event, helper,tskId);
        }
        
    },
    
    handleTaskQuickAction : function(component, event, helper) {
        var selectOption=event.getParam("value");
        var selectTaskId=event.getSource().get("v.name");
        console.log('---selectTaskId-'+selectTaskId+'---option--'+selectOption);
        if(selectOption=='Edit'){
            component.set("v.EditTaskId",selectTaskId);
            component.set("v.isTaskEdit",true);
        }
        if(selectOption=='Delete'){ 
            helper.DeleteTask(component, event, helper,selectTaskId);
        }
        if(selectOption=='LogTime'){ 
            component.set("v.LogTaskId",selectTaskId);
            component.set("v.isTaskLogTime",true); 
            component.find("LogTimeId").refreshTaskData();
        }
        
    },
    
    handleSpecQuickAction : function(component, event, helper) {
        var selectOption=event.getParam("value");
        var selectSpecId=event.getSource().get("v.name");
        console.log('---selectSpecId-'+selectSpecId+'---option--'+selectOption);
        if(selectOption=='Edit'){
            component.set("v.specrecordId", selectSpecId);
            component.set("v.isOpen", true);
        }
        else{ 
            helper.DeleteSpec(component, event, helper,selectSpecId);
        }
    },
    
    
    /***************************************** Approval Process Starts ***********************************************/
    
    
    closeHandleFileAttach: function(component, event, helper){
        component.set("v.isFileAttach",false);
    },
    
    handleFileAttach : function(component, event, helper){
        var FileId = component.find("FileId").get("v.value");
        var tskId = component.get("v.JobTaskIdforApprovals");
        console.log('>>>>>>>>handleFileAttach tskId>>>>>>>>>',tskId);
        console.log('>>>>>>>>FileId>>>>>>>>>',FileId);
        if(FileId!='')
        {
            component.set("v.isFileAttach",false);
            if(component.get("v.JobDetailAccessible[7]")){
                helper.handleFileAttachPro(component, event, helper, tskId); 
            }else{
                component.set("v.isFileAttach",true);
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Error, Tasks have insufficient access to update'
                }); 
            }
        }
        else{
            component.set("v.ShowScheduleBtn",false);
            helper.showToast({
                "title": "Error!!",
                "type": "error",
                "message": 'Error, You must select a file'
            }); 
        }
    },
    
    
    CancelViewApprovalProcess : function(component, event, helper){
        component.set("v.isViewApprovalProcess",false);
    },
    
    closeApprovalTaskFile : function(component, event, helper){
        component.set("v.isCreateApprovalProcess",false);
    },
    
    handlecreateApprovalPro : function(component, event, helper){
        
        var FileId = component.find("FileId").get("v.value");
        var AppSchedTempId = component.find("APPSchTempId").get("v.value");
        var tskId = component.get("v.JobTaskIdforApprovals");
        console.log('>>>>>>>>handlecreateApprovalPro tskId>>>>>>>>>',tskId);
        console.log('>>>>>>>>FileId>>>>>>>>>',FileId);
        console.log('>>>>>>>>AppSchedTempId>>>>>>>>>',AppSchedTempId);
        
        if(FileId!='' && AppSchedTempId!='')
        {
            component.set("v.isCreateApprovalProcess",false);
            if(component.get("v.JobDetailAccessible[1]")){
                helper.createScheduleApprovalPro(component, event, helper, tskId); 
                
                /* var takslenght=component.get("v.taskdata").length;
                console.log('======takslenght==='+takslenght);
                if(takslenght!=0){
                    if(!confirm("This will delete tasks on current schedule and recreate new schedule")){
                        return false;
                    }
                    component.set("v.ShowScheduleBtn",true);
                    helper.createSchedule(component, event, helper);  
                }
                else{
                    helper.createSchedule(component, event, helper);  
                }*/
                
            }else{
                component.set("v.isCreateApprovalProcess",true);
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Error, Approval Tasks have insufficient access to create'
                }); 
            }
            
        }
        else{
            component.set("v.ShowScheduleBtn",false);
            helper.showToast({
                "title": "Error!!",
                "type": "error",
                "message": 'Error, You must select a file and Template'
            }); 
        }
    },
    
    /***************************************** Approval Process Ends***********************************************/
    
    
    
    
    
})