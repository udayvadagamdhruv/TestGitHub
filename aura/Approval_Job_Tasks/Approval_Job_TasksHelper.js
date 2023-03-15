({
    fetchCustomSettingdata :function(component, event , helper){
        
       // var Csetting=component.get("c.CustomSettingvalues");
       // var CreateSsetting=component.get("c.CreateScheduleSetting");
        var DateAction=component.get("c.todaySystemDate");
        var RolesAction= component.get("c.getRolesAppro"); 
        //var JobCostAccess = component.get("c.getisAccessable");
        
       /* Csetting.setCallback(this, function(CustomResponse){
            if (CustomResponse.getState() === "SUCCESS") {
                console.log('=custom settings=='+JSON.stringify(CustomResponse.getReturnValue()));
                component.set("v.CST",CustomResponse.getReturnValue());
                
                console.log('=Update Staff=='+component.get("v.CST[0].Update_Staff__c"));
            }
        });  
        
        CreateSsetting.setCallback(this, function(CRSresponse){
            if (CRSresponse.getState() === "SUCCESS") {
                console.log('=Create Scule settings=='+CRSresponse.getReturnValue());
                component.set("v.isHD",CRSresponse.getReturnValue());  
            }
        }); */
        
        DateAction.setCallback(this, function(Dtresponse){
            if (Dtresponse.getState() === "SUCCESS") {
                console.log('=Date Action=='+Dtresponse.getReturnValue());
                component.set("v.todayDate",Dtresponse.getReturnValue());  
            }
        }); 
        
        RolesAction.setCallback(this, function(Roleresponse){
            if (Roleresponse.getState() === "SUCCESS") {
                console.log('=Roles list=='+Roleresponse.getReturnValue());
                component.set("v.RolesList",Roleresponse.getReturnValue());  
            }
        }); 
        
       
        
       // $A.enqueueAction(Csetting); 
      //  $A.enqueueAction(CreateSsetting);
        $A.enqueueAction(DateAction); 
        $A.enqueueAction(RolesAction); 
    
    },
    
    fetchFieldLabels : function(component, event , helper){
        var rowActions = helper.getRowActions.bind(this, component);
        
        var action=component.get("c.getObjectLabels");
        action.setParams({
            ObjNames:['Approval_Job_Task__c','Job__c']
        });
        
        action.setCallback(this, function(res){
            if(res.getState()=== "SUCCESS"){
                var tableHeaders=JSON.parse(res.getReturnValue());
                console.log('===Job Team and Task and Specs Lables====='+JSON.stringify(JSON.parse(res.getReturnValue())));
                component.set("v.ObjectType",JSON.parse(res.getReturnValue()));
                
                var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
                console.log('===isMobile====='+isMobile);
                
                var PEValue=component.get("v.CST[0].Active__c");
                console.log('===PEValue====='+PEValue);
                
                
                component.set('v.taskcolumns', [
                    { type: 'action', typeAttributes: { rowActions: rowActions }} ,
                    {label: 'Order', fieldName: 'Task_Order__c', type: 'text',initialWidth:90 ,cellAttributes: { alignment: 'right' }},
                    {label: tableHeaders.Approval_Job_Task__c.Name.label, fieldName: 'TaskLink', type: 'url',initialWidth:250, typeAttributes: { label: { fieldName: 'Name' }, target: '_blank', tooltip:{ fieldName: 'Name' } } },
                    {label: tableHeaders.Approval_Job_Task__c.Assigned_Users__c.label, fieldName: 'Staff', type: 'text',initialWidth:325},     
                    {label: tableHeaders.Approval_Job_Task__c.Days__c.label, fieldName: 'Days__c', type: 'number',initialWidth:80, cellAttributes: {alignment: 'left', class: { fieldName: '' } }},
                    {label: 'Due Date', fieldName: 'Revised_Due_Date__c', type: 'date-local',initialWidth:175,cellAttributes: { class: { fieldName: '' } ,iconName: 'utility:event', iconAlternativeText: 'Final Due Date' }},
                    {label: tableHeaders.Approval_Job_Task__c.Status__c.label, fieldName: 'Status__c', type: 'text',initialWidth:130},
                    {label: tableHeaders.Approval_Job_Task__c.Approver_By__c.label, fieldName: 'Approver_By__c', type: 'text',initialWidth:155},
                    {label: tableHeaders.Approval_Job_Task__c.Approved_Date__c.label, fieldName: 'Approved_Date__c',  type: 'date-local',initialWidth:175,cellAttributes: { class: { fieldName: '' } ,iconName: 'utility:event', iconAlternativeText: 'Approved Date' }}
                ]);
                var labels = {'Staff':  tableHeaders.Approval_Job_Task__c.Assigned_Users__c.label,
                                'DueDate':tableHeaders.Approval_Job_Task__c.Revised_Due_Date__c.label
                                // 'MarkedDone':tableHeaders.Job_Task__c.Marked_Done__c.label,
                                // 'CompletionDate':tableHeaders.Job_Task__c.Completion_Date__c.label
                                };
                component.set('v.DynamicLabels',labels);
                console.log('-----labels--'+JSON.stringify(labels));
                
            }
        });
        $A.enqueueAction(action);
    },
    
    
    JobTasksfetch : function(component,event) {
        console.log('>>>>>>>>JobTasksfetch>>>>>>>>>>');
            var TaskAction= component.get("c.getListofAprJobTasks");
            TaskAction.setParams({
                jobId : component.get("v.recordId")
            });
                    
            TaskAction.setCallback(this, function(response){ 
                var result= response.getReturnValue();            
                var ApproveTskList = [];         
               // var  fileContainsID=[];               
                if (response.getState() === "SUCCESS") {
                    
                    var rows=response.getReturnValue();
                    console.log('>>>>>>>rows rows>>>>>>>>>>>>>>',rows);
                    for (var key in result) {
                        var rows=result[key];
                        for(var i=0;i<rows.length;i++){
                            var row=rows[i];
                            
                            if(row.Approval_Job_Task_Roles__r!=null){
                                row.Staff= Array.prototype.map.call(row.Approval_Job_Task_Roles__r, function(item) { return item.User__c; }).join(", ");
                            }
                            else{
                                row.Staff=''; 
                            }
                           
                            row.TaskLink = '/'+row.Id;
                           /* if(fileContainsID.includes(row.File_ID__c)){
                            }
                            else{
                                fileContainsID.push(row.File_ID__c);         
                            }*/
                            //fileContainsID.push(row.File_ID__c);
                        }
                        ApproveTskList.push({FileId:key,value:rows});
                        //TablejSpecTmpList.push(rows);
                    }
                    
                   // component.set("v.fileIdContains",fileContainsID);
                    component.set("v.taskdata",ApproveTskList);
                }  
            }); 
    
            var jobFileIdAction= component.get("c.getJobFileIds");
            jobFileIdAction.setParams({
                recordId : component.get("v.recordId")
            });
                    
            jobFileIdAction.setCallback(this, function(response){ 
                var result= response.getReturnValue();  
                console.log('>>>>>>>>jobFileId>>>>>>>>>>',response.getState());          
                if(response.getState() === "SUCCESS") {
                    component.set("v.jobFileId",result);
                    console.log('>>>>>>>>jobFileId>>>>>>>>>>',result);
                }  
            }); 
    
            
            $A.enqueueAction(TaskAction);  
            $A.enqueueAction(jobFileIdAction);  
        },
                            
        JobFilesfetch : function(component,event) { 
            
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
        },
    
        JobApprovalTskFetch : function(component,event) { 
            
            var recId = component.get("v.recordId");
            var FetchFiles = component.get("c.getApprovalFiles");
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
                    component.set("v.JobApprovalFileList",FileList);
                    
                }
            });
            $A.enqueueAction(FetchFiles);
        },
    
        
                    
    getRowActions: function (component, row, doneCallback) {
        var CST=component.get("v.CST");
        console.log('===Json Row======'+JSON.stringify(row));
        var actions = [];
    
        var SubmitAction = {
            'label': 'Submit',
            'iconName': 'action:submit_for_approval',
            'name': 'Submit_Action',
            'disabled':(row.Task_Order__c!='1' || row.Status__c!='Pending')
        };
    
        var reSubmitAction = {
            'label': 'Re-Submit',
            'iconName': 'action:submit_for_approval',
            'name': 'reSubmit_Action',
            'disabled':(row.Status__c=='Approved' ||  row.Status__c=='Pending' ||  row.Status__c=='In Progress')
        };
    
        var undoAction = {
            'label': 'Undo',
            'iconName': 'action:recall',
            'name': 'Undo',
            'disabled':(row.Status__c=='Approved' || row.Status__c=='Pending' || row.Status__c=='Changes Needed'  || ( row.Status__c=='In Progress' && row.Number_of_Submissions__c=='1' && row.Task_Order__c!='1'))
        };
        
        var LogTimeAction = {
            'label': 'Log Time',
            'iconName': 'action:defer',
            'name': 'Task_LogTime',
            'disabled':(row.Job__r.Status__c!='Active')
        };
        
        var AddEditAction = {
            'label': 'Add/Edit Staff',
            'iconName': 'action:edit_groups',
            'name': 'Task_AddEdit',
            'disabled':(row.Status__c=='In Progress' || row.Status__c=='Approved')
        };
        
        var EditAction = {
            'label': 'Edit',
            'iconName': 'utility:edit',
            'name': 'Task_Edit',
            'disabled':(row.Status__c=='In Progress' || row.Status__c=='Approved')
        };
        
        var InsertAction = {
            'label': 'Insert Above',
            'iconName': 'utility:arrowup',
            'name': 'Task_Above',
            'disabled':(row.Status__c=='In Progress' || row.Status__c=='Approved' || row.Status__c=='Changes Needed')
        }; 
            
        var DeleteAction = {
            'label': 'Delete',
            'iconName': 'utility:delete',
            'name': 'Task_Delete',
            'disabled':(row.Status__c=='In Progress' || row.Status__c=='Approved' || row.Status__c=='Changes Needed')
        };
        
        // actions.push(TaskDoneAction,TaskOpenAction,AddEditAction,EditAction,DeleteAction,InsertAction,LogTimeAction);
        actions.push(SubmitAction,reSubmitAction,undoAction,EditAction,DeleteAction,InsertAction,AddEditAction);
        
        // simulate a trip to the server
        setTimeout($A.getCallback(function (){
            doneCallback(actions);
        }), 200);
    },
    
    
    DeleteAllApprovalSchedule : function(component, event, helper, FileId){
        var DeleteSchdule = component.get("c.DeleteFileApprovalTask");
        DeleteSchdule.setParams({
            jobId:component.get("v.recordId"),
            TaskFileId:FileId
        });
        DeleteSchdule.setCallback(this, function(DelResponse) {
            console.log('===DelResponse======'+DelResponse.getReturnValue());
            var DelState = DelResponse.getState();
            if (DelState === "SUCCESS") {
                if(DelResponse.getReturnValue()=="OK"){
                    helper.JobTasksfetch(component,event);
                    helper.showToast({
                        "type": "success",
                        "message": "Successfully Deleted Approval process."
                    });
                    
                    var appEvent=$A.get("e.JobSuite:UpdateRecordsforChanges");
                    if(appEvent){
                        appEvent.fire();  
                    }
                        component.set("v.ShowScheduleBtn",false);
                }
                else if(DelResponse.getReturnValue()=="No Records"){
                  //  helper.JobTasksfetch(component,event);
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": 'No Records to be deleted.'
                    });  
                        component.set("v.ShowScheduleBtn",false);
                }
                else if(DelResponse.getReturnValue()=="Task Status pending"){
                    //  helper.JobTasksfetch(component,event);
                      helper.showToast({
                          "title": "Error!!",
                          "type": "error",
                          "message": 'you cannot delete Approval process because of a task has either Approved or Inprogress or changes Needed.'
                      });  
                          component.set("v.ShowScheduleBtn",false);
                  }
                
                else{
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": DelResponse.getReturnValue()
                    });  
                        component.set("v.ShowScheduleBtn",false);
                }
            }
            
            else{
                component.set("v.ShowScheduleBtn",false);
                console.log('>>>>>> Error >>>>>>>>>>',DelResponse.getError());
                var errors = DelResponse.getError();
                var toastEvent = $A.get("e.force:showToast");
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message":errors[0].message
                    });       
                    component.set("v.ShowScheduleBtn",false);
            }
            
        });
        $A.enqueueAction(DeleteSchdule);
    },
    
    createSchedule: function(component, event, helper){
        
        var FileId = component.find("FileId").get("v.value");
        var AppSchedTempId = component.find("APPSchTempId").get("v.value");
        //alert("FileId "+FileId+ " AppSchedTempId: "+AppSchedTempId);
        var CreateSchdule = component.get("c.createApprovalTask");
        CreateSchdule.setParams({
            jobId:component.get("v.recordId"),
            TaskFileId:FileId,
            AppSchedTemp:AppSchedTempId
        });
        CreateSchdule.setCallback(this, function(CRSResponse) {
            console.log('===CRSResponse======'+CRSResponse.getReturnValue());
            var CRSState = CRSResponse.getState();
            if (CRSState === "SUCCESS") {
                if(CRSResponse.getReturnValue()=="OK"){
                    helper.JobTasksfetch(component,event);
                    helper.showToast({
                        "type": "success",
                        "message": "Successfully Created Task Records."
                    });
                    
                    var appEvent=$A.get("e.JobSuite:UpdateRecordsforChanges");
                    if(appEvent){
                        appEvent.fire();  
                    }
                        component.set("v.ShowScheduleBtn",false);
                }
                
                else{
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": CRSResponse.getReturnValue()
                    });  
                        component.set("v.ShowScheduleBtn",false);
                }
                
                
            }
            
            else{
                component.set("v.ShowScheduleBtn",false);
                console.log('>>>>>> Error >>>>>>>>>>',CRSResponse.getError());
                var errors = CRSResponse.getError();
                var toastEvent = $A.get("e.force:showToast");
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message":errors[0].message
                    });       
                    component.set("v.ShowScheduleBtn",false);
            }
        });
        $A.enqueueAction(CreateSchdule);
    },
    
    
    TaskEditSucess :function(component,event, helper,TaskId,UpdateRestDays,UpdateRestDates){
        var TaskSuccessAction=component.get("c.ApprTaskEditSuccess");
        TaskSuccessAction.setParams({
            TaskId : TaskId,
            UpdateRestDays : UpdateRestDays,
            UpdateRestDates :UpdateRestDates
        });
        
        TaskSuccessAction.setCallback(this, function(response){ 
            console.log('=====State of Tas===='+response.getState());
            if (response.getState() === "SUCCESS") {
                if(response.getReturnValue()=="OK"){
                    helper.JobTasksfetch(component,event);
                    
                    //helper.reloadDataTable();
                    component.set("v.isTaskEdit",false);
                    component.set("v.EditTaskId",null);
                    component.set("v.isDaysChanged",false);
                    component.set("v.isDueDateChanged",false);
                    helper.showToast({
                        "type": "success",
                        "message": "Successfully Updated the Approval."
                    });
                    
                    var isListView=component.get("v.isListview");
                    if(!isListView){
                            this.fetchCalenderEvents(component,event, helper);
                    }
                    var appEvent=$A.get("e.JobSuite:UpdateRecordsforChanges");
                    if(appEvent){
                        appEvent.fire();  
                    }
                    
                }
                else{
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": response.getReturnValue()
                    });  
                }
                
            }  
        }); 
        $A.enqueueAction(TaskSuccessAction); 
        
    },
    
    undoHelper : function(component, event, helper){
        var row = event.getParam('row');
        console.log('>>>>undoAct Row Id>>>>'+row.Id);
        var undoAct=component.get("c.UndoApproveTask");
        undoAct.setParams({
            tskid : row.Id
        });
    
        undoAct.setCallback(this, function(response){ 
            if (response.getState() === "SUCCESS") {
                if(response.getReturnValue()=="OK"){
                    helper.JobTasksfetch(component,event);
                    helper.showToast({
                        "type": "success",
                        "message": "The Status of the Task is changed to Pending."
                    });
                    
                    var appEvent=$A.get("e.JobSuite:UpdateRecordsforChanges");
                    if(appEvent){
                        appEvent.fire();  
                    }
                    
                }
                else{
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": response.getReturnValue()
                    });  
                }
                
            }  
        }); 
        $A.enqueueAction(undoAct); 
    },
    
    SubmitAction : function(component, event, helper){
        var row = event.getParam('row');
        console.log('>>>>SubmitAction Row Id>>>>'+row.Id);
        var SubmitAct=component.get("c.SubmitApproveTask");
        SubmitAct.setParams({
            tskid : row.Id
        });
    
        SubmitAct.setCallback(this, function(response){ 
            if (response.getState() === "SUCCESS") {
                if(response.getReturnValue()=="OK"){
                    helper.JobTasksfetch(component,event);
                    helper.showToast({
                        "type": "success",
                        "message": "Successfully Submitted to the Approval process."
                    });
                    
                    var appEvent=$A.get("e.JobSuite:UpdateRecordsforChanges");
                    if(appEvent){
                        appEvent.fire();  
                    }
                    
                }
                else{
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": response.getReturnValue()
                    });  
                }
                
            }  
        }); 
        $A.enqueueAction(SubmitAct); 
    },
    
    ReSubmitAction : function(component, event, helper){
        var row = event.getParam('row');
        console.log('>>>>SubmitAction Row Id>>>>'+row.Id);
        var SubmitAct=component.get("c.ReSubmitApproveTask");
        SubmitAct.setParams({
            tskid : row.Id
        });
    
        SubmitAct.setCallback(this, function(response){ 
            if (response.getState() === "SUCCESS") {
                if(response.getReturnValue()=="OK"){
                    helper.JobTasksfetch(component,event);
                    helper.showToast({
                        "type": "success",
                        "message": "Successfully Re-Submitted to the Approval process."
                    });
                    
                    var appEvent=$A.get("e.JobSuite:UpdateRecordsforChanges");
                    if(appEvent){
                        appEvent.fire();  
                    }
                    
                }
                else{
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": response.getReturnValue()
                    });  
                }
                
            }  
        }); 
        $A.enqueueAction(SubmitAct); 
    },
    
    DeleteTask :function(component, event, helper,selectTaskId){
        var delTask=component.get("c.DeleteApproveTask");      
        if(selectTaskId!=null || selectTaskId!=undefined){
            delTask.setParams({
                tskid : selectTaskId
            });
        }
        else{
            var row = event.getParam('row');
            delTask.setParams({
                tskid : row.Id
            });
        }
        delTask.setCallback(this, function(response){ 
            if (response.getState() === "SUCCESS") {
                if(response.getReturnValue()=="OK"){
                    helper.JobTasksfetch(component,event);
                    helper.showToast({
                        "type": "success",
                        "message": "Successfully Deleted the Approval."
                    });
                    
                    var appEvent=$A.get("e.JobSuite:UpdateRecordsforChanges");
                    if(appEvent){
                        appEvent.fire();  
                    }
                    
                }
                else{
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": response.getReturnValue()
                    });  
                }
                
            }  
        }); 
        $A.enqueueAction(delTask); 
    },
        
    EditTaskDaysChanged :function(component, event, helper) {
        
        var modalBody;
        var modalFooter; 
        $A.createComponents([
            ["lightning:button",
                {
                    "aura:id": "NoEditDaysId",
                    "label": "No",
                    "onclick":component.getReference("c.NoEditDaysAction") 
                }],
            ["lightning:button",
                {
                    "aura:id": "YesEditDaysId",
                    "variant" :"brand",
                    "label": "Yes",
                    "onclick": component.getReference("c.YesEditDaysAction") 
                }]
        ],
            function(content, status, errorMessage){
                if (status === "SUCCESS") {
                    modalBody = 'Do you want to update rest of the Approvals?';
                    modalFooter=content;
                    var OverLayPanel=component.find('overlayLib1').showCustomModal({
                        header: "Approval Update",
                        body: modalBody,
                        footer: modalFooter,
                        showCloseButton: true,
                        cssClass: "mymodal EditTaskClass",
                        closeCallback: function() {
                            //component.find("TaskTable").set("v.draftValues", null);
                        }
                    });
                    
                    component.set('v.overlayPanel', OverLayPanel);
                } 
                else if (status === "ERROR") {
                    console.log("Error: " + errorMessage);
                }
                
            }
        );
        
    },
    
    
    EditTaskDateChanged :function(component, event, helper) {
        
        var modalBody;
        var modalFooter; 
        $A.createComponents([
            ["lightning:button",
                {
                    "aura:id": "NoEditDateId",
                    "label": "No",
                    "onclick":component.getReference("c.NoEditDateAction") 
                }],
            ["lightning:button",
                {
                    "aura:id": "YesEditDateId",
                    "variant" :"brand",
                    "label": "Yes",
                    "onclick": component.getReference("c.YesEditDateAction") 
                }]
        ],
            function(content, status, errorMessage){
                if (status === "SUCCESS") {
                    modalBody = 'Do you want to update rest of the Approvals?';
                    modalFooter=content;
                    var OverLayPanel=component.find('overlayLib1').showCustomModal({
                        header: "Approval Update",
                        body: modalBody,
                        footer: modalFooter,
                        showCloseButton: true,
                        cssClass: "mymodal EditTaskClass",
                        closeCallback: function() {
                            //component.find("TaskTable").set("v.draftValues", null);
                        }
                    });
                    component.set('v.overlayPanel', OverLayPanel);
                } 
                else if (status === "ERROR") {
                    console.log("Error: " + errorMessage);
                }
                
            }
        );
        
    },
    
    
    InsertAboveSucess : function(component,event,helper,Oldtaskid,NewTaskId,strid){
        // helper.InsertAboveSucess(component, event,helper,Oldtaskid,NewTaskId,strid); 
        var SucessAbove = component.get("c.ApproveInsertAboveSucess");
        SucessAbove.setParams({
            Oldtaskid:Oldtaskid,
            NewTaskId : NewTaskId,
            strid:strid
        });
        SucessAbove.setCallback(this, function(SAboveResponse) {
            console.log('===SAboveResponse======'+SAboveResponse.getReturnValue());
            var SbState = SAboveResponse.getState();
            if (SbState === "SUCCESS") {
                if(SAboveResponse.getReturnValue()=="OK"){
                    helper.JobTasksfetch(component,event);
                    component.set("v.isAboveInsert",false);
                    component.set("v.AboveTaskRecordId",null);
                    helper.showToast({
                        "type": "success",
                        "message": 'Successfully Inserted the Task.'
                    });
                    
                    var appEvent=$A.get("e.JobSuite:UpdateRecordsforChanges");
                    if(appEvent){
                        appEvent.fire();  
                    }
                } 
                else{
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": SAboveResponse.getReturnValue()
                    });  
                }
            }
        });
        $A.enqueueAction(SucessAbove);
        
    },
    
    
    InsertBlowSucess : function(component,event,helper,Taskid,strid,TaskOrder,StartDate,BFileName,BFileId,tskStatus){
        var SucessBelow = component.get("c.ApproveInsertBlowSucess");
        SucessBelow.setParams({
            Taskid : Taskid,
            strid : strid,
            task_order_no: TaskOrder,
            d6 : StartDate,
            FileName : BFileName,
            FileId : BFileId,
            tskSts:tskStatus
        });
        SucessBelow.setCallback(this, function(SbelowResponse) {
            console.log('===SbelowState======'+SbelowResponse.getReturnValue());
            var SbelowState = SbelowResponse.getState();
            if (SbelowState === "SUCCESS") {
                if(SbelowResponse.getReturnValue()=="OK"){
                    helper.JobTasksfetch(component,event);
                    component.set("v.isBelowInsert",false);
                    helper.showToast({
                        "type": "success",
                        "message": 'Successfully Inserted the Approval Task at the End.'
                    });
                    
                    var appEvent=$A.get("e.JobSuite:UpdateRecordsforChanges");
                    if(appEvent){
                        appEvent.fire();  
                    }
                } 
                else{
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": SbelowResponse.getReturnValue()
                    });  
                }
            }
        });
        $A.enqueueAction(SucessBelow);
        
    },
    
    
    /*
        * Show toast with provided params
        * */
    showToast : function(params){
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams(params);
            toastEvent.fire();
        } else{
            alert(params.message);
        }
    },
    
    reloadDataTable : function(){
        var refreshEvent = $A.get("e.force:refreshView");
        if(refreshEvent){
            refreshEvent.fire();
        }
    },
    
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.taskdata");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        // data.sort(this.sortBy(fieldName, reverse))
        if(fieldName=='SpecName' || fieldName=='TaskLink'){
            data.sort(this.sortBy('Name', reverse))
        }
        else {
            data.sort(this.sortBy(fieldName, reverse))
        }
        cmp.set("v.taskdata", data);
    },
    
    sortBy: function (field, reverse, primer) {
        console.log('==sortBy=primer==='+primer);
        console.log('==sortBy=field==='+field);
        console.log('==sortBy=reverse==='+reverse);
        var key = primer ?
            function(x) {return primer(x[field])} :
        function(x) {return x[field]};
        //checks if the two rows should switch places
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
    
    getParameterByName: function(component, event, name) {
        name = name.replace(/[\[\]]/g, "\\$&");
        var url = window.location.href;
        var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)");
        var results = regex.exec(url);
        if (!results) return null;
        if (!results[2]) return '';
        return decodeURIComponent(results[2].replace(/\+/g, " "));
    },
    
    
    })