// one comment add to check
import { LightningElement,api, track, wire } from 'lwc';
import customStyles from "@salesforce/resourceUrl/LwcCustomcss";
import customStyles1 from "@salesforce/resourceUrl/LightningDatatableRowHeight";
import { loadStyle } from "lightning/platformResourceLoader";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getObjectLabels from'@salesforce/apex/JobtaskLWC.getObjectLabels';
import getListofJobTasks from'@salesforce/apex/JobtaskLWC.getListofJobTasks';
import getRoles from'@salesforce/apex/JobtaskLWC.getRoles';
import CreateAppStepAtTaskJobTskSetting from'@salesforce/apex/JobtaskLWC.CreateAppStepAtTaskJobTskSetting';
import InsertAboveSucess from'@salesforce/apex/JobtaskLWC.InsertAboveSucess';
import TaskEditSuccess from'@salesforce/apex/JobtaskLWC.TaskEditSuccess';
import InsertBelowLoad from'@salesforce/apex/JobtaskLWC.InsertBelowLoad';
import InsertBlowSucess from'@salesforce/apex/JobtaskLWC.InsertBlowSucess';
import CompleteTask from'@salesforce/apex/JobtaskLWC.CompleteTask';
import DeleteTask from'@salesforce/apex/JobtaskLWC.DeleteTask';
import todaySystemDate from'@salesforce/apex/JobtaskLWC.todaySystemDate';
import CustomSettingvalues from'@salesforce/apex/JobtaskLWC.CustomSettingvalues';
import getisAccessable from'@salesforce/apex/JobtaskLWC.getisAccessable';
import InsertAboveLoad from'@salesforce/apex/JobtaskLWC.InsertAboveLoad';
import createSchedule from'@salesforce/apex/JobtaskLWC.createSchedule';
import MarkAllSelectedTasks from'@salesforce/apex/JobtaskLWC.MarkAllSelectedTasks';
import CreateScheduleSetting from'@salesforce/apex/JobtaskLWC.CreateScheduleSetting';
import saveRsc from'@salesforce/apex/JobtaskLWC.saveRsc';
import ShowMultipleCampScheduleCopyJobs from'@salesforce/apex/JobtaskLWC.ShowMultipleCampScheduleCopyJobs';
import getStaffWrapperMembers from'@salesforce/apex/JobtaskLWC.getStaffWrapperMembers';
import AddStaffToTask from'@salesforce/apex/JobtaskLWC.AddStaffToTask';
import myModalforedit from 'c/myModalforedit';
import { loadScript } from 'lightning/platformResourceLoader';
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import { refreshApex } from '@salesforce/apex';
import getTotalHours from'@salesforce/apex/JobtaskLWC.getTotalHours';
import getTaskInformation from'@salesforce/apex/JobtaskLWC.getTaskInformation';
import getRemainHours from'@salesforce/apex/JobtaskLWC.getRemainHours';
import calcTimeDiff from'@salesforce/apex/JobtaskLWC.calcTimeDiff';
import getAttachments from'@salesforce/apex/JobtaskLWC.getAttachments';
import getApprovalSchTemplates from'@salesforce/apex/JobtaskLWC.getApprovalSchTemplates';
import createApprovalTask from'@salesforce/apex/JobtaskLWC.createApprovalTask';
import updateFiletoTask from'@salesforce/apex/JobtaskLWC.updateFiletoTask';
import getUserName from'@salesforce/apex/JobtaskLWC.getUserName';
import updateScheduleOnDays from'@salesforce/apex/JobtaskLWC.updateScheduleOnDays';
import updateRestSchedule from'@salesforce/apex/JobtaskLWC.updateRestSchedule';
import updateTasksinlineEdit from'@salesforce/apex/JobtaskLWC.updateTasksinlineEdit';
import { NavigationMixin } from 'lightning/navigation';
import Status__c from "@salesforce/schema/Job__c.Status__c";
import Name from "@salesforce/schema/Job__c.Name";
const fields = [Status__c,Name];
export default class jobTaskSectionLWC extends NavigationMixin(LightningElement) {
    @api recordId;
    @track taskcolumns;
    @track tableHeaders = [];
    @track taskdata =[];
    @track taskIdList =[];
    @track ScheCopyColumns =[];
    @track ScheCopyJobs =[];
    @track JobteamisAccessible ;
    @track JobTaskisAccessible ;
    @track JobSpecisAccessible ;
    @track JobTeamisCreateable ;
    @track JobSpecisCreateable;
    @track JobSpecisUpdateable;
    @track JobTaskisCreateable;
    @track JobTaskisUpdateable;
    @track JobTaskRoleisUpdateable;
    @track TimesheetEntriesisCreateable;
    @track isDaysChanged = false;
    @track isDueDateFieldChanged =false;
    @track isDueDateChanged =false;
    @track isStartDateFieldChanged = false;
    @track RolesList ;
    @track activesectionname = ['WatchSection','EntrySection'] ;
    @track selectedTasksforMarkDone = false;
    @track selectedTasksforMarkDone1 = true;
    @track ShowScheduleBtn = false;
    @track isCopyOpen = false;
    @track createAppStepset;
    @track CST;
    @track RoleString ;
    @track jobcount = 0;
    @track copyjoblst;
    @track selectedRow;
    @track CalenderViewbln = true;
    @track ListViewbln = false;
    @track showScheCopyJobs =true ;
    @track isaddEditStaff = false;
    @track isTaskEdit = false;
    @track isHD ;
    @track isLoading ;
    @track AllstaffWrappers;
    @track rowID;
    @track isTaskLocked =true;
    @track isAboveInsert =false;
    @track isBelowInsert =false;
    @track isTaskLogTime =false;
    @track getListofJobTasks ;
    @track GLCodeName ;
    @track GLCode ;
    @track TotalHours ;
    @track RemainHours ;
    @track isStartEnd ;
    @track UserName ;
    @track JobStatus ;
    @track JobName ;
    @track TotalHoursWorked ;
    @track isCreateApprovalProcess =false;
    @track JobFileList ;
    @track AppschedTempList ;
    @track isFileAttach = false;
    @track FileId ;
    @track AppSchedTempId ;
    @track saveDraftValues = [] ;
    @track DraftValues = [] ;
    @track PopupResult ;
    @track revdate ;
    @track days1 ;
    @track taskId1 ;
    @track isLogTimeAction;
    
    connectedCallback() {
        Promise.all([loadStyle(this, customStyles)]).catch((error) => {
          // Handle any errors
        });
        Promise.all([loadStyle(this, customStyles1)]).catch((error) => {
            // Handle any errors
          });
         
    }
    @wire(getUserName)
    getUserName({data, error})
    {
        if(data) 
        {
            console.log('UserName=='+data);
            this.UserName = data[1];
            this.UserId = data[0];
        }
        else {
            error;
            console.log('CSTerror=='+JSON.stringify(error));
        }
    }

    @wire(getRecord, { recordId:'$recordId', fields})
    Jobdetails({error, data}){
        if(data){
           this.JobStatus = getFieldValue(data, Status__c);
           this.JobName = getFieldValue(data, Name);
        }else if(error){
            console.log('error', error);

        }
    }
    
    @wire(CreateScheduleSetting)
	CreateScheduleSetting({data, error})
	{
        if(data){
            
            console.log('CreateScheduleSetting==>'+data);
            this.isHD = data;
        }
        else {
			this.error = error;
		}
    }
    @wire(todaySystemDate)
	todaySystemDate({data, error})
	{
        if(data){
            
            console.log('CreateScheduleSetting==>'+data);
            this.today = data;
        }
        else {
			this.error = error;
		}
    }

