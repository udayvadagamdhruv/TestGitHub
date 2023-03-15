({
    fetchMyWIPTabTasks : function(component,event,helper,taskFilter,campFilter,sTempFilter,StaffFilter,roleFilter) {
        var action=component.get("c.getMyWIPTasks");
        action.setParams({
            tasksFilter : taskFilter,
            campFilter  : campFilter,
            sTempFilter : sTempFilter,
            StaffFilter : StaffFilter,
            roleFilter  : roleFilter
        });
        action.setCallback(this,function(res){
            console.log('======response====='+res.getState());
            if(res.getState()==="SUCCESS"){
                var data=res.getReturnValue();
                //console.log('======response====='+JSON.stringify(data));
                console.log('======length ====='+data.length);
                var jsonArray=this.formatFullCalendarData(component,data);
                this.loadtoCalenderData(component,event,helper,jsonArray);
                
                $('#calendar').fullCalendar('removeEvents');
                $('#calendar').fullCalendar('addEventSource', jsonArray);         
                $('#calendar').fullCalendar('rerenderEvents');
            }
        }); 
        
        $A.enqueueAction(action);
    },
    
    fetchFilters : function(component,event,helper){
        var action=component.get("c.getFiltersForCalenders");
        action.setCallback(this,function(res){
            console.log('======fetchFilters====='+res.getState());
            console.log('======getReturnValue====='+res.getReturnValue());
            if(res.getState()==="SUCCESS"){
                component.set("v.calenderFilters",res.getReturnValue());
            }
        });
        $A.enqueueAction(action); 
    },
    
    fetchTimeSheets : function(component,event,helper,taskId) {
        var action=component.get("c.getTaskTimeSheets");
        action.setParams({
            taskId : taskId
        });
        action.setCallback(this,function(res){
            console.log('======timesheets====='+res.getState());
            if(res.getState()==="SUCCESS"){
                var rows=res.getReturnValue();
                for(var i=0;i<rows.length;i++){
                    var row=rows[i];
                    if(row.User__r){
                        row.TSUserName=row.User__r.Name;
                    }
                    
                    
                }
                component.set("v.taskTimeSheets", rows);
            }
        });
       $A.enqueueAction(action); 
    },
    
    cellChangeValues : function(component, event, helper) {
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
                                    modalFooter=content;
                                    var OverLayPanel=component.find('overlayLib1').showCustomModal({
                                        header: "Schedule Update",
                                        body: "Do you want to update rest of the Schedule?",
                                        footer: modalFooter,
                                        showCloseButton: true,
                                        cssClass: "mymodal",
                                        closeCallback: function() {
                                            component.find("progessTasksId").set("v.draftValues", null);
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
    
    updateRestSchedule : function(component, event, helper, taskId, dueDate,ss){
        var taskFilter=component.find("task_status_change").get("v.value");
        var campFilter=component.find("campignIds").get("v.value");
        var sTempFilter=component.find("scheduleIds").get("v.value");
        var StaffFilter=component.find("staffIds").get("v.value");
        var roleFilter=component.find("roleIds").get("v.value");
        var action=component.get("c.updateRestSchedule");
        action.setParams({
            taskId :taskId,
            DueDate :dueDate,
            updateRestScheduleRevDt:ss
        });
        action.setCallback(this,function(res){
            console.log('=====Update rest=state====='+res.getState());
            console.log('=====Update rest=response====='+res.getReturnValue());
            if(res.getState()==="SUCCESS"){
                if(res.getReturnValue()=="OK"){
                    component.get('v.overlayPanel').then(
                        function(modal){
                            modal.close();
                        }
                    );
                    helper.fetchMyWIPTabTasks(component, event, helper, taskFilter,campFilter,sTempFilter,StaffFilter,roleFilter);
                    helper.getAllProgressTasks(component, event, helper,taskFilter,campFilter,sTempFilter,StaffFilter,roleFilter);
                }
                else{
                helper.showToastFunction({
                    "title":"Error!!",
                    "type":"error",
                    "message":res.getReturnValue()
                });
            }
            }
            else{
                helper.showToastFunction({
                    "title":"Error!!",
                    "type":"error",
                    "message":res.getReturnValue()
                });
            }
        });
        $A.enqueueAction(action);   
    },
    
    
    fetchTaskRecordData : function (component,event,helper,taskId) {
        var action=component.get("c.fetchUpdatedTaskInformation");
        action.setParams({
            taskId :taskId
        });
        action.setCallback(this,function(res){
            console.log('======response====='+res.getState());
            console.log('======from Applicaton Success====='+JSON.stringify(res.getState()));
            if(res.getState()==="SUCCESS"){
                component.set("v.taskInformation" ,res.getReturnValue());
                component.set("v.isaddEditStaff",false);
            }
        });
        $A.enqueueAction(action);                     
    },
    
    getAllProgressTasks :function(component,event,helper,taskFilter,campFilter,sTempFilter,StaffFilter,roleFilter){
        var action=component.get("c.getAllProgressTasks");
        action.setParams({
            tasksFilter : taskFilter,
            campFilter  : campFilter,
            sTempFilter : sTempFilter,
            StaffFilter : StaffFilter,
            roleFilter  : roleFilter
        });
        action.setCallback(this,function(res){
            console.log('=====Tasks Progress=='+res.getState());
            console.log('=====Tasks Progress==='+JSON.stringify(res.getReturnValue()));
            if(res.getState()==="SUCCESS"){
                var rows=res.getReturnValue();
                for(var i=0;i<rows.length;i++){
                    var row=rows[i];
                    row.JobNo=row.Job__r.Job_Auto_Number__c;
                    row.JobName=row.Job__r.Name;
                    row.JobUrl='/'+row.Job__c;
                    
                }
                component.set("v.progressTasks", rows); 
            }
            else if(res.getState() === "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.showToastFunction({
                            "title":"Error!!",
                            "type":"error",
                            "message":errors[0].message
                        });
                    }
                }
            }
        }); 
        
        $A.enqueueAction(action);
    },
    
    formatFullCalendarData :function(component,taskList){
        var dataArray=[];
        for(var i=0;i<taskList.length;i++){
            dataArray.push({
                title    : taskList[i].title,
                status	 : taskList[i].taskStatus,
                start    : taskList[i].startString,
                end      : taskList[i].endString,
                //url      : taskList[i].url,
                allDay   : true,
                //editable : false,
                color    : taskList[i].color+' !important',
                //textColor: taskList[i].color+' !important',
                jn       : taskList[i].JN,
                client	 : taskList[i].client,
                staff 	 : taskList[i].Staff,
                className: taskList[i].className
            });
        }
        return dataArray;
    },
    
    loadtoCalenderData :function(component,cmpevent,helper,data){
        $('#calendar').fullCalendar({
            header: {
                center: 'prev title next today',
                right:'',
                left: ''
            },
            //timeZone: 'America/New_York',
            defaultView :'basicWeek',
            aspectRatio: 2.5,
            eventLimit: true,
            editable: true,
            themeSystem: 'standard',
            //eventDurationEditable: true,
            //eventStartEditable: true,
            firstDay: 0,
            height: 280,
            events:data,
            eventMouseover : function(event, delta, revertFunc){
                
                var titlepos = event.title.indexOf(",");
                var taskName = event.title.substring(0, titlepos);
                var jobNo = event.title.substring(titlepos+7,event.title.length); 
                
                //Substringing the event JN to get Job Name and campaign name
                var jnpos = event.jn.indexOf(":");
                var campName = event.jn.substring(0, jnpos );
                var jobName = event.jn.substring(jnpos +2,event.jn.indexOf("id="));
                
                var tooltip = '<div class="tooltipevent" style="box-shadow: 4px 4px 4px 4px '+event.color+';padding:10px;background-color:'+event.color+';color:white;position:absolute;z-index:10001;">' +
                    '<B>Job : </B>' + jobName + ' - ' + jobNo + '<br>' +
                    '<B>' + taskName + ' :: ' + event.end.format() + '</B>' + '<br>' +
                    //'<B> End Date ::'+ event.end.format()+'</B><br/>'+
                    '<B>Client : </B>' + event.client + '<br>' +
                    '<B>Campaign: </B>' + campName + '<br>' +
                    '<B>Staff: </B>' + event.staff + '<br>' +
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
            
            eventDrop : function(event, delta, revertFunc){
                var startDate=event.start.format();
                var endDate=event.end.format();
                //console.log(typeof(endDate));
                var TaskId=''+event.className;
                console.log(startDate);
                console.log(endDate);
                helper.taskUpdatebyDragDrop(component,cmpevent,helper,TaskId,startDate,endDate);
                
            },
            eventResize: function(event, delta, revertFunc) {
                var TaskId=''+event.className;
                var endDate=event.end.format();
                helper.taskUpdatewithResizing(component,cmpevent,helper,TaskId,endDate);

            },
            eventRender: function(event, element) { 
                element.bind('dblclick', function() { 
                    var TaskId=''+event.className;
                    if(event.status=="In Progress"){
                        helper.showToastFunction({
                            "type":"info",
                            "message":"This task already added to the My WIP Section"
                        });
                    }else{
                       helper.makeInProgress(component,cmpevent,helper,TaskId);  
                    }
                    
                }); 
            } 
        });       
    },
    
    taskUpdatebyDragDrop : function(component,event,helper,taskId,startDate,endDate){
        var taskFilter=component.find("task_status_change").get("v.value");
        var campFilter=component.find("campignIds").get("v.value");
        var sTempFilter=component.find("scheduleIds").get("v.value");
        var StaffFilter=component.find("staffIds").get("v.value");
        var roleFilter=component.find("roleIds").get("v.value");
        var t=new Date(endDate);
        console.log('========type=='+typeof(taskId));
        var action=component.get("c.taskUpdatebyDragDrop");
        action.setParams({
            taskId:taskId,
            startDate:startDate,
            dueDate:endDate,
            taskFilter:taskFilter
        });
        action.setCallback(this,function(res){
            if(res.getState()=="SUCCESS"){
                if(res.getReturnValue()=="OK"){
                    //helper.fetchMyWIPTabTasks(component, event, helper, taskFilter,campFilter,sTempFilter,StaffFilter,roleFilter);
                    helper.getAllProgressTasks(component, event, helper,taskFilter,campFilter,sTempFilter,StaffFilter,roleFilter);
                    helper.showToastFunction({
                        "type":"success",
                        "message":"Task is Updated with Due date."
                    });
                }
                else{
                    helper.showToastFunction({
                        "title":"Error!!",
                        "type":"error",
                        "message":res.getReturnValue()
                    });
                }
            }
            else{
                    helper.showToastFunction({
                        "title":"Error!!",
                        "type":"error",
                        "message":res.getReturnValue()
                    });
                }
        });
        $A.enqueueAction(action);
    },
    
    
    taskUpdatewithResizing : function(component,event,helper,taskId,endDate){
        var taskFilter=component.find("task_status_change").get("v.value");
        var campFilter=component.find("campignIds").get("v.value");
        var sTempFilter=component.find("scheduleIds").get("v.value");
        var StaffFilter=component.find("staffIds").get("v.value");
        var roleFilter=component.find("roleIds").get("v.value");
        console.log('========type=='+typeof(taskId));
        var action=component.get("c.taskUpdatewithResizing");
        action.setParams({
            taskId:taskId,
            dueDate:endDate
        });
        action.setCallback(this,function(res){
            if(res.getState()=="SUCCESS"){
                if(res.getReturnValue()=="OK"){
                    //helper.fetchMyWIPTabTasks(component, event, helper, taskFilter,campFilter,sTempFilter,StaffFilter,roleFilter);
                    helper.getAllProgressTasks(component, event, helper,taskFilter,campFilter,sTempFilter,StaffFilter,roleFilter);
                    helper.showToastFunction({
                        "type":"success",
                        "message":"Task is Updated with Due date."
                    });
                }
                else{
                    helper.showToastFunction({
                        "title":"Error!!",
                        "type":"error",
                        "message":res.getReturnValue()
                    });
                }
            }
            else{
                    helper.showToastFunction({
                        "title":"Error!!",
                        "type":"error",
                        "message":res.getReturnValue()
                    });
                }
        });
        $A.enqueueAction(action);
    },
    
    makeInProgress : function(component,event,helper,taskId){
        var taskFilter=component.find("task_status_change").get("v.value");
        var campFilter=component.find("campignIds").get("v.value");
        var sTempFilter=component.find("scheduleIds").get("v.value");
        var StaffFilter=component.find("staffIds").get("v.value");
        var roleFilter=component.find("roleIds").get("v.value");
        console.log('=====Make In Progress=='+taskFilter);
        console.log('========type=='+typeof(taskId));
        var action=component.get("c.getProgressTaskstoMyWIp");
        action.setParams({
            taskId:taskId,
            taskFilter:taskFilter,
            campFilter:campFilter,
            sTempFilter:sTempFilter,
            StaffFilter:StaffFilter,
            roleFilter:roleFilter
        });
        action.setCallback(this, function(res){
            console.log('=====Make In Progress=='+res.getState());
            console.log('=====Make In Progress=='+JSON.stringify(res.getReturnValue()));
            if(res.getState()==="SUCCESS"){
                var rows=res.getReturnValue();
                for(var i=0;i<rows.length;i++){
                    var row=rows[i];
                    row.JobNo=row.Job__r.Job_Auto_Number__c;
                    row.JobName=row.Job__r.Name;
                    row.JobUrl='/'+row.Job__c;
                    
                }
                helper.showToastFunction({
                    "type":"success",
                    "message":"Task added succesfully to My WIP Section."
                });
                helper.fetchMyWIPTabTasks(component, event, helper, taskFilter,campFilter,sTempFilter,StaffFilter,roleFilter);
                component.set("v.progressTasks", rows); 
            }
            else if(res.getState() === "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.showToastFunction({
                            "title":"Error!!",
                            "type":"error",
                            "message":errors[0].message
                        });
                    }
                }
            }
            
        });
        
        $A.enqueueAction(action);
    },
    
    makeTaskInNotWIP :function(component,event,helper,taskId){
        var taskFilter=component.find("task_status_change").get("v.value");
        var campFilter=component.find("campignIds").get("v.value");
        var sTempFilter=component.find("scheduleIds").get("v.value");
        var StaffFilter=component.find("staffIds").get("v.value");
        var roleFilter=component.find("roleIds").get("v.value");
        console.log('=====Not In===Progress=='+taskFilter);
        console.log('=====Not In===type=='+typeof(taskId));
        var action=component.get("c.removeTaskFromMyWIpSection");
        action.setParams({
            taskId:taskId,
            taskFilter:taskFilter,
            campFilter:campFilter,
            sTempFilter:sTempFilter,
            StaffFilter:StaffFilter,
            roleFilter:roleFilter
        });
        action.setCallback(this, function(res){
            console.log('=====Make In Progress=='+res.getState());
            console.log('=====Make In Progress=='+JSON.stringify(res.getReturnValue()));
            if(res.getState()==="SUCCESS"){
                var rows=res.getReturnValue();
                for(var i=0;i<rows.length;i++){
                    var row=rows[i];
                    row.JobNo=row.Job__r.Job_Auto_Number__c;
                    row.JobName=row.Job__r.Name;
                    row.JobUrl='/'+row.Job__c;
                    
                }
                
                 helper.showToastFunction({
                    "type":"success",
                    "message":"Task removed succesfully from My WIP Section."
                });
                helper.fetchMyWIPTabTasks(component, event, helper, taskFilter, campFilter, sTempFilter, StaffFilter,roleFilter);
                component.set("v.progressTasks", rows); 
            }
            else if(res.getState() === "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.showToastFunction({
                            "title":"Error!!",
                            "type":"error",
                            "message":errors[0].message
                        });
                    }
                }
            }
            
        });
        
        $A.enqueueAction(action);
    },
    
    
    makeMarkDone :function(component,event,helper,taskId){
        var taskFilter=component.find("task_status_change").get("v.value");
        var campFilter=component.find("campignIds").get("v.value");
        var sTempFilter=component.find("scheduleIds").get("v.value");
        var StaffFilter=component.find("staffIds").get("v.value");
        var roleFilter=component.find("roleIds").get("v.value");
        console.log('=====Not In===Progress=='+taskFilter);
        console.log('=====Not In===type=='+typeof(taskId));
        var action=component.get("c.makeMarkDoneTask");
        action.setParams({
            taskId:taskId,
            taskFilter:taskFilter,
            campFilter:campFilter,
            sTempFilter:sTempFilter,
            StaffFilter:StaffFilter,
            roleFilter:roleFilter
        });
        action.setCallback(this, function(res){
            console.log('=====Mark Done=='+res.getState());
            console.log('=====Mark Done='+JSON.stringify(res.getReturnValue()));
            if(res.getState()==="SUCCESS"){
                var rows=res.getReturnValue();
                for(var i=0;i<rows.length;i++){
                    var row=rows[i];
                    row.JobNo=row.Job__r.Job_Auto_Number__c;
                    row.JobName=row.Job__r.Name;
                    row.JobUrl='/'+row.Job__c;
                    
                }
                helper.showToastFunction({
                    "type":"success",
                    "message":"Task completed successfully."
                });
                helper.fetchMyWIPTabTasks(component, event, helper, taskFilter,campFilter,sTempFilter,StaffFilter, roleFilter);
                component.set("v.progressTasks", rows); 
            }
            else if(res.getState() === "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.showToastFunction({
                            "title":"Error!!",
                            "type":"error",
                            "message":errors[0].message
                        });
                    }
                }
            }
            
        });
        
        $A.enqueueAction(action);
    },
    
    deleteTimeSheet :function(component,event,helper,timeSheetId){
        var taskInfo=component.get("v.taskInformation");
        var action=component.get("c.deleteTimeSheet");
        action.setParams({
            timeSheetId:timeSheetId
        });
        action.setCallback(this,function(res){
            console.log('=====timesheet delete====='+res.getState());
            if(res.getState()==="SUCCESS"){
                if(res.getReturnValue()=="OK"){
                    helper.showToastFunction({
                        "type":"success",
                        "message":"Time Sheet deleted successfully."
                    });
                    if(taskInfo){
                       helper.fetchTimeSheets(component,event,helper,taskInfo.Id); 
                    }
                }
                else{
                    helper.showToastFunction({
                        "title":"Error!!",
                        "type":"error",
                        "message":res.getReturnValue()
                    });
                }
            }
            else{
                    helper.showToastFunction({
                        "title":"Error!!",
                        "type":"error",
                        "message":res.getReturnValue()
                    });
                }
        });
        $A.enqueueAction(action);
    },
    
    showToastFunction: function(params){
        var toastEvent = $A.get("e.force:showToast");
        if(params){
            toastEvent.setParams(params);
            toastEvent.fire();
        }
    },
    sortDataForTs :function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.taskTimeSheets");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse));
        cmp.set("v.taskTimeSheets", data);
    },
    
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.progressTasks");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse));
        cmp.set("v.progressTasks", data);
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
    
})