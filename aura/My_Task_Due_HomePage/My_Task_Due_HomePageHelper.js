({
    fetchFieldLabels : function(component, event , helper){
        var rowActions = helper.getRowActions.bind(this, component);
        var action=component.get("c.getObjectFieldLabels");
        action.setParams({
            ObjNames:['Job_Task__c','Job__c']
        });
        
        action.setCallback(this, function(res){
            if(res.getState() === "SUCCESS"){
                var tableHeaders=JSON.parse(res.getReturnValue());
                console.log('===Job_Task__c and JOb====='+JSON.stringify(JSON.parse(res.getReturnValue())));
                //component.set("v.ObjectType",JSON.parse(res.getReturnValue()));
                
                component.set("v.columns",[
                    // { label: 'Color', fieldName: 'Color'},  
                    { type: 'action', typeAttributes: {rowActions: rowActions}},
                    { label: tableHeaders.Job_Task__c.Job__c.label, fieldName: 'JobId', editable: true, sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'JobName' }, target: '_self' , tooltip:{ fieldName: 'JobName' }}},
                    { label: tableHeaders.Job_Task__c.Name.label, fieldName: 'TaskId', sortable: true, type: 'url',cellAttributes: {class: { fieldName: "TaskColorcode" } }, typeAttributes: { label: { fieldName: 'TaskName' }, target: '_self', tooltip:{ fieldName: 'TaskName' }}},
                    { label: tableHeaders.Job_Task__c.Revised_Due_Date__c.label, fieldName: 'TaskDue', type: 'date-local', sortable: true, cellAttributes: { iconName: 'utility:event', iconAlternativeText: tableHeaders.Job_Task__c.Revised_Due_Date__c.label} },
                    { label: tableHeaders.Job__c.Job_Auto_Number__c.label, fieldName: 'JobIdNo', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'JobNum' }, target: '_self', tooltip:{ fieldName: 'JobNum' }}}
                    
                ]);
            }
            else{
                console.log('>>>>>> Error >>>>>>>>>>',res.getError()[0].message);
                var errors = res.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action); 
    },
    
    MyTaskrecordsfetch : function(component, event,helper,taskview) {
        console.log('>>>>>>>>>MyTaskrecordsfetch>>>>>>>>>>>');
        //var taskview=$('#TaskVId').val();
        //var taskview=component.find("TaskVId").get("v.value");;
        //alert('>>>>>>>>>taskview>>>>>>>>>>>'+taskview);
        
        var action = component.get("c.getMyTaskData");
        action.setParams({
            tasksview:taskview
        })
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            var rows=response.getReturnValue();
            console.log('>>>>>>>>>>>Taskssssssssssss>>>>>>>>>>>>>>>'+JSON.stringify(rows));
            
            if (state === "SUCCESS") {
                for (var i = 0; i < rows.length; i++) {
                    
                    console.log('>>>>>>>>>>>>>>>>rows.length>>>>>>>>>>>>>>>>'+rows.length);
                    var row = rows[i];
                    console.log('>>>>>>>>>>>>'+JSON.stringify(row));
                    row.Color= row.color;
                    row.JobId= '/'+row.jobTaskrole.Job_Task__r.Job__r.Id;
                    row.JobIdNo= '/'+row.jobTaskrole.Job_Task__r.Job__r.Id;
                    row.TaskId= '/'+row.jobTaskrole.Job_Task__r.Id;
                    
                    row.JobName=row.jobTaskrole.Job_Task__r.Job__r.Name;
                    /* if(row.color=='Green')
                    {
                      row.TaskName=row.jobTaskrole.Job_Task__r.Name;
                      $A.util.addClass(row.TaskName, 'textClassGreen');
                    }*/
                    row.TaskColorcode=row.color+'_color';
                    row.TaskName=row.jobTaskrole.Job_Task__r.Name;
                    row.TaskDue=row.jobTaskrole.Job_Task__r.Revised_Due_Date__c;
                    row.JobNum=row.jobTaskrole.Job_Task__r.Job__r.Job_Auto_Number__c;
                }
                component.set("v.data",rows);
            }else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                var ToastMsg = $A.get("e.force:showToast");
                ToastMsg.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message                
                });
                ToastMsg.fire();
            }
        });
        
        var TSAccess = component.get("c.getisAccessable");
        TSAccess.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                console.log('TS Accessable'+response.getReturnValue());
                component.set("v.TSAccessable",response.getReturnValue());
            }
            else{
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                });
                toastEvent.fire();
                
            }
            
        });
        
        $A.enqueueAction(TSAccess);
        $A.enqueueAction(action);
    },
    
    getRowActions: function (component, row, doneCallback) {
        var actions = [];
        
        var TaskDoneAction = {
            'label': 'Task Done',
            'iconName': 'action:approval',
            'name': 'Task_Done'
        };
        
        var TimesheetAction = {
            'label': 'Log Time',
            'iconName': 'action:defer',
            'name': 'Timesheet_Entry',
            'disabled':!component.get("v.TSAccessable")
        };
        
        
        actions.push(TaskDoneAction,TimesheetAction);
        // simulate a trip to the server
        setTimeout($A.getCallback(function () {
            doneCallback(actions);
        }), 200);
    },
    
    TaskDone: function(component, event, helper, selectTskId){
        var taskview=component.find("TaskVId").get("v.value");
        // alert(taskview);
        console.log('===Task Done==');
        var TSKDone=component.get("c.assignMarkedDone");
        
        if(selectTskId!=null || selectTskId!=undefined){
            TSKDone.setParams({
                strJTID :selectTskId
            });
        }
        else{
            var row = event.getParam('row');
            console.log('===Task Id=='+row);  
            TSKDone.setParams({
                strJTID :row.jobTaskrole.Job_Task__r.Id
            });
            console.log('===TSK Done Id=='+row.Id);
        }  
        TSKDone.setCallback(this, function(Taskres){
            var Tskstate = Taskres.getState();
            console.log('===Tskstate=='+Tskstate);
            if(Tskstate === "SUCCESS"){
                if(Taskres.getReturnValue() === 'OK')
                {
                    helper.MyTaskrecordsfetch(component, event, helper,taskview);
                    var ToastMsg = $A.get("e.force:showToast");
                    ToastMsg.setParams({
                        "type": "success",
                        "message":'Task has completed successfully'
                    });
                    ToastMsg.fire();
                }
                else
                {
                    var ToastMsg = $A.get("e.force:showToast");
                    ToastMsg.setParams({
                        "title": "Error!!",
                        "type": "error",
                        "message":Taskres.getReturnValue()
                    });
                    ToastMsg.fire();
                    
                }
            }
            else
            {
                var ToastMsg = $A.get("e.force:showToast");
                ToastMsg.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message":Taskres.getReturnValue()
                });
                ToastMsg.fire();
                
            }
        });
        $A.enqueueAction(TSKDone);  
    },
    
    
    
    
    loadDataToCalendar : function(component,cmpEvent,cmphelper,data){  
        console.log('========caldender data========'+JSON.stringify(data));
        var d = new Date();
        var month = d.getMonth()+1;
        var day = d.getDate();
        var currentDate = d.getFullYear() + '/' +
            (month<10 ? '0' : '') + month + '/' +
            (day<10 ? '0' : '') + day;
        
        console.log('currentDate'+currentDate);
        var self = this;
        $('#HomeCalender').fullCalendar({
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
            eventLimit: true, // this will limits the tasks based on the cell height
            //editable: true, // it allows both resizing and dropping
            //themeSystem: 'jquery-ui',
            eventDurationEditable: false, // allow event resizning edit
            eventStartEditable: true, // allow droping edit
            firstDay: 1, // Sun-0,Mon-1
            height: 600, // Calender height
            contentHeight: 750, // cell height
            events:data,
            
            eventDrop: function(event, delta, revertFunc)
            {
                //alert('Event start date ::::::'+event.start.format());
                //alert('Event end date ::::::'+event.end.format());
                if (!confirm("Do you want to Update..!!!!!"))
                {
                    revertFunc();
                }
                else
                {
                    // alert('Invoked...Start....Task...........'+event.start.format());
                    // alert('Invoked...End....Task...........'+event.end.format());
                    
                    var startdate = event.start.format();
                    var enddate = event.end.format();
                    var jn1 = event.jn;
                    self.TaskDueDateUpdate(component,cmpEvent,cmphelper,startdate,enddate,jn1);
                    
                }
            },
            
            eventMouseover: function(event, jsEvent) {
                //console.log('===event====='+JSON.stringify(event));
                // event.title = event.title.split(' - ')[0]+', Job - # '+event.title.split(' - ')[1];
                //console.log('===event====='+event.title.substring(0, 3));
                var titlepos = event.title.indexOf(",");
                var taskName = event.title.substring(0, titlepos);
                var jobNo = event.title.substring(titlepos+7,event.title.length); 
                
                //Substringing the event JN to get Job Name and campaign name
                var jnpos = event.jn.indexOf(":");
                var campName = event.jn.substring(0, jnpos );
                var jobName = event.jn.substring(jnpos +2,event.jn.indexOf("id="));
                var tooltip = '<div class="tooltipevent" style="box-shadow: 4px 4px 4px 4px '+event.color+';padding:10px;background-color:'+event.color+';color:white;position:absolute;z-index:10001;">' +
                    '<B>Job : </B>' + jobName + ' - ' + jobNo + '<br>' +
                    '<B>' + taskName + ' :: ' + event.start.format() + '</B>' + '<br>' +
                    '<B>Client : </B>' + event.client + '<br>' +
                    '<B>Campaign: </B>' + campName + '<br>' +
                    '<B>Staff: </B>' + event.staff + '<br>' +
                    '</div>';
                
                var $tooltip = $(tooltip).appendTo('body.desktop');
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
                
                title: tasks[i].title,
                start: tasks[i].startString,
                end: tasks[i].endString,
                //taskid: tasks[i].TaskId,
                //Tstatus: tasks[i].Tstatus,
                url: tasks[i].Url,
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
        //var taskview=component.find("TaskViewId").get("v.value");
        var taskview=$('#TaskViewId').val();
        console.log(taskview);
        var action=component.get("c.getMyDueTasksOnCalender");
        action.setParams({
            tasksview:taskview
        })
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var data= response.getReturnValue();
                console.log('>>>>>>>>>>>>>>>>data.length>>>>>>>>>>>>>>>>'+data.length);
                console.log('========='+JSON.stringify(data));
                var josnArr = this.formatFullCalendarData(component,response.getReturnValue());
                this.loadDataToCalendar(component,cmpEvent,cmphelper,josnArr);
                $('#HomeCalender').fullCalendar('removeEvents');
                $('#HomeCalender').fullCalendar('addEventSource', josnArr);         
                $('#HomeCalender').fullCalendar('rerenderEvents');
            } else if (state === "ERROR") {
                console.log('====error==',response.getError()[0].message);
                var errors = response.getError();
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                });
                toastEvent.fire();
            }
        });
        
        $A.enqueueAction(action);
        
    }, 
    
    TaskDueDateUpdate : function(component,cmpEvent,cmphelper,startdate,enddate,jn1){
        var action=component.get("c.TaskDueDateUpdateFromHomePage");
        action.setParams({
            strdate:startdate,
            enddate:enddate,
            JN:jn1
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                if(response.getReturnValue()=="OK"){
                    var ToastMsg = $A.get("e.force:showToast");
                    ToastMsg.setParams({
                        "type": "success",
                        "message":"Task Start and Due Dates are Updated"
                    });
                    ToastMsg.fire();
                    cmphelper.fetchCalenderEvents(component, cmpEvent, cmphelper);
                }
                else{
                    var ToastMsg = $A.get("e.force:showToast");
                    ToastMsg.setParams({
                        "title": "Error!!",
                        "type": "error",
                        "message":response.getReturnValue()
                    });
                    ToastMsg.fire();
                }
                
            }else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                var ToastMsg = $A.get("e.force:showToast");
                ToastMsg.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message                
                });
                ToastMsg.fire();
                
            }
        });
        $A.enqueueAction(action);
        
    },
    
    
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.data");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        //data.sort(this.sortBy(fieldName, reverse))
        if(fieldName=='JobId'){
            data.sort(this.sortBy('JobName', reverse))
        }
        else if(fieldName=='TaskId'){
            data.sort(this.sortBy('TaskName', reverse))
        }
            else if(fieldName=='JobIdNo'){
                data.sort(this.sortBy('JobNum', reverse))
            }
                else{
                    data.sort(this.sortBy(fieldName, reverse))
                }
        cmp.set("v.data", data);
    },
    sortBy: function (field, reverse, primer) {
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