    @wire(CreateAppStepAtTaskJobTskSetting)
	CreateAppStepAtTaskJobTskSetting({data, error})
	{
        if(data){
            console.log('CreateAppStepAtTaskJobTskSetting==>'+data);
            this.createAppStepset=data;
        }
        else {
			this.error = error;
            console.log('CreateAppStepAtTaskJobTskSettingerror'+JSON.stringify(error));
		}
    }
    @wire(getRoles)
	getRoles({data, error})
	{
        if(data){
            console.log('RolesList==>'+data);
            this.RolesList=data;
           
        }
        else {
			this.error = error;
            console.log('getRoleserror'+JSON.stringify(error));
		}
    }

    @wire(CustomSettingvalues)
    CustomSettingvalues({data, error})
    {
        if(data) 
        {
            this.CST = data;
            console.log('CST=='+JSON.stringify(this.CST));
        
        }
        else {

            error;
            console.log('CSTerror=='+JSON.stringify(error));
        }
    }
    @wire(getisAccessable)
    getisAccessable({data, error})
    {
        if(data) 
        {
            console.log('JobDetailAccessible=='+data);
            this.JobteamisAccessible = data[0];
            this.JobTaskisAccessible = data[1];
            this.JobSpecisAccessible = data[2];
            this.JobTeamisCreateable = data[3];
            this.JobSpecisCreateable = data[4];
            this.JobSpecisUpdateable = data[5];
            this.JobTaskisCreateable = data[6];
            this.JobTaskisUpdateable = data[7];
            this.JobTaskRoleisUpdateable = data[8];
            this.TimesheetEntriesisCreateable = data[9];
        }
        else  { error; }
    }
    @wire(getListofJobTasks,{ jobId:'$recordId'})
	getListofJobTasks(JobTasksresult )
	{
        this.getListofJobTasks=JobTasksresult;
        if(JobTasksresult.data) 
		{

            console.log('data151===>'+JSON.stringify(JobTasksresult.data));
           this.taskdata = JobTasksresult.data;
           const result = this.taskdata
            let rows = [];
            for(let i=0;i<result.length;i++){
                rows[i] = Object.assign({}, result[i]); 
                if(rows[i].JobSuite__Job_Task_Roles__r != null)
                {
                    rows[i].Staff= Array.prototype.map.call(rows[i].JobSuite__Job_Task_Roles__r, function(item) { return item.JobSuite__User__c; }).join(", ");
                }
                else
                {
                    rows[i].Staff=''; 
                }
                if(result[i].JobSuite__Has_Inprogress_Approval_Steps__c && result[i].JobSuite__Has_Approval_steps__c)
                {
                    rows[i].displayIconName = 'utility:priority'; 
                    rows[i].isdisplayButn = false;
                    rows[i].btnTitle='Click to view inprogress Approval Steps';
                }
                else if(result[i].JobSuite__Has_Approval_steps__c ){
                    rows[i].displayIconName = 'utility:priority'; 
                    rows[i].isdisplayButn = true;
                    rows[i].btnTitle='Approval Process has created but there is no inprogress Approval Steps to view';
                }
                    else{
                        rows[i].displayIconName = ''; 
                        rows[i].isdisplayButn = true;
                        rows[i].btnTitle='There is no Approval Process';
                    }
                    rows[i].TaskLink = '/'+result[i].Id;
                    rows[i].createAppStepset0 = this.createAppStepset[0] ;
                    rows[i].createAppStepset1 = this.createAppStepset[1];
                    rows[i].CST1 = this.CST[1].JobSuite__New_Time_Sheet_Entry_Button__c;
                if(result[i].JobSuite__Marked_Done__c){
                    rows[i].controlEditField= false;
                    rows[i].TaskDueDateclass='TaskDueDatesNotEditable';
                }
                else {
                    rows[i].TaskDueDateclass='TaskDueDatesEditable';
                    rows[i].controlEditField= true;
                }
            }
           
              console.log('taskdata190==>'+JSON.stringify(rows));
          this.taskdata = rows;
        }
		
		else if(JobTasksresult.error) {
			this.error = JobTasksresult.error;
            console.log('tabletitleerror'+JSON.stringify(JobTasksresult.error));
		}
	}
    @wire(getObjectLabels,{ ObjNames:['JobSuite__Job_Task__c','JobSuite__Job__c']})
    getObjectLabels({data, error}){
		if(data) 
		{
            this.tableHeaders = JSON.parse(data);
            if(this.createAppStepset[0] && this.createAppStepset[1]==false){
                this.taskcolumns = [
                    { type: 'action', typeAttributes: { rowActions: this.rowActions }} ,
                                 {label: 'Order', fieldName: 'JobSuite__Task_Order__c', type: 'text',editable: true,sortable: true,initialWidth:95 ,cellAttributes: { alignment: 'right' }},
                                 {label: this.tableHeaders.JobSuite__Job_Task__c.Name.label,                             fieldName: 'TaskLink',                         type: 'url',           sortable: true,                 initialWidth:210,   typeAttributes: { label: { fieldName: 'Name' }, target: '_blank', tooltip:{ fieldName: 'Name' } } },
                                 {label: this.tableHeaders.JobSuite__Job_Task__c.JobSuite__Assigned_Users__c.label,      fieldName: 'Staff',                            type: 'text',          sortable: true,                  initialWidth:275},     
                                 {label: this.tableHeaders.JobSuite__Job_Task__c.JobSuite__Days__c.label,                fieldName: 'JobSuite__Days__c',                type: 'number',        sortable: true,  editable: {fieldName: 'controlEditField'}, initialWidth:90,    cellAttributes: {alignment: 'left', class: { fieldName: 'TaskDueDateclass' } }},
                                 {label: this.tableHeaders.JobSuite__Job_Task__c.JobSuite__Revised_Due_Date__c.label,    fieldName: 'JobSuite__Revised_Due_Date__c',    type: 'date-local',    sortable: true,  editable: {fieldName: 'controlEditField'}, initialWidth:155,   cellAttributes: { class: { fieldName: 'TaskDueDateclass' } ,iconName: 'utility:event', iconAlternativeText: 'Final Due Date' }},
                                 {label: this.tableHeaders.JobSuite__Job_Task__c.JobSuite__Hours__c.label,               fieldName: 'JobSuite__Hours__c',               type: 'number',        sortable: true,  editable: {fieldName: 'controlEditField'}, initialWidth:95,    cellAttributes: {alignment: 'left', class: { fieldName: 'TaskDueDateclass'}}},                            
                                 {label: this.tableHeaders.JobSuite__Job_Task__c.JobSuite__Completion_Date__c.label,     fieldName: 'JobSuite__Completion_Date__c',     type: 'date-local',    sortable: true,                  initialWidth:140,   cellAttributes: { iconName: 'utility:event', iconAlternativeText: 'Completion Date' }},
                                 {label: 'Done',                                                                         fieldName: 'JobSuite__Marked_Done__c',         type: 'boolean',       sortable: true,  editable: true, initialWidth:80},
                                 {label: 'Approval', type: 'button',                                                     fieldName: '',                                                                                         initialWidth:110,   typeAttributes: { label: '', disabled :{ fieldName: 'isdisplayButn'}, name: 'HasApprovals', title: {fieldName:'btnTitle'},iconName: { fieldName: 'displayIconName'}, class:'btn_approval'}}
                             ];
            }
            else if(this.createAppStepset[1] && this.createAppStepset[0]==false){
                this.taskcolumns = [
                    { type: 'action', typeAttributes: { rowActions: this.rowActions }} ,
                                 {label: 'Order', fieldName: 'JobSuite__Task_Order__c', type: 'text',editable: true,sortable: true,initialWidth:95 ,cellAttributes: { alignment: 'right' }},
                                 {label: this.tableHeaders.JobSuite__Job_Task__c.Name.label,                             fieldName: 'TaskLink',             sortable: true, type: 'url',initialWidth:210, typeAttributes: { label: { fieldName: 'Name' }, target: '_blank', tooltip:{ fieldName: 'Name' } } },
                                 {label: this.tableHeaders.JobSuite__Job_Task__c.JobSuite__Assigned_Users__c.label,      fieldName: 'Staff',     type: 'text',sortable: true,initialWidth:275},     
                                 {label: this.tableHeaders.JobSuite__Job_Task__c.JobSuite__Days__c.label,                fieldName: 'JobSuite__Days__c',     type: 'number',editable: {fieldName: 'controlEditField'},sortable: true,initialWidth:90, cellAttributes: {alignment: 'left', class: { fieldName: 'TaskDueDateclass' } }},
                                 {label: this.tableHeaders.JobSuite__Job_Task__c.JobSuite__Revised_Due_Date__c.label,    fieldName: 'JobSuite__Revised_Due_Date__c', type: 'date-local',editable: {fieldName: 'controlEditField'},initialWidth:155,sortable: true,cellAttributes: { class: { fieldName: 'TaskDueDateclass' } ,iconName: 'utility:event', iconAlternativeText: 'Final Due Date' }},
                                 {label: this.tableHeaders.JobSuite__Job_Task__c.JobSuite__Hours__c.label,               fieldName: 'JobSuite__Hours__c', type: 'number',editable: {fieldName: 'controlEditField'},sortable: true,initialWidth:95, cellAttributes: {alignment: 'left', class: { fieldName: 'TaskDueDateclass'}}},                            
                                 {label: this.tableHeaders.JobSuite__Job_Task__c.JobSuite__Completion_Date__c.label,     fieldName: 'JobSuite__Completion_Date__c', type: 'date-local',sortable: true,initialWidth:140,cellAttributes: { iconName: 'utility:event', iconAlternativeText: 'Completion Date' }},
                                 {label: 'Done',                                                                         fieldName: 'JobSuite__Marked_Done__c', type: 'boolean',sortable: true,initialWidth:80,editable: true },
                                 {label: 'File Name', type: 'text',                                                     fieldName: 'JobSuite__File_Name__c',initialWidth:350}
                                 
                             ];
            }        
            else{
                    this.taskcolumns = [
                        { type: 'action', typeAttributes: { rowActions: this.rowActions }} ,
                                     {label: 'Order', fieldName: 'JobSuite__Task_Order__c', type: 'text',editable: true,sortable: true,initialWidth:95 ,cellAttributes: { alignment: 'right' }},
                                     {label: this.tableHeaders.JobSuite__Job_Task__c.Name.label,                              fieldName: 'TaskLink',  sortable: true, type: 'url',initialWidth:210, typeAttributes: { label: { fieldName: 'Name' }, target: '_blank', tooltip:{ fieldName: 'Name' } } },
                                     {label: this.tableHeaders.JobSuite__Job_Task__c.JobSuite__Assigned_Users__c.label,      fieldName: 'Staff',     type: 'text',sortable: true,initialWidth:275},     
                                     {label: this.tableHeaders.JobSuite__Job_Task__c.JobSuite__Days__c.label,                fieldName: 'JobSuite__Days__c',     type: 'number',editable: {fieldName: 'controlEditField'},sortable: true,initialWidth:90, cellAttributes: {alignment: 'left', class: { fieldName: 'TaskDueDateclass' } }},
                                     {label: this.tableHeaders.JobSuite__Job_Task__c.JobSuite__Revised_Due_Date__c.label,    fieldName: 'JobSuite__Revised_Due_Date__c', type: 'date-local',editable: {fieldName: 'controlEditField'},initialWidth:155,sortable: true,cellAttributes: { class: { fieldName: 'TaskDueDateclass' } ,iconName: 'utility:event', iconAlternativeText: 'Final Due Date' }},
                                     {label: this.tableHeaders.JobSuite__Job_Task__c.JobSuite__Hours__c.label,               fieldName: 'JobSuite__Hours__c', type: 'number',editable: {fieldName: 'controlEditField'},sortable: true,initialWidth:95, cellAttributes: {alignment: 'left', class: { fieldName: 'TaskDueDateclass'}}},                            
                                     {label: this.tableHeaders.JobSuite__Job_Task__c.JobSuite__Completion_Date__c.label,     fieldName: 'JobSuite__Completion_Date__c', type: 'date-local',sortable: true,initialWidth:140,cellAttributes: { iconName: 'utility:event', iconAlternativeText: 'Completion Date' }},
                                     {label: 'Done',                                                                         fieldName: 'JobSuite__Marked_Done__c', type: 'boolean',sortable: true,initialWidth:80,editable: true }
                                     
                                 ];
                }
       
          
            this.ScheCopyColumns = [
                            {label: this.tableHeaders.JobSuite__Job__c.Name.label, fieldName: 'Name', type: 'text'},
                            {label: this.tableHeaders.JobSuite__Job__c.JobSuite__Job_Auto_Number__c.label, fieldName: 'JobSuite__Job_Auto_Number__c', type: 'text'}
                         ];
                      
		}
		else {
			this.error = error;
            console.log('tabletitleerror250==>'+JSON.stringify(error));
		}
	} 

