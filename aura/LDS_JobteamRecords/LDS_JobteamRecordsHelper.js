({
    fetchCustomSettingdata :function(component, event , helper){
        
        var CreateAppStepsSetting=component.get("c.CreateAppStepAtTaskJobTskSetting");
        var Csetting=component.get("c.CustomSettingvalues");
        var CreateSsetting=component.get("c.CreateScheduleSetting");
        var DateAction=component.get("c.todaySystemDate");
        var RolesAction= component.get("c.getRoles"); 
        //var JobCostAccess = component.get("c.getisAccessable");
        
        
        CreateAppStepsSetting.setCallback(this, function(CreateAppStepsResponse){
            if (CreateAppStepsResponse.getState() === "SUCCESS") {
                console.log('=Approval custom settings=='+JSON.stringify(CreateAppStepsResponse.getReturnValue()));
                component.set("v.isCreateAppSteps",CreateAppStepsResponse.getReturnValue());
            }
        });
        
        Csetting.setCallback(this, function(CustomResponse){
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
        }); 
        
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
        
        /* JobCostAccess.setCallback(this, function(JobCostresponse) {
            if (JobCostresponse.getState() === "SUCCESS") {
                console.log('Job Cost Accessable'+JobCostresponse.getReturnValue());
                component.set("v.JobDetailAccessible",JobCostresponse.getReturnValue());
            }
        });*/
        
        $A.enqueueAction(CreateAppStepsSetting); 
        $A.enqueueAction(Csetting); 
        $A.enqueueAction(CreateSsetting);
        $A.enqueueAction(DateAction); 
        $A.enqueueAction(RolesAction); 
        // $A.enqueueAction(JobCostAccess);
        
    },
    
    fetchFieldLabels : function(component, event , helper){
        var rowActions = helper.getRowActions.bind(this, component);
        console.log('===rowActions====='+rowActions);
        var Specactions =[
            {label: 'Edit',name: 'Edit_JobSpec',iconName: 'utility:edit'}, 
            {label: 'Delete',name: 'Delete_JobSpec',iconName: 'utility:delete'}
        ];
        
        var action=component.get("c.getObjectLabels");
        action.setParams({
            ObjNames:['Job_Task__c','Job_Spec__c','Job__c']
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
                
                if(isMobile && PEValue){
                    component.set("v.isMobile",true);
                    component.set('v.speccolumns', [
                        {label: tableHeaders.Job_Spec__c.Name.label, fieldName: 'SpecName', sortable: true, type: 'url',initialWidth:300, typeAttributes: { label: { fieldName: 'Name' }, target: '_self', tooltip:{ fieldName: 'Name' } } },
                        {label: tableHeaders.Job_Spec__c.Description__c.label, fieldName: 'Description__c', type:'text'}
                    ]);
                }
                else{
                    component.set('v.speccolumns', [
                        //{label: 'Action', type: 'button', initialWidth: 100,  typeAttributes: { label: 'View',  name: 'view_details', title:{ fieldName:'Name' }}},
                        {type: 'action', typeAttributes: { rowActions: Specactions }},
                        {label: tableHeaders.Job_Spec__c.Name.label, fieldName: 'SpecName', sortable: true, type: 'url',initialWidth:300, typeAttributes: { label: { fieldName: 'Name' }, target: '_self', tooltip:{ fieldName: 'Name' } } },
                        {label: tableHeaders.Job_Spec__c.Description__c.label, fieldName: 'Description__c',type:'text'}
                        //{label:tableHeaders.Job_Spec__c.Sort_Order__c.label, fieldName: 'Sort_Order__c', type:'number',editable: true,initialWidth:150},
                        
                    ]);
                }
                
                setTimeout($A.getCallback(function (){
                    var createApprTskatJobTsk= component.get("v.isCreateAppSteps");
                    console.log('>>>>>>>>>>>fetchFieldLabels createApprTskatJobTsk>>>>>>>>>>',createApprTskatJobTsk)
                    if(createApprTskatJobTsk[0] && createApprTskatJobTsk[1]==false){
                        component.set('v.taskcolumns', [
                            { type: 'action', typeAttributes: { rowActions: rowActions }} ,
                            {label: 'Order', fieldName: 'Task_Order__c', type: 'text',editable: true,sortable: true,initialWidth:95 ,cellAttributes: { alignment: 'right' }},
                            {label: tableHeaders.Job_Task__c.Name.label, fieldName: 'TaskLink', sortable: true, type: 'url',initialWidth:210, typeAttributes: { label: { fieldName: 'Name' }, target: '_blank', tooltip:{ fieldName: 'Name' } } },
                            {label: tableHeaders.Job_Task__c.Assigned_Users__c.label, fieldName: 'Staff', type: 'text',sortable: true,initialWidth:275},     
                            {label: tableHeaders.Job_Task__c.Days__c.label, fieldName: 'Days__c', type: 'number',editable: true,sortable: true,initialWidth:90, cellAttributes: {alignment: 'left', class: { fieldName: 'TaskDueDateclass' } }},
                            {label: tableHeaders.Job_Task__c.Revised_Due_Date__c.label, fieldName: 'Revised_Due_Date__c', type: 'date-local',editable: true,initialWidth:155,sortable: true,cellAttributes: { class: { fieldName: 'TaskDueDateclass' } ,iconName: 'utility:event', iconAlternativeText: 'Final Due Date' }},
                            {label: tableHeaders.Job_Task__c.Hours__c.label,fieldName: 'Hours__c', type: 'number',editable: true,sortable: true,initialWidth:95, cellAttributes: {alignment: 'left', class: { fieldName: 'TaskDueDateclass'}}},                            
                            {label: tableHeaders.Job_Task__c.Completion_Date__c.label, fieldName: 'Completion_Date__c', type: 'date-local',sortable: true,initialWidth:140,cellAttributes: { iconName: 'utility:event', iconAlternativeText: 'Completion Date' }},
                            {label: 'Done', fieldName: 'Marked_Done__c', type: 'boolean',sortable: true,initialWidth:80,editable: true },
                            {label: 'Approval', type: 'button',fieldName: '',initialWidth:110,typeAttributes: { label: '', disabled :{ fieldName: 'isdisplayButn'}, name: 'HasApprovals', title: {fieldName:'btnTitle'},iconName: { fieldName: 'displayIconName'}, class:'btn_approval'}}
                            
                        ]);
                    }
                    
                    else if(createApprTskatJobTsk[1] && createApprTskatJobTsk[0]==false){
                        component.set('v.taskcolumns', [
                            { type: 'action', typeAttributes: { rowActions: rowActions }} ,
                            {label: 'Order', fieldName: 'Task_Order__c', type: 'text',editable: true,sortable: true,initialWidth:95 ,cellAttributes: { alignment: 'right' }},
                            {label: tableHeaders.Job_Task__c.Name.label, fieldName: 'TaskLink', sortable: true, type: 'url',initialWidth:210, typeAttributes: { label: { fieldName: 'Name' }, target: '_blank', tooltip:{ fieldName: 'Name' } } },
                            {label: tableHeaders.Job_Task__c.Assigned_Users__c.label, fieldName: 'Staff', type: 'text',sortable: true,initialWidth:275},     
                            {label: tableHeaders.Job_Task__c.Days__c.label, fieldName: 'Days__c', type: 'number',editable: true,sortable: true,initialWidth:90, cellAttributes: {alignment: 'left', class: { fieldName: 'TaskDueDateclass' } }},
                            {label: tableHeaders.Job_Task__c.Revised_Due_Date__c.label, fieldName: 'Revised_Due_Date__c', type: 'date-local',editable: true,initialWidth:155,sortable: true,cellAttributes: { class: { fieldName: 'TaskDueDateclass' } ,iconName: 'utility:event', iconAlternativeText: 'Final Due Date' }},
                            {label: tableHeaders.Job_Task__c.Hours__c.label,fieldName: 'Hours__c', type: 'number',editable: true,sortable: true,initialWidth:95, cellAttributes: {alignment: 'left', class: { fieldName: 'TaskDueDateclass'}}},                            
                            {label: tableHeaders.Job_Task__c.Completion_Date__c.label, fieldName: 'Completion_Date__c', type: 'date-local',sortable: true,initialWidth:140,cellAttributes: { iconName: 'utility:event', iconAlternativeText: 'Completion Date' }},
                            {label: 'Done', fieldName: 'Marked_Done__c', type: 'boolean',sortable: true,initialWidth:80,editable: true },
                            {label: 'File Name', type: 'text',fieldName: 'File_Name__c',initialWidth:350}
                            
                        ]);
                    }
                        else{
                            component.set('v.taskcolumns', [
                                { type: 'action', typeAttributes: { rowActions: rowActions }} ,
                                {label: 'Order', fieldName: 'Task_Order__c', type: 'text',editable: true,sortable: true,initialWidth:95 ,cellAttributes: { alignment: 'right' }},
                                {label: tableHeaders.Job_Task__c.Name.label, fieldName: 'TaskLink', sortable: true, type: 'url',initialWidth:210, typeAttributes: { label: { fieldName: 'Name' }, target: '_blank', tooltip:{ fieldName: 'Name' } } },
                                {label: tableHeaders.Job_Task__c.Assigned_Users__c.label, fieldName: 'Staff', type: 'text',sortable: true,initialWidth:275},     
                                {label: tableHeaders.Job_Task__c.Days__c.label, fieldName: 'Days__c', type: 'number',editable: true,sortable: true,initialWidth:90, cellAttributes: {alignment: 'left', class: { fieldName: 'TaskDueDateclass' } }},
                                {label: tableHeaders.Job_Task__c.Revised_Due_Date__c.label, fieldName: 'Revised_Due_Date__c', type: 'date-local',editable: true,initialWidth:155,sortable: true,cellAttributes: { class: { fieldName: 'TaskDueDateclass' } ,iconName: 'utility:event', iconAlternativeText: 'Final Due Date' }},
                                {label: tableHeaders.Job_Task__c.Hours__c.label,fieldName: 'Hours__c', type: 'number',editable: true,sortable: true,initialWidth:95, cellAttributes: {alignment: 'left', class: { fieldName: 'TaskDueDateclass'}}},                            
                                {label: tableHeaders.Job_Task__c.Completion_Date__c.label, fieldName: 'Completion_Date__c', type: 'date-local',sortable: true,initialWidth:140,cellAttributes: { iconName: 'utility:event', iconAlternativeText: 'Completion Date' }},
                                {label: 'Done', fieldName: 'Marked_Done__c', type: 'boolean',sortable: true,initialWidth:80,editable: true }
                            ]);
                        }
                }), 800);
                
                var labels = {'Staff':  tableHeaders.Job_Task__c.Assigned_Users__c.label,
                              'DueDate':tableHeaders.Job_Task__c.Revised_Due_Date__c.label,
                              'MarkedDone':tableHeaders.Job_Task__c.Marked_Done__c.label,
                              'CompletionDate':tableHeaders.Job_Task__c.Completion_Date__c.label
                             };
                component.set('v.DynamicLabels',labels);
                console.log('-----labels--'+JSON.stringify(labels));
                
                component.set('v.ScheCopyColumns', [
                    {label: tableHeaders.Job__c.Name.label, fieldName: 'Name', type: 'text'},
                    {label: tableHeaders.Job__c.Job_Auto_Number__c.label, fieldName: 'Job_Auto_Number__c', type: 'text'}
                ]);
                
                component.set('v.CampScheCopyColumns', [
                    {label: tableHeaders.Job__c.Name.label, fieldName: 'Name', type: 'text'},
                    {label: tableHeaders.Job__c.Job_Auto_Number__c.label, fieldName: 'Job_Auto_Number__c', type: 'text'}
                ]);
                
                component.set('v.TeamCopyColumns', [
                    {label: tableHeaders.Job__c.Name.label, fieldName: 'Name', type: 'text'},
                    {label: tableHeaders.Job__c.Job_Auto_Number__c.label, fieldName: 'Job_Auto_Number__c', type: 'text'}
                ]);
                
                
            }
        });
        $A.enqueueAction(action);
    },
    
    
    JobSpecTemplate : function(component,event) {
        var recId = component.get("v.recordId");
        var jobSpecTemp = component.get("c.getJobSpecTemplates");
        jobSpecTemp.setParams({
            recordId : recId
        });
        jobSpecTemp.setCallback(this, function(jSpecTempResponse) {
            console.log('===jSpecTemp======'+jSpecTempResponse.getReturnValue());
            var jSpecTempState = jSpecTempResponse.getState();
            if (jSpecTempState === "SUCCESS") {
                var jSpecTmp=jSpecTempResponse.getReturnValue();
                var jSpecTmpList=[];
                for(var key in jSpecTmp){
                    jSpecTmpList.push({ key: key, value:jSpecTmp[key]});
                }
                component.set("v.jSpecTempList",jSpecTmpList);
                console.log('====jSpecTmpList==='+JSON.stringify(jSpecTmpList));
                
            }
        });
        $A.enqueueAction(jobSpecTemp);
    },
    
    
    JobTeamsfetch : function(component,event,helper) {
        var recId = component.get("v.recordId");
        var teamPhotos = component.get("c.getTeamPhotos");
        
        teamPhotos.setParams({
            recordId: recId
        });
        
        teamPhotos.setCallback(this, function(teamPhotosResponse) {
            console.log('===state======' + teamPhotosResponse.getState());
            var teamPhotosState = teamPhotosResponse.getState();
            if (teamPhotosState === "SUCCESS") {
                var teamPhotos = teamPhotosResponse.getReturnValue();
                console.log('====teamPhotos==='+JSON.stringify(teamPhotos));
                component.set("v.JobTeamPhotos",teamPhotosResponse.getReturnValue());
                // document.getElementById('helptext').innerHTML=JSON.stringify(component.get("v.helpText[0]"));
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": "Job Team has insufficient access"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(teamPhotos);    //call the job Team Edit button records.
    },
    
    JobSpecsfetch : function(component,event) {
        // *************************************************** Display Spec Records ***********************************************************   
        var Specaction = component.get("c.getjobSpecrecords1");  
        Specaction.setParams({
            recordId : component.get("v.recordId")
        });
        Specaction.setCallback(this, function(specResponse){
            var specstate = specResponse.getState();
            var result= specResponse.getReturnValue();
            var val=Object.values(result);
            
            console.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>list of jobSpec records" +JSON.stringify(val[0]));
            //console.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>list of jobSpec records" +JSON.stringify(val[0].length));
            //console.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>list of jobSpec records" +JSON.stringify(typeof(val)));
            console.log("list of jobSpec records" + specResponse.getReturnValue());
            console.log("list of jobSpec records" + specResponse);
            var SpecList = [];
            var TablejSpecTmpList=[];
            if(specstate === "SUCCESS"){
                for (var key in result) {
                    var rows=result[key];
                    for(var i=0;i<rows.length;i++){
                        var row=rows[i];
                        row.SpecName='/'+row.Id;
                    }
                    SpecList.push({SpecTemp:key,value:rows});
                    TablejSpecTmpList.push(rows);
                }
                
                component.set("v.jobSpecrecords", SpecList);
                component.set("v.specdata",val[0]);
                component.set("v.specrawData",val[0]); 
            } else
            {
                console.log('>>>>>> Error >>>>>>>>>>',specResponse.getError()[0].message);
                var errors = specResponse.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            } 
        });
        
        var action11 = component.get("c.getFieldsforObject");
        action11.setParams({
            sObjName: "Job_Spec__c"
        });
        action11.setCallback(this, function(response) {
            var state = response.getState();
            console.log("list of fiels name" + response.getReturnValue());
            if (state === "SUCCESS") {
                component.set("v.fieldSet", response.getReturnValue());
            }
        });
        
        $A.enqueueAction(action11);      // get the fieldsetvalues for Job_Spec object.
        $A.enqueueAction(Specaction); 
    },
    
    JobTasksfetch : function(component,event) {
        var TaskAction= component.get("c.getListofJobTasks");
        TaskAction.setParams({
            jobId : component.get("v.recordId")
        });
        
        TaskAction.setCallback(this, function(response){ 
            if (response.getState() === "SUCCESS") {
                var rows=response.getReturnValue();
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    console.log("rows[i]===>" + JSON.stringify(row));
                    if(row.Job_Task_Roles__r!=null){
                        console.log("row.Job_Task_Roles__r===>" + row.Job_Task_Roles__r);
                        row.Staff= Array.prototype.map.call(row.Job_Task_Roles__r, function(item) { return item.User__c; }).join(", ");
                    	console.log(" row.Staff===>" +  row.Staff);
                    }
                    else{
                        row.Staff=''; 
                    }
                    
                    if(row.Has_Inprogress_Approval_Steps__c && row.Has_Approval_steps__c){
                        row.displayIconName = 'utility:priority'; 
                        row.isdisplayButn = false;
                        row.btnTitle='Click to view inprogress Approval Steps';
                    }
                    else if(row.Has_Approval_steps__c ){
                        row.displayIconName = 'utility:priority'; 
                        row.isdisplayButn = true;
                        row.btnTitle='Approval Process has created but there is no inprogress Approval Steps to view';
                    }
                        else{
                            row.displayIconName = ''; 
                            row.isdisplayButn = true;
                            row.btnTitle='There is no Approval Process';
                        }
                    row.TaskLink = '/'+row.Id;
                    if(row.Marked_Done__c){
                        row.TaskDueDateclass='TaskDueDatesNotEditable';
                    }
                    else {
                        row.TaskDueDateclass='TaskDueDatesEditable';
                    }
                }
                component.set("v.taskdata",rows);
            }  
        }); 
        
        $A.enqueueAction(TaskAction);  
    },
    
    WorkloadGraphfetch: function (component, event, helper,SelUserRole) {
        console.log('==============workload====');
        var action = component.get("c.getResourceWorkLoad");
        action.setParams({
            UserRoleString:SelUserRole
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let val = response.getReturnValue() ;
                var labelset=[] ;
                var dataset=[] ;
                val.forEach(function(key) {
                    labelset.push(key.label) ; 
                    dataset.push(key.count) ; 
                });
                
                var container=document.getElementById("chart-container");
                var re=document.getElementById("pie-chart");
                re.remove(); 
                var cel=document.createElement('canvas');
                cel.setAttribute('id', "pie-chart");
                container.appendChild(cel);
                
                var myBarChart= new Chart(document.getElementById("pie-chart"), {
                    type: 'bar',
                    data: {
                        labels:labelset,
                        datasets: [{
                            label: "Active Jobs",
                            backgroundColor: '#4285f4',
                            data: dataset
                        }]
                    },
                    options: {
                        maintainAspectRatio: false,
                        title: {
                            display: false,
                            text: 'Resource WorkLoad'
                        },
                        
                        scales: {
                            yAxes: [{
                                stacked: true,
                                gridLines: {
                                    display: true,
                                    color: "rgba(255,99,132,0.2)"
                                }
                            }],
                            xAxes: [{
                                gridLines: {
                                    display: false
                                }
                            }]
                        }
                    }
                    
                });
                
                
                /*   myBarChart.data.labels.pop();
                myBarChart.data.datasets.forEach((dataset1) => {
                    dataset1.data.pop();
                });
                    myBarChart.update();
                    
                    myBarChart.data.labels.push(labelset);
                    myBarChart.data.datasets.forEach((dataset2) => {
                    dataset2.data.push(dataset);
                });
                    myBarChart.update();    
                */    
                //helper.removeData(myBarChart);
                //helper.addData(myBarChart, labelset, dataset);
                
            }
            else{
                
            }
        });
        $A.enqueueAction(action);
        
    },
    
    removeData: function (chart){
        chart.data.labels.pop();
        chart.data.datasets.forEach((dataset) => {
            dataset.data.pop();
        });
            chart.update();
        },
            
            addData: function (chart,label,data){
                chart.data.labels.push(label);
                chart.data.datasets.forEach((dataset) => {
                    dataset.data.push(data);
                });
                    chart.update();   
                },
                    
                    
                    getRowActions: function (component, row, doneCallback) {
                        var CST=component.get("v.CST");
                        console.log('===Testing======');
                        console.log('===Json Row======'+JSON.stringify(row));
                        var actions = [];
                        var TaskDoneAction = {
                            'label': 'Task Done',
                            'iconName': 'action:approval',
                            'name': 'Task_Done',
                            'disabled':row.Marked_Done__c  
                        };
                        
                        var AttachFile = {
                            'label': 'Attach File',
                            'iconName': 'action:new_task',
                            'name': 'FileAttach',
                            'disabled':row.Marked_Done__c  
                        };
                        /*******************************below Newly added for file preview****************************/
                        /*    var FilePreview = {
                            'label': 'File Preview',
                            'name': 'FilePreview',
                            'disabled':row.Marked_Done__c  
                        };*/
                        
                        var CreateApprovalProcessAction = {
                            'label': 'Create Approval Process',
                            'iconName': 'action:new_task',
                            'name': 'Create_Approval_Process',
                            'disabled':row.Marked_Done__c  
                        };
                        
                        var TaskOpenAction = {
                            'label': 'Re-Open',
                            'iconName': 'utility:close',
                            'name': 'Task_Open',
                            'disabled':!row.Marked_Done__c 
                        };
                        
                        var AddEditAction = {
                            'label': 'Add/Edit Staff',
                            'iconName': 'action:edit_groups',
                            'name': 'Task_AddEdit'
                        };
                        
                        
                        var LogTimeAction = {
                            'label': 'Log Time',
                            'iconName': 'action:defer',
                            'name': 'Task_LogTime',
                            'disabled':(CST[1].New_Time_Sheet_Entry_Button__c || row.Job__r.Status__c!='Active')
                        };
                        
                        
                        var EditAction = {
                            'label': 'Edit',
                            'iconName': 'utility:edit',
                            'name': 'Task_Edit'
                        };
                        
                        var InsertAction = {
                            'label': 'Insert Above',
                            'iconName': 'utility:arrowup',
                            'name': 'Task_Above'
                        }; 
                        
                        var DeleteAction = {
                            'label': 'Delete',
                            'iconName': 'utility:delete',
                            'name': 'Task_Delete'
                        };
                        var createAppStepset=component.get("v.isCreateAppSteps");
                        console.log('>>>>>>>>>>>createAppStepset>>>>>>>>>>>>',createAppStepset);
                        if(createAppStepset[0] && createAppStepset[1]==false){
                            actions.push(TaskDoneAction,TaskOpenAction,CreateApprovalProcessAction,AddEditAction,EditAction,DeleteAction,InsertAction,LogTimeAction);
                        }
                        else if(createAppStepset[1] && createAppStepset[0]==false){
                            actions.push(TaskDoneAction,TaskOpenAction,AttachFile,AddEditAction,EditAction,DeleteAction,InsertAction,LogTimeAction);
                        }        
                            else{
                                actions.push(TaskDoneAction,TaskOpenAction,AddEditAction,EditAction,DeleteAction,InsertAction,LogTimeAction);
                            }
                        
                        //actions.push(TaskDoneAction,TaskOpenAction,AddEditAction,EditAction,DeleteAction,InsertAction,LogTimeAction);
                        
                        // simulate a trip to the server
                        setTimeout($A.getCallback(function (){
                            doneCallback(actions);
                        }), 200);
                    },
                    
                    
                    TaskEditSucess :function(component,event, helper,TaskId,UpdateRestDays,UpdateRestDates){
                        var TaskSuccessAction=component.get("c.TaskEditSuccess");
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
                                        "message": "Successfully Updated the Job Task."
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
                    
                    DeleteTask :function(component, event, helper,selectTaskId){
                        var delTask=component.get("c.DeleteTask");      
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
                                        "message": "Successfully Deleted the Job Task."
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
                    
                    DeleteSpec: function(component, event, helper,selectSpecId){
                        var DelSpecAction = component.get('c.deleteJobSpec');
                        
                        if(selectSpecId!=null || selectSpecId!=undefined){
                            DelSpecAction.setParams({
                                SpecRecId : selectSpecId
                            });
                        }
                        else{
                            var row = event.getParam('row');
                            DelSpecAction.setParams({
                                SpecRecId : row.Id
                            });
                        }               
                        DelSpecAction.setCallback(this, function(DelSpecResponse) {
                            console.log('===Dele spec Reuturn==' + DelSpecResponse.getReturnValue());
                            if (DelSpecResponse.getState() === "SUCCESS") {
                                if(DelSpecResponse.getReturnValue()=="OK"){
                                    console.log('===Dele spec Reuturn==' + DelSpecResponse.getReturnValue());
                                    helper.JobSpecsfetch(component, event);
                                    
                                    helper.showToast({
                                        "type": "success",
                                        "message": "Record deleted."
                                    });
                                }
                                else{
                                    helper.showToast({
                                        "title":"Error!!",
                                        "type": "error",
                                        "message": DelSpecResponse.getReturnValue()
                                    });
                                }
                                
                            }
                            else{
                                helper.showToast({
                                    "title":"Error!!",
                                    "type": "error",
                                    "message": DelSpecResponse.getReturnValue()
                                });
                            }
                        });
                        $A.enqueueAction(DelSpecAction);
                        
                    },
                    
                    ActiveTask :function(component, event, helper, tskId){
                        console.log('===Active Helper tskId====='+tskId);
                        var JobStatus=component.get("v.simpleRecord");
                        console.log('========'+JSON.stringify(JobStatus));
                        if(JobStatus.Status__c=="Completed"){
                            helper.showToast({
                                "type": "info",
                                "message": "Task Can't be Re-Open for the Completed Job."
                            }); 
                            event.getSource().set("v.value",true);
                        }
                        else{   
                            var actTask=component.get("c.ActiveTask");
                            if(tskId!=null || tskId!=undefined)
                            {
                                actTask.setParams({
                                    tskid : tskId
                                });
                            }
                            else
                            {
                                var row = event.getParam('row');
                                
                                actTask.setParams({
                                    tskid : row.Id
                                });
                            }
                            
                            
                            actTask.setCallback(this, function(response){ 
                                if (response.getState() === "SUCCESS") {
                                    if(response.getReturnValue()=="OK"){
                                        helper.JobTasksfetch(component,event);
                                        helper.showToast({
                                            "type": "success",
                                            "message": "Task Re-Opened Successfully."
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
                            $A.enqueueAction(actTask); 
                        }
                    },
                    
                    CompleteTask :function(component, event, helper, tskId){
                        console.log('===Completed Helper tskId====='+tskId);
                        var cmpTask=component.get("c.CompleteTask");
                        if(tskId!=null || tskId!=undefined)
                        {
                            cmpTask.setParams({
                                tskid : tskId
                            });
                        }
                        else{
                            var row = event.getParam('row');
                            cmpTask.setParams({
                                tskid : row.Id
                            });
                        }
                        
                        
                        cmpTask.setCallback(this, function(response){ 
                            if (response.getState() === "SUCCESS") {
                                if(response.getReturnValue()=="OK"){
                                    helper.JobTasksfetch(component,event);
                                    helper.showToast({
                                        "type": "success",
                                        "message": "Task Done Successfully."
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
                        $A.enqueueAction(cmpTask); 
                    },
                    
                    copyScheudlehelper :function(component, event, helper){
                        var copySche=component.get("c.ShowMultipleScheduleCopyJobs");
                        copySche.setParams({
                            Cpyid : component.get("v.recordId")
                        });
                        
                        copySche.setCallback(this, function(response){ 
                            if (response.getState() === "SUCCESS") {
                                var rows=response.getReturnValue();
                                component.set("v.ScheCopyJobs",rows);
                            }  else {
                                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                                var errors = response.getError();
                                helper.showToast({
                                    "title": "Error!!",
                                    "type": "error",
                                    "message": errors[0].message
                                }); 
                            } 
                        }); 
                        $A.enqueueAction(copySche); 
                    },
                    
                    copyCampScheudlehelper :function(component, event, helper){
                        var copyCampSche=component.get("c.ShowMultipleCampScheduleCopyJobs");
                        copyCampSche.setParams({
                            Cpyid : component.get("v.recordId")
                        });
                        
                        copyCampSche.setCallback(this, function(response){ 
                            if (response.getState() === "SUCCESS") {
                                var rows=response.getReturnValue();
                                component.set("v.CampScheCopyJobs",rows);
                            }  else {
                                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                                var errors = response.getError();
                                helper.showToast({
                                    "title": "Error!!",
                                    "type": "error",
                                    "message": errors[0].message
                                }); 
                            } 
                        }); 
                        $A.enqueueAction(copyCampSche); 
                    },                
                    
                    helpSavecopySchedule :function(component, event, helper){
                        var saveSche=component.get("c.saveRsc");
                        saveSche.setParams({
                            Cpyid : component.get("v.recordId"),
                            selectedrecs:component.get("v.selected_CopyScheJobs")
                        });
                        
                        saveSche.setCallback(this, function(response){ 
                            if (response.getState() === "SUCCESS") {
                                if(response.getReturnValue()=="OK"){
                                    component.set("v.isCopyOpen", false);
                                    component.set("v.selected_CopyScheJobs",null);
                                    component.set('v.selCopyScheRowsCount',null);
                                    helper.JobTasksfetch(component,event);
                                    helper.showToast({
                                        "type": "success",
                                        "message": "Successfully Completed the Copy Schedule for the Selected Jobs."
                                    });
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
                        $A.enqueueAction(saveSche); 
                    },
                    
                    helpSavecopyCampSchedule :function(component, event, helper){
                        var saveSche=component.get("c.saveRsc");
                        saveSche.setParams({
                            Cpyid : component.get("v.recordId"),
                            selectedrecs:component.get("v.selected_CopyCampScheJobs")
                        });
                        
                        saveSche.setCallback(this, function(response){ 
                            if (response.getState() === "SUCCESS") {
                                if(response.getReturnValue()=="OK"){
                                    component.set("v.isCampSchCopyOpen", false);
                                    component.set("v.selected_CopyCampScheJobs",null);
                                    component.set('v.selCampCopyScheRowsCount',null);
                                    helper.JobTasksfetch(component,event);
                                    helper.showToast({
                                        "type": "success",
                                        "message": "Successfully Completed the Copy Schedule for the Selected Jobs."
                                    });
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
                        $A.enqueueAction(saveSche); 
                    },                
                    
                    
                    copyTeamhelper :function(component, event, helper){
                        var copyTeam=component.get("c.TeamCopytoJobsrelatedCamp");
                        copyTeam.setParams({
                            Cpyid : component.get("v.recordId")
                        });
                        
                        copyTeam.setCallback(this, function(response){ 
                            if (response.getState() === "SUCCESS") {
                                var rows=response.getReturnValue();
                                console.log('--rows1--'+JSON.stringify(rows));
                                component.set("v.TeamCopyJobs",rows);
                            } else {
                                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                                var errors = response.getError();
                                helper.showToast({
                                    "title": "Error!!",
                                    "type": "error",
                                    "message": errors[0].message
                                }); 
                            } 
                        }); 
                        $A.enqueueAction(copyTeam); 
                    },
                    
                    helpSavecopyTeam :function(component, event, helper){
                        console.log('>>>>>helpSavecopyTeam>>>>>>>');
                        var saveTeam=component.get("c.saveCopyTeam");
                        saveTeam.setParams({
                            Cpyid : component.get("v.recordId"),
                            selectedrecs:component.get("v.selected_CopyTeamJobs")
                        });
                        
                        saveTeam.setCallback(this, function(response){ 
                            if (response.getState() === "SUCCESS") {
                                console.log('>>>>>helpSavecopyTeam SUCCESSSSS>>>>>>>');
                                if(response.getReturnValue()=="success"){
                                    console.log('>>>>>helpSavecopyTeam OKKKKK>>>>>>>');
                                    component.set("v.isCopyStaff", false);
                                    component.set("v.selected_CopyTeamJobs",null);
                                    component.set('v.selCopyTeamRowsCount',null);
                                    helper.JobTeamsfetch(component,event);
                                    helper.showToast({
                                        "type": "success",
                                        "message": "Successfully Completed the Copy Team Members for the Selected Jobs."
                                    });
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
                        $A.enqueueAction(saveTeam); 
                    },                
                    
                    
                    
                    createSchedule : function(component, event, helper){
                        var CreateSchdule = component.get("c.createSchedule");
                        CreateSchdule.setParams({
                            jobId:component.get("v.recordId")
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
                            }
                        });
                        $A.enqueueAction(CreateSchdule);
                    },
                    
                    /*
     * This function get called when user clicks on Save button
     * user can get all modified records
     * and pass them back to server side controller
     * */
                    
                    saveDataTableofSpecs : function(component, event, helper) {
                        var editedRecords1 = event.getParam('draftValues');// component.find("SpecsTable").get("v.SpecdraftValues");
                        console.log('===Specs====editedRecords======'+JSON.stringify(editedRecords1));
                        //var totalRecordEdited = editedRecords.length;
                        var action = component.get("c.updateSpecs");
                        action.setParams({
                            'editSpecsList' : editedRecords1
                        });
                        action.setCallback(this,function(response) {
                            var state = response.getState();
                            if (state === "SUCCESS") {
                                //if update is successful
                                if(response.getReturnValue() === 'true'){
                                    helper.showToast({
                                        "title": "Record Update",
                                        "type": "success",
                                        "message": " Specs Records Updated"
                                    });
                                    
                                    // helper.reloadDataTable();
                                    helper.JobSpecsfetch(component, event);
                                    //component.find("SpecsTable").set("v.draftValues", null);
                                    
                                } else{ //if update got failed
                                    helper.showToast({
                                        "title": "Error!!",
                                        "type": "error",
                                        "message": response.getReturnValue()
                                    });
                                    
                                }      
                            }
                            
                        });
                        $A.enqueueAction(action);
                    },    
                    
                    
                    
                    saveDataTableofTasks : function(component, event, helper) {
                        
                        var editedRecords =  component.find("TaskTable").get("v.draftValues");
                        console.log('====editedRecords======'+JSON.stringify(editedRecords));
                        var totalRecordEdited = editedRecords.length;
                        var action = component.get("c.updateTasksinlineEdit");
                        action.setParams({
                            'lstJT' : editedRecords
                        });
                        action.setCallback(this,function(response) {
                            var state = response.getState();
                            if (state === "SUCCESS") {
                                //if update is successful
                                if(response.getReturnValue() === 'true'){
                                    helper.showToast({
                                        "title": "Record Update",
                                        "type": "success",
                                        "message": totalRecordEdited+" Task Records Updated"
                                    });
                                    
                                    // helper.reloadDataTable();
                                    helper.JobTasksfetch(component, event);
                                    component.find("TaskTable").set("v.draftValues", null);
                                    var appEvent=$A.get("e.JobSuite:UpdateRecordsforChanges");
                                    if(appEvent){
                                        appEvent.fire();  
                                    }
                                    
                                } else{ //if update got failed
                                    helper.showToast({
                                        "title": "Error!!",
                                        "type": "error",
                                        "message": response.getReturnValue()
                                    });
                                    
                                }      
                            }
                            
                        });
                        $A.enqueueAction(action);
                    },
                    
                    
                    cellChangeValues :function(component, event, helper) {
                        
                        var modalBody;
                        var modalFooter; 
                        $A.createComponents([
                            ["lightning:button",
                             {
                                 "aura:id": "NoId",
                                 "label": "No",
                                 "onclick":component.getReference("c.NoAction") 
                             }],
                            ["lightning:button",
                             {
                                 "aura:id": "YesId",
                                 "variant" :"brand",
                                 "label": "Yes",
                                 "onclick": component.getReference("c.YesAction") 
                             }]
                        ],
                                            function(content, status, errorMessage){
                                                if (status === "SUCCESS") {
                                                    modalBody = 'Do you want to update rest of the Schedule?';
                                                    modalFooter=content;
                                                    var OverLayPanel=component.find('overlayLib1').showCustomModal({
                                                        header: "Schedule Update",
                                                        body: modalBody,
                                                        footer: modalFooter,
                                                        showCloseButton: true,
                                                        cssClass: "mymodal",
                                                        closeCallback: function() {
                                                            component.find("TaskTable").set("v.draftValues", null);
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
                                                    modalBody = 'Do you want to update rest of the Schedule?';
                                                    modalFooter=content;
                                                    var OverLayPanel=component.find('overlayLib1').showCustomModal({
                                                        header: "Schedule Update",
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
                                                    modalBody = 'Do you want to update rest of the Schedule?';
                                                    modalFooter=content;
                                                    var OverLayPanel=component.find('overlayLib1').showCustomModal({
                                                        header: "Schedule Update",
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
                    
                    
                    updateScheduleOnDays : function(component,event,helper,taskId,days,updateRestScheduleDays){
                        var updateDays = component.get("c.updateScheduleOnDays");
                        updateDays.setParams({
                            jobId:component.get("v.recordId"),
                            taskId1 : taskId,
                            days1 : days,
                            updateRestScheduleDays :updateRestScheduleDays
                        });
                        updateDays.setCallback(this, function(DaysResponse) {
                            console.log('===DaysResponse======'+DaysResponse.getReturnValue());
                            var DaysState = DaysResponse.getState();
                            if (DaysState === "SUCCESS") {
                                if(DaysResponse.getReturnValue()=="OK"){
                                    helper.JobTasksfetch(component,event);
                                    component.find("TaskTable").set("v.draftValues", null);
                                    component.get('v.overlayPanel').then(
                                        function(modal){
                                            modal.close();
                                        }
                                    );
                                    var appEvent=$A.get("e.JobSuite:UpdateRecordsforChanges");
                                    if(appEvent){
                                        appEvent.fire();  
                                    }
                                }
                                else{
                                    helper.showToast({
                                        "title": "Error!!",
                                        "type": "error",
                                        "message": DaysResponse.getReturnValue()
                                    });  
                                }
                            }
                            else{
                                helper.showToast({
                                    "title": "Error!!",
                                    "type": "error",
                                    "message": DaysResponse.getReturnValue()
                                });  
                            }
                        });
                        $A.enqueueAction(updateDays);
                    },
                    
                    
                    updateRestSchedule : function(component,event,helper,taskId,revdate,updateRestScheduleRevDt){
                        
                        var updateSche = component.get("c.updateRestSchedule");
                        updateSche.setParams({
                            jobId:component.get("v.recordId"),
                            taskId : taskId,
                            dt : revdate,
                            updateRestScheduleRevDt : updateRestScheduleRevDt
                        });
                        updateSche.setCallback(this, function(ScheResponse) {
                            console.log('===ScheResponse======'+ScheResponse.getReturnValue());
                            var SchState = ScheResponse.getState();
                            if (SchState === "SUCCESS") {
                                if(ScheResponse.getReturnValue()=="OK"){
                                    helper.JobTasksfetch(component,event);
                                    component.find("TaskTable").set("v.draftValues", null);
                                    component.get('v.overlayPanel').then(
                                        function(modal){
                                            modal.close();
                                        }
                                    );
                                    
                                } 
                                else{
                                    helper.showToast({
                                        "title": "Error!!",
                                        "type": "error",
                                        "message": ScheResponse.getReturnValue()
                                    });  
                                }
                            }
                            else{
                                helper.showToast({
                                    "title": "Error!!",
                                    "type": "error",
                                    "message": ScheResponse.getReturnValue()
                                });  
                            }
                        });
                        $A.enqueueAction(updateSche);
                        
                    },
                    
                    
                    
                    InsertAboveSucess : function(component,event,helper,Oldtaskid,NewTaskId,strid){
                        // helper.InsertAboveSucess(component, event,helper,Oldtaskid,NewTaskId,strid); 
                        console.log('below Oldtaskid === '+Oldtaskid);
                        console.log('current NewTaskId === '+NewTaskId);
                        console.log('strid === '+strid);
                        var SucessAbove = component.get("c.InsertAboveSucess");
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
                    
                    
                    InsertBlowSucess : function(component,event,helper,Taskid,strid,TaskOrder){
//console.log('Taskid === '+Taskid+'strid === '+strid+'TaskOrder === '+TaskOrder+'StartDate === '+StartDate);                     
                        var SucessBelow = component.get("c.InsertBlowSucess");
                        SucessBelow.setParams({
                            Taskid : Taskid,
                            strid : strid,
                            task_order_no: TaskOrder,
                           // d6 : StartDate
                        });
                        SucessBelow.setCallback(this, function(SbelowResponse) {
                            console.log('===SbelowState======'+SbelowResponse.getReturnValue());
                             
                            var SbelowState = SbelowResponse.getState();
                            console.log('===SbelowState======'+SbelowState);
                            if (SbelowState === "SUCCESS") {
                                if(SbelowResponse.getReturnValue()=="OK"){
                                    helper.JobTasksfetch(component,event);
                                    component.set("v.isBelowInsert",false);
                                    helper.showToast({
                                        "type": "success",
                                        "message": 'Successfully Inserted the Task at the End.'
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
                    
                    
                    
                    loadDataToCalendar : function(component,cmpEvent,cmphelper,data){  
                        //Find Current date for default date
                        // var EventData=component.get("v.Objectlist");
                        var d = new Date();
                        var month = d.getMonth()+1;
                        var day = d.getDate();
                        var currentDate = d.getFullYear() + '/' +
                            (month<10 ? '0' : '') + month + '/' +
                            (day<10 ? '0' : '') + day;
                        
                        console.log('currentDate'+currentDate);
                        var self = this;
                        $('#calendar').fullCalendar({
                            header: {
                                center: 'month,basicWeek,basicDay',
                                right:'prev next today',
                                left: 'title'
                            },
                            
                            //defaultView: 'basicWeek'
                            //height:650,
                            //contentHeight:600,
                            //contentHeight:'auto',
                            //navLinks: true,
                            // lazyFetching:false,
                            defaultDate: currentDate,
                            aspectRatio: 2.5,
                            eventLimit: true,
                            editable: true,
                            //themeSystem: 'jquery-ui',
                            eventDurationEditable: true,
                            eventStartEditable: true,
                            firstDay: 1,
                            events:data,
                            
                            
                            eventRender: function( event, element, view ) {
                                
                                var DELAY = 200,
                                    clicks = 0,
                                    timer = null;   
                                element.bind("click", function(e){
                                    clicks++;  //count clicks
                                    
                                    if(clicks === 1){
                                        timer = setTimeout(function() {
                                            var tskid=event.taskid;
                                            self.calenderTaskEdit(component,cmpEvent,cmphelper,tskid);
                                            clicks = 0;  //after action performed, reset counter
                                        }, DELAY);
                                    } 
                                    else{
                                        var tskstatus=event.Tstatus;
                                        var taskDid=event.taskid;
                                        var textmsg;
                                        
                                        if(tskstatus==='Completed'){
                                            tskstatus='Active';
                                            textmsg='Do yo want Re-Open the Task?';
                                        }
                                        else{
                                            tskstatus='Completed';
                                            textmsg='Do yo want Complete the Task?';
                                        }
                                        
                                        clearTimeout(timer);  //prevent single-click action
                                        //alert('Double Click');  //perform double-click action
                                        clicks = 0;  //after action performed, reset counter
                                        if(confirm(''+textmsg)){
                                            var enddate =event.start.format();
                                            // $A.localizationService.formatDate(event.start,"YYYY-MM-DD");
                                            component.set("v.calDueDate",enddate);
                                            self.statusChangeUpdate(component,cmpEvent,cmphelper,taskDid,tskstatus);
                                        }
                                        
                                    }
                                }); 
                                
                                return ['All', event.Tstatus].indexOf($('#task_status_change').val()) >= 0;
                                
                            },
                            
                            eventResize: function(event, delta, revertFunc) {
                                alert('You cannot resize tasks.');
                                revertFunc();
                            },
                            
                            eventDrop: function(event, delta, revertFunc)
                            {
                                /* alert(event.title + " was dropped on " + event.start.format()); 
                 if (!confirm("Do you want to Update..!!!!!"))
                {
                    revertFunc();
                }
                else
                {
               
                }
                //var enddate = $A.localizationService.formatDate(event.start,"YYYY-MM-DD");
                //alert('==Task Due Date with Locatlization='+enddate);
                //console.log('==Task Due Date with Locatlization==='+enddate);
                //alert('==Task Due Date with Formatted Date==='+event.start.format());
                //console.log('==Task Due Date with Formatted Date==='+event.start.format());
                */
                                
                                // alert('Invoked...Start....Task...........'+event.start.format());
                                //  alert('Invoked...End....Task...........'+event.end.format());
                                var startdate=event.start.format();
                                var enddate=event.end.format();
                                
                                
                                self.TaskDueDateUpdate(component,cmpEvent,cmphelper,event.taskid,startdate,enddate);
                                
                            },
                            
                            
                            eventMouseover: function(calEvent, jsEvent) {
                                
                                // var startdate = $A.localizationService.formatDate(calEvent.start,"YYYY-MM-DD");
                                //var enddate = $A.localizationService.formatDate(calEvent.end,"YYYY-MM-DD");
                                var startdate =calEvent.start.format();
                                //var enddate = calEvent.end.format();
                                //console.log('===startdate==='+startdate);
                                //console.log('===enddate==='+enddate);
                                
                                calEvent.title = calEvent.title.split(' - ')[0]+', Job - # '+calEvent.title.split(' - ')[1];
                                var titlepos = calEvent.title.indexOf(",");
                                var taskName = calEvent.title.substring(0, titlepos);
                                var jobNo = calEvent.title.substring(titlepos+7,calEvent.title.length); 
                                
                                //Substringing the event JN to get Job Name and campaign name
                                var jnpos = calEvent.jn.indexOf(":");
                                var campName = calEvent.jn.substring(0, jnpos );
                                var jobName = calEvent.jn.substring(jnpos +2,calEvent.jn.indexOf("id="));
                                
                                var tooltip = '<div class="tooltipevent" style="box-shadow: 4px 4px 4px 4px '+calEvent.color+';padding:10px;background-color:'+calEvent.color+';color:white;position:absolute;z-index:10001;">' +
                                    '<B>Job : </B>' + jobName + ' - ' + jobNo + '<br>' +
                                    '<B>' + taskName + ' :: ' + startdate + '</B>' + '<br>' +
                                    '<B>Status : </B>' + calEvent.Tstatus + '<br>' +
                                    '<B>Client : </B>' + calEvent.client + '<br>' +
                                    '<B>Campaign: </B>' + campName + '<br>' +
                                    '<B>Staff: </B>' + calEvent.staff + '<br>' +
                                    
                                    '</div>';
                                var $tooltip = $(tooltip).appendTo('body');
                                $(this).mouseover(function(e) {
                                    $(this).css('z-index', 10000);
                                    $tooltip.fadeIn('500');
                                    $tooltip.fadeTo('10', 1.9);
                                }).mousemove(function(e) {
                                    $tooltip.css('top', e.pageY + 10);
                                    $tooltip.css('left', e.pageX + 20);
                                });
                            },
                            
                            
                            
                            eventMouseout: function(calEvent, jsEvent) {
                                $(this).css('z-index', 8);
                                $('.tooltipevent').remove();
                            },
                            
                            
                        });
                    },
                    
                    
                    formatFullCalendarData : function(component,tasks) {
                        var josnDataArray = [];
                        for(var i = 0;i < tasks.length;i++){
                            
                            josnDataArray.push({
                                
                                title: tasks[i].titleNew,
                                start: tasks[i].startString,
                                //start: tasks[i].endString,
                                end: tasks[i].endString,
                                taskid: tasks[i].TaskId,
                                Tstatus: tasks[i].Tstatus,
                                url: tasks[i].url,
                                allDay: tasks[i].allDay,
                                color: tasks[i].color +' !important',
                                jn:  tasks[i].JN1,
                                client:  tasks[i].client1,
                                staff:tasks[i].Staff,
                                className: tasks[i].className
                                
                            });
                        }
                        
                        return josnDataArray;
                    },
                    
                    fetchCalenderEvents : function(component,cmpEvent,cmphelper) {
                        // alert();
                        var action=component.get("c.getAlltasks");
                        action.setParams({
                            jobTaskid:component.get("v.recordId")
                        });
                        action.setCallback(this, function (response) {
                            var state = response.getState();
                            if (state === "SUCCESS") {
                                var data= response.getReturnValue();
                                console.log('========='+JSON.stringify(data));
                                var josnArr = this.formatFullCalendarData(component,response.getReturnValue());
                                this.loadDataToCalendar(component,cmpEvent,cmphelper,josnArr);
                                component.set("v.Objectlist",josnArr);
                                
                                $('#calendar').fullCalendar('removeEvents');
                                $('#calendar').fullCalendar('addEventSource', josnArr);         
                                $('#calendar').fullCalendar('rerenderEvents');
                            } else if (state === "ERROR") {
                                
                            }
                        });
                        
                        $A.enqueueAction(action);
                        
                    }, 
                    
                    calenderTaskEdit : function(component,event,helper,taskId){
                        component.set("v.EditTaskId",taskId);
                        component.set("v.isTaskEdit",true);
                    },
                    
                    TaskDueDateUpdate : function(component,cmpEvent,cmphelper,taskId,startdate,endDate){
                        var action=component.get("c.TaskDueDateUpdate");
                        action.setParams({ DCalTaskId : taskId ,
                                          DcalStartDate : startdate,
                                          DcalDueDate : endDate});
                        // var ed=endDate;
                        action.setCallback(this, function (response) {
                            var state = response.getState();
                            if (state === "SUCCESS") {
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "type": "success",
                                    "message": "Task Start and Due Dates are Updated"
                                });
                                toastEvent.fire();
                                cmphelper.JobTasksfetch(component,cmpEvent);
                                cmphelper.fetchCalenderEvents(component,cmpEvent,cmphelper);
                            } else if (state === "ERROR") {
                                
                            }
                        });
                        
                        $A.enqueueAction(action);
                        
                    },
                    
                    statusChangeUpdate : function(component,cmpEvent,cmphelper,taskDid,tskstatus){
                        var JobStatus=component.get("v.simpleRecord");
                        console.log('========'+JSON.stringify(JobStatus));
                        if(JobStatus.Status__c=="Completed"){
                            cmphelper.showToast({
                                "type": "info",
                                "message": "Task Can't be Re-Open for the Completed Job."
                            }); 
                        }
                        else{   
                            var chAction=component.get("c.statusChangeUpdate");
                            chAction.setParams({ DTaskId : taskDid ,
                                                DTaskStatus : tskstatus});
                            
                            chAction.setCallback(this, function (response) {
                                var state = response.getState();
                                if (state === "SUCCESS") {
                                    if(response.getReturnValue()=='OK'){
                                        console.log('=========='+response.getReturnValue());
                                        cmphelper.JobTasksfetch(component,cmpEvent);
                                        cmphelper.fetchCalenderEvents(component,cmpEvent,cmphelper);
                                        var toastEvent = $A.get("e.force:showToast");
                                        toastEvent.setParams({
                                            "type": "success",
                                            "message": "The record has been updated successfully."
                                        });
                                        toastEvent.fire();
                                        
                                        var appEvent=$A.get("e.JobSuite:UpdateRecordsforChanges");
                                        if(appEvent){
                                            appEvent.fire();  
                                        }
                                    }
                                    else{
                                        var toastEvent = $A.get("e.force:showToast");
                                        toastEvent.setParams({
                                            "type" :"error",
                                            "message" : response.getReturnValue()
                                        });
                                        toastEvent.fire();   
                                    }
                                } else if (state === "ERROR") {
                                    
                                }
                            });
                            
                            $A.enqueueAction(chAction);
                        }
                    },
                    
                    getStatusList :function(cmp,evt,helper){
                        var saction=cmp.get("c.getStatusList");
                        saction.setCallback(this, function (response) {
                            var state = response.getState();
                            if (state === "SUCCESS") {
                                cmp.set("v.statusList",response.getReturnValue());
                            } 
                        });
                        
                        $A.enqueueAction(saction);
                    },
                    
                    
                    /***************************************** Approval Process Starts***********************************************/                 
                    
                    handleFileAttachPro :function(component, event, helper, tskId){
                        
                        var FileId = component.find("FileId").get("v.value");
                        console.log('>>>>>>>>handleFileAttachPro FileId>>>>>>>>>',FileId);
                        var CreateSchdule = component.get("c.updateFiletoTask");
                        CreateSchdule.setParams({
                            jobTskId:tskId,
                            TaskFileId:FileId
                        });
                        CreateSchdule.setCallback(this, function(CRSResponse) {
                            console.log('===CRSResponse======'+CRSResponse.getReturnValue());
                            var CRSState = CRSResponse.getState();
                            if (CRSState === "SUCCESS") {
                                if(CRSResponse.getReturnValue()=="OK"){
                                    helper.JobTasksfetch(component,event);
                                    helper.showToast({
                                        "type": "success",
                                        "message": "File is attached to the task record."
                                    });
                                    var navEvt = $A.get("e.force:navigateToSObject");
                                    navEvt.setParams({
                                        "recordId": tskId,
                                        "slideDevName": "related"
                                    });
                                    navEvt.fire();
                                    
                                    var appEvent=$A.get("e.JobSuite:UpdateRecordsforChanges");
                                    if(appEvent){
                                        appEvent.fire();  
                                    }
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
                                console.log('>>>>>> Error >>>>>>>>>>',CRSResponse.getError());
                                var errors = CRSResponse.getError();
                                var toastEvent = $A.get("e.force:showToast");
                                helper.showToast({
                                    "title": "Error!!",
                                    "type": "error",
                                    "message":errors[0].message
                                });       
                            }
                        });
                        $A.enqueueAction(CreateSchdule);
                        
                        
                    },             
                    
                    
                    createScheduleApprovalPro :function(component, event, helper, tskId){
                        
                        var FileId = component.find("FileId").get("v.value");
                        var AppSchedTempId = component.find("APPSchTempId").get("v.value");
                        console.log('>>>>>>>>createScheduleApprovalPro FileId>>>>>>>>>',FileId);
                        console.log('>>>>>>>>createScheduleApprovalPro AppSchedTempId>>>>>>>>>',AppSchedTempId);
                        //alert("FileId "+FileId+ " AppSchedTempId: "+AppSchedTempId);
                        var CreateSchdule = component.get("c.createApprovalTask");
                        CreateSchdule.setParams({
                            jobTskId:tskId,
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
                                        "message": "Successfully Created Approval Process."
                                    });
                                    var navEvt = $A.get("e.force:navigateToSObject");
                                    navEvt.setParams({
                                        "recordId": tskId,
                                        "slideDevName": "related"
                                    });
                                    navEvt.fire();
                                    
                                    var appEvent=$A.get("e.JobSuite:UpdateRecordsforChanges");
                                    if(appEvent){
                                        appEvent.fire();  
                                    }
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
                                console.log('>>>>>> Error >>>>>>>>>>',CRSResponse.getError());
                                var errors = CRSResponse.getError();
                                var toastEvent = $A.get("e.force:showToast");
                                helper.showToast({
                                    "title": "Error!!",
                                    "type": "error",
                                    "message":errors[0].message
                                });       
                            }
                        });
                        $A.enqueueAction(CreateSchdule);
                        
                        
                    },
                    
                    HasApprovalssteps :function(component,event, helper,jobtskId){
                        
                        component.set('v.viewApprStepscolumns', [
                            {label: 'Approval Step', fieldName: 'AppTaskLink', sortable: true, type: 'url',initialWidth:210, typeAttributes: { label: { fieldName: 'Name' }, target: '_blank', tooltip:{ fieldName: 'Name' } } },
                            {label: 'Assigned Users', fieldName: 'Assigned_Users__c', type: 'text'},
                            {label: 'Due Date', fieldName: 'Revised_Due_Date__c', type: 'date-local',initialWidth:155,cellAttributes: { class: { fieldName: '' } ,iconName: 'utility:event', iconAlternativeText: 'Final Due Date' }},
                            {label: 'File Name', fieldName: 'File_Name__c', type: 'text'},
                            {label: 'Submitter Name', fieldName: 'Submitter_Name__c', type: 'text'},
                        ]);
                            var ViewSchdule = component.get("c.viewApprovalStepsrelTask");
                            ViewSchdule.setParams({
                            TskId:jobtskId
                            });
                            ViewSchdule.setCallback(this, function(viewAppResponse) {
                            var viewAppState = viewAppResponse.getState();
                            if (viewAppState === "SUCCESS") {
                            var rows=viewAppResponse.getReturnValue();
                            for (var i = 0; i < rows.length; i++) {
                            var row = rows[i];
                                      row.AppTaskLink = '/'+row.Id;
                                      }
                                      component.set("v.viewApprStepsList",rows);
                        //component.set("v.viewApprStepsList", viewAppResponse.getReturnValue());
                    }
                });
                $A.enqueueAction(ViewSchdule);
            },
            
            /***************************************** Approval Process Ends***********************************************/                
            
        })