({
    doInit : function(component, event, helper) {
        component.set("v.spinner",true);
        helper.fetchFieldLabels(component,event,helper);
        helper.fetchfiltervaluesandcustomsettingsdata(component,event,helper);
        helper.MyTaskrecordsfetchfortablevals(component,event,helper);
        // helper.MyTaskrecordsfetch(component,event,helper);
        /* var helpTextRec= component.get("c.getHelpTextrecords");
        helpTextRec.setCallback(this, function(helpTextResponse){
            if (helpTextResponse.getState() === "SUCCESS") {
                console.log('=Help Text Values=='+JSON.stringify(helpTextResponse.getReturnValue()));
                component.set("v.helpText",helpTextResponse.getReturnValue());
            }
        });
        $A.enqueueAction(helpTextRec); */
        
        //alert('init spinner'+s);
    },
    handleComponentEvent : function(component, event, helper) {
        component.set("v.spinner",true);
        //alert('handleComponentEvent spinner'+s);
        var cmpeventdata = event.getParam("stfname");
        //component.find('Staffsval').set("v.value",cmpeventdata);
        helper.getfilterrcds(component,event,helper);
    },
    
    
    updateColumnSorting : function(component, event, helper) {
        var ColumnName = event.target.title;
        // alert(ColumnName);
        if(ColumnName == 'Job_Task__r.Name'){
            helper.sortBy(component,helper, ColumnName);
        }
        else if(ColumnName == 'User__c'){
            helper.sortBy(component,helper, ColumnName);
        }
        
            else if(ColumnName == 'Job_Task__r.Job__r.Name'){
                helper.sortBy(component,helper, ColumnName);  
            }
                else if(ColumnName == 'Job_Task__r.Revised_Due_Date__c'){
                    helper.sortBy(component,helper, ColumnName);  
                }
                    else if(ColumnName == 'Job_Task__r.Job__r.Next_Tasks_Due__c'){
                        helper.sortBy(component,helper, ColumnName);  
                    }
                        else if(ColumnName == 'Job_Task__r.Job__r.Campaign__r.Name'){
                            helper.sortBy(component,helper, ColumnName);  
                        }
                            else if(ColumnName == 'Job_Task__r.Job__r.JS_Client__r.Name'){
                                helper.sortBy(component,helper, ColumnName);  
                            }
                                else if(ColumnName == 'Job_Task__r.Job__r.Job_Auto_Number__c'){
                                    helper.sortBy(component,helper, ColumnName);
                                }
    },
    
    handleTasksViewSel : function(component, event, helper) {
        
        var tkval = component.find('TaskVId').get('v.value');
        // alert(tkval);
        component.set("v.spinner",true);
        var s = component.get("v.spinner");
        //alert('tasks spinner'+s);
        helper.getfilterrcds(component,event,helper);
    },
    
    handlestaffViewSel : function(component, event, helper) {
        component.set("v.spinner",true);
        var s = component.get("v.spinner");
        //alert('tasks spinner'+s);
        var staffval = component.find('Staffsval').get('v.value');
        //  alert('val === '+staffval);
        // component.set('v.stfvals',staffval)
        //component.set("v.spinner",true);
        helper.getfilterrcds(component,event,helper);
        
    },
    
    handleroleViewSel : function(component, event, helper) {
        component.set("v.spinner",true);
        var s = component.get("v.spinner");
        //alert('tasks spinner'+s);
        var roleval = component.find('rolesval').get('v.value');
        // alert('val === '+roleval);
        
        helper.getfilterrcds(component,event,helper);
        
    },
    
    handleclientViewSel : function(component, event, helper) {
        var clientval = component.find('clientval').get('v.value');
        // alert('val === '+clientval);
        component.set("v.spinner",true);
        var s = component.get("v.spinner");
        //alert('tasks spinner'+s);
        helper.getfilterrcds(component,event,helper);
        
    },
    
    handlejobViewSel : function(component, event, helper) {
        var Jobrcdval = component.find('Jobval').get('v.value');
        // alert('val === '+Jobrcdval);
        component.set("v.spinner",true);
        var s = component.get("v.spinner");
        //alert('tasks spinner'+s);
        helper.getfilterrcds(component,event,helper);
    },
    
    handleTaskQuickAction : function(component, event, helper) {
        var selectOption=event.getParam("value");
        var selectTaskId=event.getSource().get("v.name");
        component.set("v.LogTaskId",'');
        component.set('v.isTaskLogTime',false);
        //  alert('---selectTaskId-'+selectTaskId+'---option--'+selectOption);
        switch (selectOption) {
                
            case 'Add_Team':
                component.set("v.fileattach1",false);
                component.set('v.isaddEditStaff',true);
                component.set('v.AddEditStaffTaskId',selectTaskId);
                component.find("AddEditStaffMembers").refreshStaffMembers();
                break;
                
            case 'Task_Edit':
                component.set("v.fileattach1",false);
                component.set("v.EditTaskId",selectTaskId);
                component.set("v.isTaskEdit",true);
                break;
                
            case 'Add_Jobteam':
                component.set("v.fileattach1",false);
                component.set("v.jbteamtskid",selectTaskId);
                component.set('v.isAddEditTeamMembers',true);
                helper.JobTeamAddEditStaff(component,event,helper);
                break;
                
            case 'Task_Delete':
                component.set("v.fileattach1",false);
                helper.deletetask(component,event,helper,selectTaskId);
                break;
                
            case 'Log_Time':
                component.set("v.fileattach1",false);
                component.set("v.LogTaskId",selectTaskId);
                component.set('v.isTaskLogTime',true);  
                break;
                
            case 'Task_Done':
                component.set("v.fileattach1",false);
                helper.TaskDone(component, event, helper,selectTaskId);
                break;
                
            case 'Task_FileAttach':
                component.set("v.fileattach1",true);
                component.set("v.JobTaskIdforApprovals",selectTaskId);
                var FetchFiles = component.get("c.getAttachments");
                FetchFiles.setParams({
                    tkid : selectTaskId
                });
                FetchFiles.setCallback(this, function(Response) {
                    console.log('===FilesState======'+Response.getReturnValue());
                    var FilesState = Response.getState();
                    if (FilesState === "SUCCESS") {
                        var Files=Response.getReturnValue();
                        //alert('files === '+JSON.stringify(Files));
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
                
        }
    },
    
    YesAction : function(component,event,helper) {
        
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
            helper.updateScheduleOnDays(component,event,helper,taskId1,days1,false);
        }
        else if(revdate!=null){
            helper.updateRestSchedule(component, event, helper, taskId1,revdate,false);    
        }
        
    },
    
    YesEditDaysAction : function(component,event,helper) {
        component.set("v.isDaysChanged",true);
        component.get('v.overlayPanel').then(
            function (modal) {
                modal.close();
            }
        );
        
    },
    
    NoEditDaysAction : function(component,event,helper) {
        component.set("v.isDaysChanged",false);
        component.get('v.overlayPanel').then(
            function (modal) {
                modal.close();
            }
        );
        
    },
    
    EditDaysChanged : function(component,event,helper) {
        var Days=event.getParam('value');
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
    
    TaskOnLoad : function(component, event, helper){
        var TaskrecId=component.get("v.EditTaskId");
        console.log('===record Load==='+TaskrecId);
        if(TaskrecId!=null){
            var Taskfields = event.getParam("recordUi");
            component.set("v.isTaskLocked",Taskfields.record.fields.Locked__c.value);
            component.set("v.isLoadedDate",Taskfields.record.fields.Revised_Due_Date__c.value);
            component.set("v.isLoadedDays",Taskfields.record.fields.Days__c.value);
            if(Taskfields.record.fields.GL_Code__c.value!=null ){
                var GLcodeObj={"Id":Taskfields.record.fields.GL_Code__r.value.fields.Id.value, "Name":Taskfields.record.fields.GL_Code__r.value.fields.Name.value};
                component.find("GL_CodeId").sampleMethod(GLcodeObj);
            }
            /*  if(Taskfields.record.fields.Job__c.value!=null){
              var jobrcd = Taskfields.record.fields.Job__c;
                alert(jobrcd["value"]);
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
        helper.TaskEditSucess(component, event, helper,TaskId,UpdateRestDays,UpdateRestDates);
    },
    
    closeTaskModel: function(component, event, helper) {
        component.set("v.EditTaskId",null);
        component.set("v.isTaskEdit",false);
    },
    
    handleFileAttach : function(component, event, helper){
        var FileId = component.find("FileId").get("v.value");
        //alert(FileId);
        var tskId = component.get("v.JobTaskIdforApprovals");
        console.log('>>>>>>>>handleFileAttach tskId>>>>>>>>>',tskId);
        console.log('>>>>>>>>FileId>>>>>>>>>',FileId);
        if(FileId!='')
        {
            component.set("v.fileattach1",false);
            if(component.get("v.JobDetailAccessible[7]")){
                helper.handleFileAttachPro(component, event, helper, tskId);
            }else{
                component.set("v.fileattach1",true);
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
    
    
    closeHandleFileAttach: function(component, event, helper){
        component.set("v.fileattach1",false);
    },
    
    closeApprovalTaskFile : function(component, event, helper){
        component.set("v.JobTaskIdforApprovals",null);
        component.set("v.fileattach1",false);
        
    },
    
})