    get TaskDueDateclass(){
        console('csssssssssssssss');
    }

    rowActions(row, doneCallback){
         console.log('row356==='+JSON.stringify(row));
        let actions = [];
        let TaskDoneAction              = {'label': 'Task Done',        'iconName': 'action:approval',      'name': 'Task_Done',    'disabled': row.JobSuite__Marked_Done__c  };
        let AttachFile                  = {'label': 'Attach File',      'iconName': 'action:new_task',      'name': 'FileAttach',   'disabled': row.JobSuite__Marked_Done__c };  
        let CreateApprovalProcessAction = {'label': 'Create Approval Process',  'iconName': 'action:new_task',      'name': 'Create_Approval_Process',  'disabled':row.JobSuite__Marked_Done__c   };
        let TaskOpenAction              = {'label': 'Re-Open',          'iconName': 'utility:close',        'name': 'Task_Open',    'disabled':!row.JobSuite__Marked_Done__c };
        let AddEditAction               = {'label': 'Add/Edit Staff',   'iconName': 'action:edit_groups',   'name': 'Task_AddEdit'   };
        let LogTimeAction               = {'label': 'Log Time',         'iconName': 'action:defer',         'name': 'Task_LogTime','disabled':(row.CST1 || row.JobSuite__Job__r.JobSuite__Status__c!='Active') }; 
        let EditAction                  = {'label': 'Edit',             'iconName': 'utility:edit',         'name': 'Task_Edit'  };
        let InsertAction                = {'label': 'Insert Above',     'iconName': 'utility:arrowup',      'name': 'Task_Above' }; 
        let DeleteAction                = {'label': 'Delete',           'iconName': 'utility:delete',       'name': 'Task_Delete' };

        if(row.createAppStepset0 && row.createAppStepset1==false){
            actions.push(TaskDoneAction,TaskOpenAction,CreateApprovalProcessAction,AddEditAction,EditAction,DeleteAction,InsertAction,LogTimeAction);
        }
        else if(row.createAppStepset1 && row.createAppStepset0==false){
            actions.push(TaskDoneAction,TaskOpenAction,AttachFile,AddEditAction,EditAction,DeleteAction,InsertAction,LogTimeAction);
        }        
        else{
            actions.push(TaskDoneAction,TaskOpenAction,AddEditAction,EditAction,DeleteAction,InsertAction,LogTimeAction);
        }
        setTimeout( () => {  doneCallback( actions ); }, 200 ); // simulate a trip to the server
    }


