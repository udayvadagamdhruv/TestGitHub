({
    
    doInit: function(component, event, helper) {
        
        helper.fetchCustomSettingdata(component, event, helper);// fetch custom setting data and Object Accessibility.
        helper.fetchFieldLabels(component,event,helper);  
        
        var JobCostAccess = component.get("c.getisAccessable");
        JobCostAccess.setCallback(this, function(JobCostresponse) {
            if (JobCostresponse.getState() === "SUCCESS") {
                console.log('Job Cost Accessable'+JobCostresponse.getReturnValue());
                component.set("v.JobDetailAccessible",JobCostresponse.getReturnValue());
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
        
       /* var helpTextRec= component.get("c.getHelpTextrecordsAppro"); 
        helpTextRec.setCallback(this, function(helpTextResponse){
            if (helpTextResponse.getState() === "SUCCESS") {
                console.log('=Help Text Values=='+JSON.stringify(helpTextResponse.getReturnValue()));
                component.set("v.helpText",helpTextResponse.getReturnValue());
                
                
            }
        }); 
        $A.enqueueAction(helpTextRec); */
        
    },


    /***********Delete All Approval Schedule > popup opens and choose related File ***************/

    handleDeleteApprovalSchedule : function(component, event, helper){
        component.set("v.isDeleteApprovalTask",true);
        
        helper.JobApprovalTskFetch(component, event);
       // helper.JobFilesfetch(component, event);
        
        
    },

    /********************** This Method is used for close the Delete schedule screen *******************************/
    closeDelApprovalTaskFile : function(component, event, helper){
        component.set("v.isDeleteApprovalTask",false);
    },


    /************ After selecting the File and Template from the first screen then click on create button All Approval task will be imported from the selected template *******************************/
    
    handleDeleteSchedule : function(component, event, helper){
        
        var FileId = component.find("DelFileId").get("v.value");
        console.log('>>>>>>>>FileId>>>>>>>>>',FileId);
        
        if(FileId!='')
        {
            component.set("v.isDeleteApprovalTask",false);
            component.set("v.ShowScheduleBtn",true);
            if(component.get("v.JobDetailAccessible[0]")){
                 helper.DeleteAllApprovalSchedule(component, event, helper, FileId); 
            }else{
                component.set("v.isApprovalTaskFile",true);
                component.set("v.ShowScheduleBtn",false);
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Error, Approval Process has insufficient access to Delete'
                }); 
            }

        }
        else{
            component.set("v.ShowScheduleBtn",false);
            helper.showToast({
                "title": "Error!!",
                "type": "error",
                "message": 'Error, You must select a file.'
            }); 
        }

        
    },

    
    /***********Create Approval Schedule First Screen > popup opens and choose Job related File and Approval Sched Template***************/
   
    handlecreateApprovalSchedule : function(component, event, helper){
        component.set("v.isApprovalTaskFile",true);
        
        helper.JobFilesfetch(component, event);
        
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
    },
    
    /********************** This Method is used for close the create schedule first screen *******************************/
    closeApprovalTaskFile : function(component, event, helper){
        component.set("v.isApprovalTaskFile",false);
    },
    
    /************ After selecting the File and Template from the first screen then click on create button All Approval task will be imported from the selected template *******************************/
    
    handlecreateSchedule : function(component, event, helper){
        
        
        var FileId = component.find("FileId").get("v.value");
        var AppSchedTempId = component.find("APPSchTempId").get("v.value");
        console.log('>>>>>>>>FileId>>>>>>>>>',FileId);
        console.log('>>>>>>>>AppSchedTempId>>>>>>>>>',AppSchedTempId);
        
        if(FileId!='' && AppSchedTempId!='')
        {
            component.set("v.isApprovalTaskFile",false);
            component.set("v.ShowScheduleBtn",true);
            if(component.get("v.JobDetailAccessible[1]")){
                 helper.createSchedule(component, event, helper); 
                
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
                component.set("v.isApprovalTaskFile",true);
                component.set("v.ShowScheduleBtn",false);
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
    
  /***************************************** Start Approval Task Edit *************************************************/  
   
    TaskOnLoad : function(component, event, helper){
        var TaskrecId=component.get("v.EditTaskId");
        console.log('===record Load==='+TaskrecId);
        if(TaskrecId!=null){
            var Taskfields = event.getParam("recordUi");
            component.set("v.isLoadedDate",Taskfields.record.fields.Revised_Due_Date__c.value);
            component.set("v.TaskStatus",Taskfields.record.fields.Status__c.value);
        }
        
    },
    
    TaskOnsubmit : function(component, event, helper){
        
        event.preventDefault(); // Prevent default submit
        var fields = event.getParam("fields");
        console.log('===fields=='+JSON.stringify(fields));
        
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
            /*else if(inputCmp.get("v.fieldName") == "Status__c"){
                var status =inputCmp.get("v.value");
                if(status==null || status==''){
                    StausField="Status";
                }
                
            }*/
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
       /* var ToastMsg1=$A.get("e.force:showToast");
        ToastMsg1.setParams({
            "title":StausField,
            "type": "error",
            "message": StausField+" Field is required."
            
        });*/
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
       /* else if(StausField=="Status"){
            ToastMsg1.fire();
            event.preventDefault();
        }*/
            else if(DueDateField=="Due Date"){
                ToastMsg2.fire();
                event.preventDefault();
            }
                else{
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
    
  /***************************************** End Approval Task Edit *************************************************/  
    
    
   /***************************************** Start Above Insert Approval Task *************************************************/  
     
    
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
            console.log('=======Else AboveResponse=====');
           
            var Aboveaction=component.get("c.ApproveInsertAboveLoad");
            
            Aboveaction.setParams({
                taskid : component.get("v.AboveTaskRecordId"),
                days :fields["Days__c"],
                RolesList: RoleString
            });
            
            Aboveaction.setCallback(this, function(AboveResponse){
                console.log('=======Else AboveResponse====='+AboveResponse.getState());
                if (AboveResponse.getState() === "SUCCESS") {
                    var rows=AboveResponse.getReturnValue();
                    console.log('=======AboveResponse====='+JSON.stringify(rows));
                    fields["Task_Order__c"]=rows[0];
                    fields["Start_Date__c"]=rows[1];
                    fields["Due_Date__c"]=rows[2];
                    fields["Revised_Due_Date__c"]=rows[2];
                    fields["Schedule_Roles__c"]=rows[3]; 
                    fields["File_Name__c"]=rows[4];
                    fields["File_ID__c"]=rows[5];
                    console.log('===fields last=='+JSON.stringify(fields));
                    component.find("TaskAboveEditForm").submit(fields);
                }
                else{
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": AboveResponse.getReturnValue()
                    });  
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
    
     closeAboveTaskModel: function(component, event, helper) {
        component.set("v.isAboveInsert",false);
    },
    
  /***************************************** End Above Insert Approval Task *************************************************/  
      
    
  /***************************************** Start Below Insert Approval Task *************************************************/  
     
    insertatEnd : function(component, event, helper) {
        if(component.get("v.JobDetailAccessible[1]")){
            helper.JobFilesfetch(component, event);
            component.set("v.isBelowInsert",true);
        }
        else{
            helper.showToast({
                "title":"Error!!",
                "type": "error",
                "message": 'Approval Task has insufficient access to create'
            }); 
        }
    },
    
                               
    TaskBelowOnsubmit : function(component, event, helper){
        event.preventDefault(); // Prevent default submit
        var RoleStringBelow='';
        var x=document.getElementById("RolesListBelow");
        for (var i = 0; i < x.options.length; i++) {
            if(x.options[i].selected ==true){
                if(x.options[i].value!=''){
                    RoleStringBelow+=x.options[i].value+';'
                }
            }
        }
        
        if (RoleStringBelow.endsWith(";")) {
            RoleStringBelow = RoleStringBelow.substring(0, RoleStringBelow.length - 1);
        }
        
        console.log('======RoleString=='+RoleStringBelow);
        
        var fields = event.getParam("fields");
        fields["Job__c"]=component.get("v.recordId");
        console.log('===fields=='+JSON.stringify(fields));
       
        var NameField="";
        var BFileName=component.find("BFileId").get("v.value");

        
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
        else if(BFileName=='' || BFileName == null)
        {
            var ToastMsg1=$A.get("e.force:showToast");
            ToastMsg1.setParams({
                "title":'File',
                "type": "error",
                "message": "Please select the File."
                
            });
            ToastMsg1.fire();
            //event.preventDefault();
        }
        else{
            
            var BFileId = component.find("BFileId").get("v.value");
            console.log('>>> File Id',BFileId);
            var Belowaction=component.get("c.ApproveInsertBelowLoad");
            
            Belowaction.setParams({
                jobid : component.get("v.recordId"),
                days :fields["Days__c"],
                RolesList: RoleStringBelow,
                FileId:BFileId
                
            });
            
            Belowaction.setCallback(this, function(belowResponse){
                console.log('>>>>belowResponse>>>>'+belowResponse.getState());
                console.log('>>>>belowResponse vall>>>>'+belowResponse.getReturnValue());
                if (belowResponse.getState() === "SUCCESS") {
                    
                    var rows=belowResponse.getReturnValue();
                    if(rows[0]=="No Records"){
                        helper.showToast({
                            "title": "Error!!",
                            "type": "error",
                            "message": 'There is no Approval Process for the selected file.'
                        });    
                    }
                    else{
                        console.log('=======BelowAction Load===='+JSON.stringify(rows));
                        fields["File_ID__c"]=component.find("BFileId").get("v.value");
                        fields["Task_Order__c"]=rows[0];
                        fields["Start_Date__c"]=rows[1];
                        fields["Due_Date__c"]=rows[2];
                        fields["Revised_Due_Date__c"]=rows[2];
                        fields["Schedule_Roles__c"]=rows[3];  
                        //fields["File_Name__c"]=component.get("v.isBelowInsertFileId");
                        fields["File_Name__c"]=rows[4];   
                        fields["Status__c"]=rows[5];
                        fields["Submitter_Name__c"]=rows[6];   
                        fields["Submitter_Email__c"]=rows[7];
                        fields["Submitted_Date__c"]=rows[8];   
                        fields["Number_of_Submissions__c"]=rows[9];
                        fields["Undo__c"]=rows[10];
                        
                        console.log('===TaskBelowEditForm fields last=='+JSON.stringify(fields));
                        component.find("TaskBelowEditForm").submit(fields);
                    }
                    
                }
            }); 
            
            $A.enqueueAction(Belowaction); 
            
        }
        
    },
    
    TaskBelowOnSuccess : function(component, event, helper){
        console.log('===Insert below response====='+JSON.stringify(event.getParams().response.fields));
       // console.log('===Json below Start Date above response====='+JSON.stringify(event.getParams().response.fields.Start_Date__c.value));
      //  console.log('===Json below Task Order above response====='+JSON.stringify(event.getParams().response.fields.Task_Order__c.value));
        var Taskid=event.getParams().response.id;
       // console.log('>>>>>>Taskid>>>>>>'+Taskid);
        var strid=component.get("v.recordId");
       // console.log('>>>>strid>>>>>>>>'+strid);
        var TaskOrder=event.getParams().response.fields.Task_Order__c.value;
      //  console.log('>>>>TaskOrder>>>>>>>>'+TaskOrder);
        
        var BFileName=event.getParams().response.fields.File_Name__c.value;
       // console.log('>>>>BFileName>>>>>>>>'+BFileName);
        var BFileId=event.getParams().response.fields.File_ID__c.value;
      //  console.log('>>>>BFileId>>>>>>>>'+BFileId);
        var StartDate=event.getParams().response.fields.Start_Date__c.value; 
      //  console.log('>>>>StartDate>>>>>>>>'+StartDate);
        var tskStatus=event.getParams().response.fields.Status__c.value;

        helper.InsertBlowSucess(component, event,helper,Taskid,strid,TaskOrder,StartDate,BFileName,BFileId,tskStatus); 
    },
    
    closeBelowTaskModel: function(component, event, helper) {
        component.set("v.isBelowInsert",false);
    },
    
  /***************************************** End Below Insert Approval Task *************************************************/  
    
    
    handleRowSelection:function(component, event, helper) {
        var selRows=event.getParam('selectedRows');
        var taskIdList=[];
        for(var i=0;i<selRows.length;i++){
            taskIdList.push(selRows[i].Id);
        }
        component.set("v.selectedTasksforMarkDone",taskIdList);
        //console.log('====selected Rows='+JSON.stringify(selRows));
        //console.log('====setvalues Rows='+JSON.stringify(component.get("v.selectedTasksforMarkDone")));
        // helper.MarkAllSelectedTasks(selRows);
    },
    
    
    refreshJobTasks :function(component, event, helper) {
        helper.JobTasksfetch(component, event);
    },
    
    
    // ******************************************************** Doinit Close ****************************************************** 
    
    updateColumnSorting: function(cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
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
    
    
    handleTaskRowActions: function(component, event, helper) {
        // DeleteTask  ActiveTask CompleteTask tskid
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
           
            case 'Submit_Action':
                if(component.get("v.JobDetailAccessible[2]")){
                    helper.SubmitAction(component, event, helper);
                   }
                else{
                    helper.showToast({
                        "title":"Error!!",
                        "type": "error",
                        "message": 'Task has insufficient access to edit/update'
                    });  
                }
                
                break;
                
            case 'reSubmit_Action':
                if(component.get("v.JobDetailAccessible[2]")){
                    helper.ReSubmitAction(component, event, helper);
                   }
                else{
                    helper.showToast({
                        "title":"Error!!",
                        "type": "error",
                        "message": 'Task has insufficient access to edit/update'
                    });  
                }
                
                break;    

            case 'Undo':
                if(component.get("v.JobDetailAccessible[2]")){
                    helper.undoHelper(component, event, helper);
                    }
                else{
                    helper.showToast({
                        "title":"Error!!",
                        "type": "error",
                        "message": 'Task has insufficient access to edit/update'
                    });  
                }
                
            break;  
                
            case 'Task_LogTime':
                if(component.get("v.JobDetailAccessible[2]")){
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
                if(component.get("v.JobDetailAccessible[2]")){
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


                case 'Task_AddEdit':
                    if(component.get("v.JobDetailAccessible[4]")){
                        component.set("v.AddEditStaffTaskId",row.Id);
                        component.set("v.isaddEditStaff",true);
                        component.find("AddEditStaffMembers").refreshStaffMembers();}
                    else{
                        helper.showToast({
                            "title":"Error!!",
                            "type": "error",
                            "message": 'Task role has insufficient access to edit/update'
                        }); 
                    }
                    break;

                    case 'Task_Delete':
                        helper.DeleteTask(component, event, helper);
                        break;   
                
            case 'Task_Above':
                if(component.get("v.JobDetailAccessible[1]")){
                    component.set("v.AboveTaskRecordId",row.Id);
                    component.set("v.isAboveInsert",true);}
                else{
                    helper.showToast({
                        "title":"Error!!",
                        "type": "error",
                        "message": 'Approval Task has insufficient access to create'
                    });   
                }
                break;
               
        }
    },
    
        
})