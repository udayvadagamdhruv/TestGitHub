({
    afterScriptsLoaded : function(component, event, helper) {
        var rowActions=[
            {label:'Not WIP', name:'Not_WIP',iconName: 'utility:ban'},
            {label:'Log Time', name:'Log_Time',iconName: 'utility:clock'},
            {label:'Mark Done', name:'Mark_Done',iconName: 'action:approval'}
        ];
        component.set("v.columns",[
            {label:'Job#', fieldName:'JobUrl', type:'url',sortable:true,initialWidth:100, typeAttributes: { label: { fieldName: 'JobNo' }, target: '_self', tooltip:{ fieldName: 'JobNo' } } },
             {label:'Job Name', fieldName:'JobUrl', type:'url',sortable:true, typeAttributes: { label: { fieldName: 'JobName' }, target: '_self', tooltip:{ fieldName: 'JobName' } } },
            {label:'Task Name', fieldName:'Name', type:'text',sortable:true},
            {label:'Start Date', fieldName:'Start_Date__c', type:'text',sortable:true,type: 'date-local',sortable: true,cellAttributes: { iconName: 'utility:event', iconAlternativeText: 'Start Date' }},
            {label:'Due Date', fieldName:'Revised_Due_Date__c', type:'text',sortable:true,type: 'date-local',editable: true,sortable: true,cellAttributes: { iconName: 'utility:event', iconAlternativeText: 'Due Date' }},
            {type: 'action', typeAttributes: { rowActions: rowActions }} 
        ]);
        component.set("v.tscolumns",[
            //{label:'Task', fieldName:'Task_Name__c', type:'text',sortable:true},
            {label:'Staff', fieldName:'TSUserName', type:'text',sortable:true},
            {label:'Date', fieldName:'Date__c', type:'text',sortable:true,type: 'date-local',sortable: true,cellAttributes: { iconName: 'utility:event', iconAlternativeText: 'Date' }},
            {label:'Hours Worked', fieldName:'Hours_Worked__c', type:'number',sortable:true,cellAttributes: {alignment: 'left'}},
            {label: 'Action', type: 'button', initialWidth: 90, typeAttributes: { label: 'Delete',variant:"destructive", name: 'ts_delete', title: 'Click to Delete'}},
        ]);
        console.log('=====Script Loaded successfully===');
        helper.fetchMyWIPTabTasks(component, event, helper,'1','','','','');
        helper.getAllProgressTasks(component, event, helper,'1','','','','');
        helper.fetchFilters(component, event, helper);
        
    },
    
    OnchangeStatus : function(component, event, helper) {
        var taskFilter=component.find("task_status_change").get("v.value");
        var campFilter=component.find("campignIds").get("v.value");
        var sTempFilter=component.find("scheduleIds").get("v.value");
        var StaffFilter=component.find("staffIds").get("v.value");
        var roleFilter=component.find("roleIds").get("v.value");
          
        //var taskFilter=event.getSource().get("v.value");
        helper.fetchMyWIPTabTasks(component, event, helper,taskFilter,campFilter,sTempFilter,StaffFilter,roleFilter);
        helper.getAllProgressTasks(component, event, helper,taskFilter,campFilter,sTempFilter,StaffFilter,roleFilter);
    },
    
    inlinedueDateChanges : function(component, event, helper) {
        var editedRecord=component.find("progessTasksId").get("v.draftValues");
        console.log('=======editedRecords====='+JSON.stringify(editedRecord));
        helper.cellChangeValues(component, event, helper);
    },
    
    NoAction : function(component, event, helper){
        var editedRecord=component.find("progessTasksId").get("v.draftValues");
        var taskId=editedRecord[0].Id;
        var dueDate=editedRecord[0].Revised_Due_Date__c
        console.log('==No taskId==='+taskId);
        console.log('==No dueDate==='+dueDate);
        helper.updateRestSchedule(component, event, helper, taskId, dueDate, false); 
    },
    
    YesAction : function(component, event, helper){
        var editedRecord=component.find("progessTasksId").get("v.draftValues");
        var taskId=editedRecord[0].Id;
        var dueDate=editedRecord[0].Revised_Due_Date__c
        console.log('==Yes taskId==='+taskId);
        console.log('==Yes dueDate==='+dueDate);
        helper.updateRestSchedule(component, event, helper, taskId, dueDate, true); 
    },
    
    sortingForTimeSheets : function(component, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        helper.sortDataForTs(component, fieldName, sortDirection);
    },
    
    updateColumnSorting: function(component, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        helper.sortData(component, fieldName, sortDirection);
    },
    
    rowselection : function(component, event, helper) {
        
        var selRow=event.getParam('selectedRows')[0];
        //console.log('==taskInfo===='+JSON.stringify(selRow));
        //console.log('==Job ID===='+selRow.Job__c);
        //if(selRow.Job_Task_Roles__r){
        component.set("v.taskInformation",selRow);
        
        //}
        
        if(selRow){
            component.set("v.taskId",selRow.Id); 
            $A.createComponent("forceChatter:publisher", {"context":"RECORD", "recordId":selRow.Job__c}, function(publisher) {
                var chatterPublisher = component.find("chatterPublisher");
                if(chatterPublisher){
                    chatterPublisher.set("v.body", publisher);
                }
            });
            $A.createComponent("forceChatter:feed", {"type":"Record", "feedDesign":"DEFAULT", "subjectId":selRow.Job__c}, function(feed) {
                var feedContainer = component.find("feedContainer");
                if(feedContainer){
                    feedContainer.set("v.body", feed);
                }
            });
            
          helper.fetchTimeSheets(component, event, helper,selRow.Id);  
        } 
    },
    
    AddEditStaffMembersforTask: function(component, event, helper){
        component.set("v.isaddEditStaff",true);
        var taskRow=component.get("v.taskInformation");
        component.set("v.taskId", taskRow.Id);
        // setTimeout(function(){
        component.find("AddEditStaffMembers").refreshStaffMembers();
        //},1000);
        
        //component.find("AddEditStaffMembers").refreshStaffMembers();
    },
    
    refetchTaskTeamInfo : function(component, event, helper){
        console.log();
        var taskId=event.getSource().get("v.TaskId");
        if(taskId){
          console.log('=====Application Event fire after the Add/Edit Staff======'+taskId);
           helper.fetchTaskRecordData(component, event, helper,taskId); 
        }
        var taskId1=component.get("v.taskInformation");
        console.log('====JSON task Info===='+JSON.stringify(taskId1));
        if(taskId1){
            console.log('=====Application Event Time Sheets======'+taskId1.Id);
            helper.fetchTimeSheets(component, event, helper,taskId1.Id);
            //component.set("v.timeStheettaskId",null);
        }
    },
    
    rowselectionActions : function(component, event, helper) {
        var action=event.getParam('action');
        var row=event.getParam('row');
        switch(action.name){
            case 'Not_WIP': 
                helper.makeTaskInNotWIP(component, event, helper,row.Id);
                break;
            case 'Log_Time':
                component.set("v.timeStheettaskId", row.Id);
                component.set("v.isTimeSheetOpen", true);
                component.find("timeSheetId").refreshTaskData();
                break;
            case 'Mark_Done':
                helper.makeMarkDone(component, event, helper,row.Id);
                break;
        }
    },
    
    LogTimetoTask :function(component, event, helper) {
        var taskInfo=component.get("v.taskInformation");
        component.set("v.timeStheettaskId", taskInfo.Id);
        component.set("v.isTimeSheetOpen", true);
        component.find("timeSheetId").refreshTaskData();
    },
    
    rowsActionForTimeSheets : function(component, event, helper) {
        var action=event.getParam('action');
        var row=event.getParam('row');
        switch(action.name){
            case 'ts_delete':
                 helper.deleteTimeSheet(component, event, helper,row.Id);
                  break;
        }
    }
})