    handleRowSelection(event) {
        const selectedRows = event.detail.selectedRows;
        const seltaskids = [];
        for (let i = 0; i < selectedRows.length; i++) {
            // console.log('====seletedRows==='+selectedRows[i].Id);
            seltaskids.push(selectedRows[i].Id);
        }
        if(seltaskids.length>0){this.selectedTasksforMarkDone = true ;}
        else{
               this.selectedTasksforMarkDone = false;
            }
        // console.log('taskids888==' + seltaskids);
        this.taskIdList = seltaskids;
    }

    handleTaskRowActions(event){
        const actionName = event.detail.action.name;
        const row = event.detail.row;
         console.log('row==>'+JSON.stringify(row));
         console.log('row==>'+row.Id);
        this.rowID = row.Id;
        switch ( actionName ) {
            case 'Task_Done':
                console.log('Task_Done');
                if( this.JobTaskisUpdateable){
                    this.CompleteTask();
                }
                else{
                    const event = new ShowToastEvent({
                        title: 'Error',
                        message: "Task has insufficient access to edit/update.",
                        variant: 'Error',   
                    });
                    this.dispatchEvent(event);
                }
                break;

            case 'FileAttach':
                console.log('FileAttach');
                this.isFileAttach = true;
                this.getAttachments();
                break;

            case 'Create_Approval_Process':
                console.log('Create_Approval_Process');
                this.isCreateApprovalProcess = true;
                this.getAttachments();
                this.getApprovalSchTemplates();
                console.log('Create_Approval_Process ENd');
                break;

            case 'Task_Open':
              console.log('Task_Open');
                break;

            case 'Task_AddEdit':
               if( this.JobTaskRoleisUpdateable)
               {
                console.log('Task_AddEdit');
                this.isaddEditStaff =true;
                this.AddEditStaff(this.rowID);
               }
                break;

            case 'Task_LogTime':
                if(this.TimesheetEntriesisCreateable){
                    this.isTaskLogTime = true;
                    this.TaskName = row.Name;
                    this.getTaskInformation();
                    this.getTotalHours();
                    this.getRemainHours();
                }
                break;

            case 'Task_Edit':
                if( this.JobTaskisUpdateable)
               {
                console.log('Task_Edit');
                this.isTaskEdit =true;
               }
                break;

            case 'Task_Above':
                if(this.JobTaskisCreateable){
                    this.isAboveInsert = true;
                    console.log('Task_Above');  
                    console.log('Task_Above'+this.isAboveInsert);   
                }
               
                break;

            case 'Task_Delete':
                console.log('Task_Delete');
                this.DeleteTask();  
            break;

            case 'HasApprovals':
                console.log('HasApprovals');
            break;

            default:
        }
    }
    CompleteTask(){
        CompleteTask({ tskid: this.rowID })
            .then((result) => {
                if(result == "OK"){
                    const event = new ShowToastEvent({
                        title: 'success',
                        message: "Task Done Successfully.",
                        variant: 'success',   
                    });
                    this.dispatchEvent(event);
                      refreshApex( this.getListofJobTasks);

                }  
            })
            .catch((error) => {
                const event = new ShowToastEvent({
                    title: 'Error',
                    message: error,
                    variant: 'Error',   
                });
                this.dispatchEvent(event);
            });
        }
        DeleteTask(){
            DeleteTask({ tskid: this.rowID })
                .then((result) => {
                    if(result == "OK"){
                        const event = new ShowToastEvent({
                            title: 'success',
                            message: "Successfully Deleted the Job Task..",
                            variant: 'success',   
                        });
                        this.dispatchEvent(event);
                          refreshApex( this.getListofJobTasks);
                    }  
                })
                .catch((error) => {
                    console.log('4058==>'+error)
                    const event = new ShowToastEvent({
                        title: 'Error',
                        message: error,
                        variant: 'Error',   
                    });
                    this.dispatchEvent(event);
                });
            }
    

    TaskOnLoad(event){
        if(this.rowID){
            const Taskfields = event.detail.records;
            var fields = Taskfields[this.rowID].fields;
            this.isTaskLocked = fields.JobSuite__Locked__c.value;
            console.log('Taskfields==527>'+JSON.stringify(fields));
            console.log('TaskfieldsTemp==>'+ this.template.querySelectorAll());
            console.log('newwwwwwwww',this.isTaskLocked);
        }
    }
    
    TaskOnsubmit(event){
        event.preventDefault(); // Prevent default submit
        const fielddata = event.detail.fields;
        console.log('357_fielddata==>'+JSON.stringify(fielddata));
        if(fielddata.Name == "" || fielddata.Name == null){
            const event = new ShowToastEvent({
                title: 'Error',
                message: "Name Field is required.",
                variant: 'Error',   
            });
            this.dispatchEvent(event);
            return;
        }
        else if(fielddata.JobSuite__Status__c == "" || fielddata.JobSuite__Status__c == null) {
            const event = new ShowToastEvent({
                title: 'Status',
                message: "Status Field is required.",
                variant: 'Error',   
            });
            this.dispatchEvent(event);
            return;
        }
        else if(fielddata.JobSuite__Status__c =='Completed'){
                    if(fielddata.JobSuite__Completion_Date__c == null)
                    {
                        fielddata.JobSuite__Completion_Date__c=this.today;
                    }
                    fielddata.JobSuite__Marked_Done__c = true;
                }
                
        else if(fielddata.JobSuite__Revised_Due_Date__c =='' || fielddata.JobSuite__Revised_Due_Date__c == null){
                    const event = new ShowToastEvent({
                        title: 'Due Date Field',
                        message: 'Due Date Field Field is required.',
                        variant: 'Error',   
                    });
                    this.dispatchEvent(event);
                    return;
        }
        else if(fielddata.JobSuite__Status__c == 'Active' || fielddata.JobSuite__Status__c =='Requested' ){
                    fielddata.JobSuite__Completion_Date__c=null;
                    fielddata.JobSuite__Marked_Done__c = false;
                }
        
        
            
                console.log('fielddataEndSumbit==>'+JSON.stringify(fielddata));
                this.template.querySelector('lightning-record-edit-form').submit(fielddata);
    }
    TaskOnSuccess(){
        console.log('TaskId==>'+this.rowID);
        console.log('UpdateRestDays==>'+this.isDaysChanged);
        console.log('UpdateRestDates==>'+this.isDueDateChanged);
        console.log('UpdateDueDateField==>'+this.isDueDateFieldChanged);
        console.log('UpdateStartDateField==>'+this.isStartDateFieldChanged);

        TaskEditSuccess({ TaskId:this.rowID ,UpdateRestDays:this.isDaysChanged, UpdateRestDates: this.isDueDateChanged, UpdateDueDateField:this.isDueDateFieldChanged , UpdateStartDateField :this.isStartDateFieldChanged })
            .then((result) => {
                if(result =="OK"){
                    this.isDaysChanged = false;
                    this.isDueDateChanged = false;
                    this.isTaskEdit = false;
                    const event = new ShowToastEvent({
                        title: 'Success',
                        message: 'Successfully Updated the Job Task.',
                        variant: 'Success',   
                    }); 
                    this.dispatchEvent(event);
                      refreshApex( this.getListofJobTasks);
                }
            })
            .catch((error) => {
                this.error = error;
            });
        
       
    }

    Rolelistchange(event){
        this.RoleString = event.detail.value;
        console.log('354==>'+this.RoleString);

    }
    TaskAboveOnsubmit(event)
    {
        event.preventDefault(); // Prevent default submit
        const fielddata = event.detail.fields;
        console.log('357_fielddata==>'+JSON.stringify(fielddata));
        fielddata.JobSuite__Job__c = this.recordId;
        if(fielddata.Name == "" || fielddata.Name == null){
            const event = new ShowToastEvent({
                title: 'Error',
                message: "Name Field is required.",
                variant: 'Error',   
            });
            this.dispatchEvent(event);
            return;
        }
        console.log('Roles==>'+ this.template.querySelector("select[id]").value , fielddata.JobSuite__Days__c,this.rowID );
         InsertAboveLoad({ taskid : this.rowID ,days: fielddata.JobSuite__Days__c  , RolesList : this.template.querySelector("select[id]").value })
         .then(result => {
            console.log('InsertAboveLoad==>'+JSON.stringify(result));
            console.log('InsertAboveLoad==>'+result[5]);
            if(result[5] == "true")
                { if(result[4] == 'End Date')
                        {
                            console.log('result[5]==>'+result[5])
                            fielddata.JobSuite__Start_Date__c       = result[1];
                            fielddata.JobSuite__Due_Date__c         =result[2];
                            fielddata.JobSuite__Revised_Due_Date__c =result[2];
                            console.log('fielddata[5]==>'+JSON.stringify(fielddata));
                        }
                    else{
                        fielddata.JobSuite__Start_Date__c       =result[1];
                        fielddata.JobSuite__Due_Date__c         =result[2];
                        fielddata.JobSuite__Revised_Due_Date__c =result[2];  
                        }
                }
            else{ console.log('else rows[5] === '+result[5]);
                    if(result[4] == 'End Date'){
                        console.log('End date === ');
                        fielddata.JobSuite__Start_Date__c = result[2];
                        fielddata.JobSuite__Due_Date__c = result[1];
                        fielddata.JobSuite__Revised_Due_Date__c = result[1];
                    }
                    else{ console.log('start date === ');
                        fielddata.JobSuite__Start_Date__c=result[1];
                        fielddata.JobSuite__Due_Date__c=result[2];
                        fielddata.JobSuite__Revised_Due_Date__c=result[2];  
                    } 
                }
            fielddata.JobSuite__Schedule_Roles__c   = result[3];  
            fielddata.JobSuite__Task_Order__c       = result[0];  
            console.log('===fields last=='+JSON.stringify(fielddata));
            this.template.querySelector('lightning-record-edit-form').submit(fielddata);
            console.log('===fields last==512');
        })
        .catch((error) => {
            console.log('Error40'+JSON.stringify(error));
            const event = new ShowToastEvent({
                title: 'Error',
                message: error,
                variant: 'Error',   
            });
            this.dispatchEvent(event);
        });
        
    
    }
    TaskAboveOnSuccess(event){
        console.log('TaskAboveOnSuccess')
        this.isAboveInsert = false;
        var NewTaskId =event.detail.id;
        InsertAboveSucess({Oldtaskid:this.rowID , NewTaskId:NewTaskId ,strid: this.recordId})
        .then((result) => {
            if(result == "OK"){
                const event = new ShowToastEvent({
                    title: 'success',
                    message: "Task Done Successfully.",
                    variant: 'success',   
                });
                this.dispatchEvent(event);
                  refreshApex( this.getListofJobTasks);
            }
        })
        .catch((error) => {
            const event = new ShowToastEvent({
                title: 'Error',
                message: error,
                variant: 'Error',   
            });
            this.dispatchEvent(event);
        });
    }
    
    TaskBelowOnsubmit(event){
        event.preventDefault(); // Prevent default submit
        const fielddata = event.detail.fields;
        console.log('557_fielddata==>'+JSON.stringify(fielddata));
        fielddata.JobSuite__Job__c = this.recordId;
        if(fielddata.Name == "" || fielddata.Name == null){
            const event = new ShowToastEvent({
                title: 'Error',
                message: "Name Field is required.",
                variant: 'Error',   
            });
            this.dispatchEvent(event);
            return;
        }

        console.log('Roles==>'+ this.template.querySelector("select[id]").value , fielddata.JobSuite__Days__c,this.recordId );
        InsertBelowLoad({ jobid : this.recordId ,days: fielddata.JobSuite__Days__c  , RolesList : this.template.querySelector("select[id]").value })
        .then(result => {
           console.log('InsertAboveLoad==>'+JSON.stringify(result));
                    fielddata.JobSuite__Task_Order__c =result[0];
                    fielddata.JobSuite__Start_Date__c=result[1];
                    fielddata.JobSuite__Due_Date__c=result[2];
                    fielddata.JobSuite__Revised_Due_Date__c=result[2];
                    fielddata.JobSuite__Schedule_Roles__c=result[3];    
                    console.log('===TaskBelowEditForm fields last=='+JSON.stringify(fielddata));
                    this.template.querySelector('lightning-record-edit-form').submit(fielddata);
                    
           
       })
       .catch((error) => {
           console.log('Error40'+JSON.stringify(error));
           const event = new ShowToastEvent({
               title: 'Error',
               message: error,
               variant: 'Error',   
           });
           this.dispatchEvent(event);
       });
    }
    TaskBelowOnSuccess(event)
    {
        this.isBelowInsert =false;
        var NewTaskId =event.detail.id;
        console.log('599'+JSON.stringify(event.detail));
        InsertBlowSucess({Taskid:NewTaskId , strid: this.recordId, task_order_no:event.detail.JobSuite__Task_Order__c,d6:event.detail.JobSuite__Start_Date__c})
        .then((result) => {
            if(result == "OK"){
                const event = new ShowToastEvent({
                    title: 'success',
                    message: "Task Done Successfully.",
                    variant: 'success',   
                });
                this.dispatchEvent(event);
                  refreshApex( this.getListofJobTasks);

            }
        })
        .catch((error) => {
            const event = new ShowToastEvent({
                title: 'Error',
                message: error,
                variant: 'Error',   
            });
            this.dispatchEvent(event);
        });
    }
     

    insertatEnd(){
        if(this.JobTaskRoleisUpdateable){
            this.isBelowInsert =true;

        }
        else{
            const event = new ShowToastEvent({
                title: 'Error',
                message: 'Task has insufficient access to create',
                variant: 'Error',   
            });
            this.dispatchEvent(event);  
        }
    }

   AddEditStaff(rowID){ 
        getStaffWrapperMembers({  TaskId : rowID })
        .then(result => {
            console.log('rowId==>'+JSON.stringify(result));
            this.AllstaffWrappers = result;
        })
        .catch((error) => {
            const event = new ShowToastEvent({
                title: 'Error',
                message: error,
                variant: 'Error',   
            });
            this.dispatchEvent(event);
        });
    }

    async refresh() {
        console.log('refresh')
        await refreshApex(this.taskdata);
        console.log('refresh Done')
    }

   AddStafftoTask(){
    const activityIdsForTracker = [...this.template.querySelectorAll('lightning-input')].filter(element => element.checked).map(element => element.dataset.id);
    //  console.log('*** activityIdsForTracker: ' +activityIdsForTracker);
     const staffWrappers = new Map();
        const staffWrappersids = [];
        const lstaddTeamMembers = [];
        for (let i = 0; i < this.AllstaffWrappers.length; i++) 
        {
            const object = this.AllstaffWrappers[i];
            staffWrappers.set(object.staff.Id , object);
            staffWrappersids.push(object.staff.Id ); 
          }
        for (let i = 0; i < staffWrappersids.length; i++) {
            const stafID = staffWrappersids[i];
            // console.log('this.stafID==>'+stafID);
            if(activityIdsForTracker.includes(stafID))
            {
                console.log('Included or true==>'+stafID)
            if(staffWrappers.get(stafID))
            {
                // console.log('staffWrappersJobTeam.get(stafID)==>'+JSON.stringify(staffWrappers.get(stafID)))
                const staffobj = staffWrappers.get(stafID);
                Object.freeze(staffobj);
                const objCopy = {...staffobj}; 
                console.log('staffobj.selection==>'+objCopy.selection);
                objCopy.selection = true;
                console.log('Updated.selection==>'+objCopy.selection);
                lstaddTeamMembers.push(objCopy);
            }
            }
            else{
                console.log('NotIncluded or false==>'+stafID)
                if(staffWrappers.get(stafID))
                {
                    console.log('staffWrappersJobTeam.get(stafID)==>'+JSON.stringify(staffWrappers.get(stafID)))
                    const staffobj = staffWrappers.get(stafID);
                    Object.freeze(staffobj);
                    const objCopy = {...staffobj}; 
                    console.log('staffobj.selection==>'+objCopy.selection);
                    objCopy.selection = false;
                    console.log('Updated.selection==>'+objCopy.selection);
                    lstaddTeamMembers.push(objCopy);
                }
            }
        }
        // console.log('this.lstaddTeamMembers ==>'+JSON.stringify( lstaddTeamMembers));
        AddStaffToTask({  TaskId : this.rowID ,selectedStaff : JSON.stringify( lstaddTeamMembers)  })
        .then(result => {
            console.log('rowId==>'+result);
            if(result == 'OK')
            {
                const event = new ShowToastEvent({
                    title: 'Success',
                    message: "Updated Staff Members for the Task.",
                    variant: 'success',
                    
                });
                this.dispatchEvent(event);
                this.isaddEditStaff = false;
                refreshApex( this.getListofJobTasks);
            }
            else{
                const event = new ShowToastEvent({
                    title: 'Error',
                    message: result,
                    variant: 'Error',
                    
                });
                this.dispatchEvent(event); 
            }
            this.rowID = [];
            this.isaddEditStaff = false
            this.issave = false;
            
        })
        .catch((error) => {
             const event = new ShowToastEvent({
                title: 'Error',
                message: error,
                variant: 'Error',   
            });
            this.dispatchEvent(event);
            this.rowID = [];
            this.issave = false;
            this.isaddEditStaff = false
        }); 
   }

    MarkSelectedTasks()
    {
        if(this.JobTaskisUpdateable){
            MarkAllSelectedTasks({  taskIdList : this.taskIdList })
            
            .then(result => {
                const res = result;
                console.log ('res'+JSON.stringify(res));
                if(res == 'OK'){
                   
                    const event = new ShowToastEvent({
                        title: 'Success',
                        message: "Marked Done selected Tasks",
                        variant: 'success',
                        
                    });
                    this.dispatchEvent(event);
                      refreshApex( this.getListofJobTasks);
                    this.taskIdList = [];
                    this.selectedRow =[];
                    this.selectedTasksforMarkDone = false;  
                    refreshApex( this.getListofJobTasks);
                   
                } 
            })
            .catch((error) => {
                 const event = new ShowToastEvent({
                    title: 'Error',
                    message: error,
                    variant: 'Error',
                    
                });
                this.dispatchEvent(event);
            });
        }
    }

handlecreateSchedule(){
    if(this.JobTaskisCreateable){
        this.ShowScheduleBtn = true;
        console.log('this.taskdata.length==>'+this.taskdata.length);
        if(this.taskdata.length !=0){
            if(!confirm("This will delete tasks on current schedule and recreate new schedule")){
                console.log('this.taskdata.length==>265');
                this.ShowScheduleBtn = false;
                return false;     
            }
           this.createSchedulefun();
           this.ShowScheduleBtn = false;
        }
        else{  
            this.createSchedulefun();
        }
    }
    else{
        const event = new ShowToastEvent({
            title: 'Error',
            message:'Error, Tasks have insufficient access to create',
            variant: 'Error',
            
        });
        this.dispatchEvent(event);
    }

}

createSchedulefun(){
    createSchedule({  jobId : this.recordId }) 
    .then(result => {
        const res = result;
        console.log ('res'+JSON.stringify(res));
        if(res == 'OK'){
            const event = new ShowToastEvent({
                title: 'success',
                message: 'Successfully Created Task Records.',
                variant: 'success',
                
            });
            this.dispatchEvent(event); 
            refreshApex( this.getListofJobTasks);
        }
    })
    .catch((error) => {
         var error = error; 
         const event = new ShowToastEvent({
            title: 'Error',
            message: error,
            variant: 'Error',
            
        });
        this.dispatchEvent(event);
    });

}

showCalenderView()
    {
        this.ListViewbln = true;
        this.CalenderViewbln = false;
    }
showListView()
    {
        this.ListViewbln = false;
        this.CalenderViewbln = true;
    }

    copySchedule(){
        if(this.JobTaskisCreateable){
            this.isLoading = true;
            this.isCopyOpen = true;
            ShowMultipleCampScheduleCopyJobs({  Cpyid : this.recordId }) 
            .then(result => {
                console.log ('res'+JSON.stringify(result));
                this.ScheCopyJobs = result;
                this.isLoading = false;
                if(this.ScheCopyJobs.length <= 0){
                    this.showScheCopyJobs = false ; 
                 }
            })
            .catch((error) => {
                 var error = error; 
                 const event = new ShowToastEvent({
                    title: 'Error',
                    message: error,
                    variant: 'Error',
                    
                });
                this.dispatchEvent(event);
                this.isLoading = false;
            });
            
        }
        else{
            const event = new ShowToastEvent({
                title: 'Error',
                message:'Error, Tasks have insufficient access to create',
                variant: 'Error',
                
            });
            this.dispatchEvent(event);
        }
    }
    closeModal(){
        this.isCopyOpen=false; 
        this.isaddEditStaff = false;
        this.isTaskEdit = false;
        this.isAboveInsert =false;
        this.isBelowInsert =false;
        this.isTaskLogTime =false;
        this.isCreateApprovalProcess =false;
        this.isFileAttach =false;
        this.rowID = [];
    }

    getSelectedName(event){
        this.copyjoblst = event.detail.selectedRows;
        console.log('this.copyjoblst==>'+this.copyjoblst);
        this.jobcount = this.copyjoblst.length; 
    }

    SavecopySchedule(){
        if(this.copyjoblst!=null){
            console.log('---------394----'); 
            saveRsc({  Cpyid : this.recordId , selectedrecs : this.copyjoblst}) 
            .then(result => {
                console.log ('res'+result);
                if(result == 'OK'){
                    const event = new ShowToastEvent({
                        title: 'success',
                        message: 'Successfully Completed the Copy Schedule for the Selected Jobs.',
                        variant: 'success',
                        
                    });
                    this.dispatchEvent(event);
                    this.isCopyOpen = false;
                    this.copyjoblst = [];
        }
            })
            .catch((error) => {
                 var error = error; 
                 const event = new ShowToastEvent({
                    title: 'Error',
                    message: error,
                    variant: 'Error',
                    
                });
                this.dispatchEvent(event);
                this.isLoading = false;
            }); 
        }
        else{
            const event = new ShowToastEvent({
                title: 'Error',
                message:'Please Select at least one Job to Copy Schedule.',
                variant: 'Error',
                
            });
            this.dispatchEvent(event);
        }
    }
     Editstartdatechanged(event){
        var Date=event.detail;
        console.log('date==>'+JSON.stringify(Date) );
        if(Date){
            this.isStartDateFieldChanged = true;
        }else{
            this.isStartDateFieldChanged =false;
        }

    }

    async EditDueDateChanged(event){
            var Date=event.detail;
            console.log('date==>'+JSON.stringify(Date) );
            if( Date!=null && Date!=''){
            console.log('modalpop==>');
            const result = await myModalforedit.open({
                size: 'small', //small, medium, or large default :medium
                description: 'Accessible description of modal\'s purpose',
                content: 'Open LWC form for get details',
            });
            console.log('modalpop==>'+result);
            if(result == 'Yes'){
                this.isDueDateChanged = true;  
            }
            else if(result == 'No'){
                this.isDueDateChanged   = false;
                this.isDueDateFieldChanged = true;
            }}
    }

    async EditDaysChanged(event){
        var Days=event.detail;
        console.log('date==>'+JSON.stringify(Days));
        if(Days!=null && Days!=''){
        const result = await myModalforedit.open({
            size: 'small', //small, medium, or large default :medium
            description: 'Accessible description of modal\'s purpose',
            content: 'Open LWC form for get details',
        });
        console.log('modalpop==>'+result);
        if(result == 'Yes'){
            this.isDaysChanged = true;  
        }
        else if(result == 'No'){
            this.isDueDateFieldChanged   = false;
            this.isDaysChanged = false;
        }
    }
    }
    printSchedule(){
        window.open('/one/one.app#/alohaRedirect/apex/ScheduleReport?id='+this.recordId,'_blank'); 
    }

    
    getTaskInformation(){
        getTaskInformation({  taskId : this.rowID }) 
                .then(result => {
                    console.log ('result.GL_Code__r.Name'+result.JobSuite__GL_Code__c.Name);
                    console.log ('result.GL_Code__c'+result.JobSuite__GL_Code__c.Id);
                    this.GLCodeName = result.JobSuite__GL_Code__r.Name;
                    this.GLCode = result.JobSuite__GL_Code__r.Id;
                })
                .catch((error) => {
                    console.log ('TotalHourserror'+error);
                }); 
    
    }
    getTotalHours(){
        getTotalHours({  JobNameStr : this.recordId , GLCode : this.GLCode}) 
                .then(result => {
                    console.log ('This.TotalHours'+result);
                    this.TotalHours = result;
                })
                .catch((error) => {
                    console.log ('TotalHourserror'+error);
                }); 
    
            }
    getRemainHours(){
        getRemainHours({ JobNameStr:this.recordId,GLCodeId :this.GLCode,TaskTotalHr:this.TotalHours })
            .then(result => {
                console.log ('This.RemainHours'+result);
                this.RemainHours = result;
            })
            .catch((error) => {
                console.log ('RemainHourserror'+error);
            }); 
    }
    TotalHrs(event){
        console.log(event.target.name + ' now is set to ' + event.target.value);
        if(event.target.name == 'StartWatch' && event.target.value != null )
        {
            this.Starttime = event.target.value;
            // console.log('this.Starttime'  + this.Starttime);
        }
        else if(event.target.name == 'EndWatch' && event.target.value != null)
        {
            this.Endtime = event.target.value;
            // console.log('this.Endtime'  + this.Endtime);
        } 
    
        if(!event.target.value)
            {	
                // console.log('Has Value'); 
                this.isStartEnd = false;
            }
            else
            {
                // console.log('Null');
                this.isStartEnd = true;
            }
            console.log('this.Starttime'  + this.Starttime);
            console.log('this.Endtime'  + this.Endtime);
    
        calcTimeDiff({ StWatch:this.Starttime, EndWatch :this.Endtime})
            .then(result => {
                console.log ('This.TotalHoursWorked==>'+result);
                this.TotalHoursWorked = result;
                if(result!=0){
                    if(result==0.00){ 
                        const event = new ShowToastEvent({
                            title: 'Error',
                            message:'End watch should  be greater than Start watch..',
                            variant: 'Error', 
                        });
                        this.dispatchEvent(event);
                    }              
                }
            })
            .catch((error) => {
                console.log ('TotalHoursWorkederror'+error);
            }); 
    }
    LogTimeSubmit(event){
        event.preventDefault(); // Prevent default submit
        const fielddata = event.detail.fields;
        console.log('Fielddata==>'+JSON.stringify(fielddata));
        if(fielddata.JobSuite__Date__c==null || fielddata.JobSuite__Date__c=='')
            {
                const event = new ShowToastEvent({
                    title: 'Error',
                    message:'Date Field is required.',
                    variant: 'Error',
                    
                });
                this.dispatchEvent(event);
            }
        else{
            fielddata.JobSuite__Job__c = this.recordId;
            fielddata.JobSuite__Task_Name__c = this.TaskName;
            fielddata.JobSuite__GL_Code__c = this.GLCode;
            fielddata.JobSuite__User__c = this.UserId;
            if(this.isStartEnd){
                fielddata.JobSuite__Hours_Worked__c = this.TotalHoursWorked;
            }
            console.log('Fielddata==>'+JSON.stringify(fielddata));
            this.template.querySelector('lightning-record-edit-form').submit(fielddata);
            console.log('submit==>');
        }
    }
    LogTimeSucess(){
        const event = new ShowToastEvent({
            title: 'success',
            message:'Successfully Inserted TimeSheet Record for The Task.',
            variant: 'success',  
        });
        this.dispatchEvent(event);
        this.isTaskLogTime = false;
    }

    
    getAttachments(){
        getAttachments({ recordId: this.recordId })
            .then((result) => {
                console.log('getAttachments==>'+JSON.stringify(result));
                const FileList=[];
                 for(var key in result){
                    FileList.push({ label: result[key] , value:key});
                }
                 console.log('FileList469==>'+JSON.stringify(FileList));
            this.JobFileList = FileList;
            })
            .catch((error) => {
                console.log('getAttachmentsError==>'+JSON.stringify(error));
                const event = new ShowToastEvent({
                    title: 'Error',
                    message: error,
                    variant: 'Error',   
                });
                this.dispatchEvent(event);
            });
    }

    getApprovalSchTemplates(){
        getApprovalSchTemplates()
        .then((result) => {
            console.log('getApprovalSchTemplates==>'+JSON.stringify(result));
            const ApprovalschtempList=[];
             for(var key in result){
                ApprovalschtempList.push({ label: result[key], value:key});
             }
             console.log('ApprovalschtempList==>'+JSON.stringify(ApprovalschtempList));
             this.AppschedTempList = ApprovalschtempList;
        })
        .catch((error) => {
            console.log('getApprovalSchTemplatesError==>'+JSON.stringify(error));
            const event = new ShowToastEvent({
                title: 'Error',
                message: error,
                variant: 'Error',   
            });
            this.dispatchEvent(event);
        });
    }

    handleChangeJobfile(event){
        this.FileId = event.detail.value;
        console.log('this.FileId==>'+this.FileId);
    }
    handleChangeAppProcess(event){
        this.AppSchedTempId = event.detail.value;
        console.log('this.AppSchedTempId==>'+this.AppSchedTempId);
    }

    handlecreateApprovalPro(){
        if(this.FileId!='' && this.AppSchedTempId!='' && this.FileId !='null' && this.AppSchedTempId !='null'){
            console.log('this.FileId==>'+this.FileId);
            console.log('this.AppSchedTempId==>'+this.AppSchedTempId);
            if(this.JobTaskisAccessible){
    
                createApprovalTask({ jobTskId:this.rowID, TaskFileId :this.FileId , AppSchedTemp : this.AppSchedTempId })
                    .then(result => {
                        console.log ('This.TotalHoursWorked==>'+result);
                        if(result =="OK"){
                            const event = new ShowToastEvent({
                                title: 'success',
                                message:'Successfully Created Approval Process.',
                                variant: 'success',  
                            });
                            this.dispatchEvent(event);  
                            isCreateApprovalProcess = false;
                            refreshApex( this.getListofJobTasks);
                            this[NavigationMixin.Navigate]({
                                type: 'standard__recordPage',
                                attributes: {
                                    recordId: this.rowID,
                                    objectApiName: 'JobSuite__Job_Task__c',
                                    actionName: 'view'
                                },
                            });
                            
                        }
                        else{
                            const event = new ShowToastEvent({
                                title: 'Error',
                                message:JSON.stringify(result),
                                variant: 'Error',  
                            });
                            this.dispatchEvent(event);  
                        }
                        this.ShowScheduleBtn = false;
                    })
                    .catch((error) => {
                        const event = new ShowToastEvent({
                            title: 'Error',
                            message:JSON.stringify(error),
                            variant: 'Error',  
                        });
                        this.dispatchEvent(event);    
                    }); 
                
    
            }
            else{
                const event = new ShowToastEvent({
                    title: 'Error',
                    message:'Error, Approval Tasks have insufficient access to create.',
                    variant: 'Error',  
                });
                this.dispatchEvent(event);
            }
        }
        else{
            const event = new ShowToastEvent({
                title: 'Error',
                message:'Error, You must select a file and Template.',
                variant: 'Error',  
            });
            this.dispatchEvent(event);
    
        }
    
    }

    handleFileAttach(){
        if(this.FileId !='' && this.FileId !='null'){
            if(this.JobTaskisUpdateable){
                updateFiletoTask({ jobTskId:this.rowID, TaskFileId :this.FileId })
                .then(result => {
                    console.log ('This.updateFiletoTask==>'+result);
                    if(result =="OK"){
                        const event = new ShowToastEvent({
                            title: 'success',
                            message:'File is attached to the task record.',
                            variant: 'success',  
                        });
                        this.dispatchEvent(event);  
                        refreshApex( this.getListofJobTasks);
                        this[NavigationMixin.Navigate]({
                            type: 'standard__recordPage',
                            attributes: {
                                recordId: this.rowID,
                                actionName: 'view'
                            },
                        });
    
                    }
                    else{
                        const event = new ShowToastEvent({
                            title: 'Error',
                            message:JSON.stringify(result),
                            variant: 'Error',  
                        });
                        this.dispatchEvent(event);  
                    }
                    this.ShowScheduleBtn = false;
                })
                .catch((error) => {
                    const event = new ShowToastEvent({
                        title: 'Error',
                        message:JSON.stringify(error),
                        variant: 'Error',  
                    });
                    this.dispatchEvent(event);    
                }); 
            }
            else{
                const event = new ShowToastEvent({
                    title: 'Error',
                    message:'Error, Approval Tasks have insufficient access to create.',
                    variant: 'Error',  
                });
                this.dispatchEvent(event);
            }
    
        }else{
            const event = new ShowToastEvent({
                title: 'Error',
                message:'Error, You must select a file and Template.',
                variant: 'Error',  
            });
            this.dispatchEvent(event);
    
        }
    }

    handleCellChangeAction(event){
        this.DraftValues = event.detail.draftValues;
        console.log('saveDraftValues==>'+JSON.stringify(this.DraftValues));
        let markdone=false;
        let dayAll=false;
        let reveAll=false;
        
        for (var i = 0; i < this.DraftValues.length; i++) {
            if(this.DraftValues[i].JobSuite__Marked_Done__c !=null){
                markdone=true;
                break;
            }
        }
        for (var i = 0; i < this.DraftValues.length; i++) {
            if(this.DraftValues[i].JobSuite__Days__c !=null || this.DraftValues[i].JobSuite__Revised_Due_Date__c !=null){
                dayAll=true;
                reveAll=true;
                break;
            }
        }
        if( dayAll || reveAll){
            this.template.querySelector("lightning-datatable").draftValues = [];
            if(markdone){
                // this.DraftValues = null;   
            }
            else{
                if(this.JobTaskisUpdateable){ 
                    this.cellChangeValues();  
                }  else{
                    const event = new ShowToastEvent({
                        title: 'Error',
                        message:'Task has insufficient access to edit/update.',
                        variant: 'Error',  
                    }); 
                }
            }
        }    
    }

    async cellChangeValues(event){
        const result = await myModalforedit.open({
            size: 'small', //small, medium, or large default :medium
            description: 'Accessible description of modal\'s purpose',
            content: 'Open LWC form for get details',
        });

        this.totalRecordEdited = this.DraftValues.length;
        this.taskId1=this.DraftValues[0].Id;
        this.days1=this.DraftValues[0].JobSuite__Days__c;
        this.revdate=this.DraftValues[0].JobSuite__Revised_Due_Date__c;
        console.log('====total Records======'+this.totalRecordEdited);
        console.log('==Revised date id=='+this.revdate);
        console.log('==row id=='+this.taskId1);
        console.log('==row days=='+this.days1);
        if(result == 'Yes'){
            console.log('PopupResult==>'+result);
                this.PopupResult = 'true' ;
            if(this.days1 != null){
                this.updateScheduleOnDays();  
            }
            else if(this.revdate !=null){
                this.updateRestSchedule();
            }
        }
        else if(result == 'No'){
            console.log('PopupResult==>'+result);
            this.PopupResult = 'false' ;
            if(this.days1 != null){
                this.updateScheduleOnDays();
            }
            else if(this.revdate !=null){
                this.updateRestSchedule();
            }

        }
    }

    updateScheduleOnDays(){
        console.log('');
        updateScheduleOnDays ({ jobId : this.recordId, taskId1 :this.taskId1 , days1 : this.days1 , updateRestScheduleDays: this.PopupResult })
        .then(result => {
            console.log ('This.updateFiletoTask==>'+result);
            if(result =="OK"){   
               return  refreshApex( this.getListofJobTasks);
            }
            else{
                const event = new ShowToastEvent({
                    title: 'Error',
                    message:JSON.stringify(result),
                    variant: 'Error',  
                });
                this.dispatchEvent(event);  
            }
        })
        .catch((error) => {
            const event = new ShowToastEvent({
                title: 'Error',
                message:JSON.stringify(error),
                variant: 'Error',  
            });
            this.dispatchEvent(event);    
        }); 
    }

    updateRestSchedule(){
        updateRestSchedule ({ jobId : this.recordId, taskId : this.taskId1 , dt : this.revdate , updateRestScheduleRevDt: this.PopupResult })
                .then(result => {
                    console.log ('This.updateFiletoTask==>'+result);
                    if(result =="OK"){
                        return   refreshApex( this.getListofJobTasks);
                        // console.log('Dates Updated success');
                    }
                    else{
                        const event = new ShowToastEvent({
                            title: 'Error',
                            message:JSON.stringify(result),
                            variant: 'Error',  
                        });
                        this.dispatchEvent(event);  
                    }
                })
                .catch((error) => {
                    const event = new ShowToastEvent({
                        title: 'Error',
                        message:JSON.stringify(error),
                        variant: 'Error',  
                    });
                    this.dispatchEvent(event);    
                }); 
    }

    handleSaveEdition(event){
        this.saveDraftValues = event.detail.draftValues;
        console.log('saveDraftValues==>'+JSON.stringify( this.saveDraftValues));
        updateTasksinlineEdit ({ lstJT : this.saveDraftValues })
        .then(result => {
            console.log ('This.updateTasksinlineEdit==>'+result);
            if(result =="true"){
                const event = new ShowToastEvent({
                    title: 'Record Update',
                    message:this.saveDraftValues.length+' Task Records Updated',
                    variant: 'success',  
                });
                this.dispatchEvent(event); 
                this.saveDraftValues = null;   
                return   refreshApex( this.getListofJobTasks);
            }
            else{
                const event = new ShowToastEvent({
                    title: 'Error',
                    message:JSON.stringify(result),
                    variant: 'Error',  
                });
                this.dispatchEvent(event);  
            }
        })
        .catch((error) => {
            const event = new ShowToastEvent({
                title: 'Error',
                message:JSON.stringify(error),
                variant: 'Error',  
            });
            this.dispatchEvent(event);    
        }); 

    }
}