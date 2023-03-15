({
    loadDataToCalendar :function(component,data){  
        //Find Current date for default date
       
        var d = new Date();
        var month = d.getMonth()+1;
        var day = d.getDate();
        var currentDate = d.getFullYear() + '/' +
            (month<10 ? '0' : '') + month + '/' +
            (day<10 ? '0' : '') + day;
        
         console.log('currentDate'+currentDate);
        var self = this;
        $('#calendar').fullCalendar({
            customButtons: { Print: { text: 'Print', click: function() {  
                window.print(); 
            } } },
            header: {
                center: 'prev title next, today',
                right:'Print',
                left: 'month,basicWeek,basicDay'
            },
            
            //defaultView: 'basicWeek'
            //height:650,
            //contentHeight:600,
            aspectRatio: 2.5,
            editable: true,
            themeSystem: 'jquery-ui',
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
                            self.calenderTaskEdit(component,tskid);
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
                            self.statusChangeUpdate(component,taskDid,tskstatus);
                        }
                        
                    }
                });
                return ['All', event.Tstatus].indexOf($('#task_status_change').val()) >= 0;
                
             },
                
           
            eventDrop: function(event, delta, revertFunc)
            {
                //alert(event.title + " was dropped on " + event.start.format()); 
                if (!confirm("Do you want to Update..!!!!!"))
                {
                    revertFunc();
                }
                else
                {
                     var enddate = $A.localizationService.formatDate(event.start,"YYYY-MM-DD");
                     console.log('==event drop=end date='+enddate);
                       self.TaskDueDateUpdate(component,event.taskid,enddate);
                }
            },
            
           
            eventMouseover: function(calEvent, jsEvent) {
                
                var startdate = $A.localizationService.formatDate(calEvent.start,"YYYY-MM-DD");
                var enddate = $A.localizationService.formatDate(calEvent.end,"YYYY-MM-DD");
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
    
    fetchCalenderEvents : function(component) {
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
                this.loadDataToCalendar(component,josnArr);
                component.set("v.Objectlist",josnArr);
            } else if (state === "ERROR") {
                
            }
        });
        
        $A.enqueueAction(action);
        
    }, 
    
    TaskDueDateUpdate : function(component,taskId,endDate){
        var action=component.get("c.TaskDueDateUpdate");
        action.setParams({ DCalTaskId : taskId ,
                          DcalDueDate : endDate});
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               /* var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "message": "Task Due Date Updated to "+endDate
                });
                toastEvent.fire(); */
                this.fetchCalenderEvents(component);
                
            } else if (state === "ERROR") {
                
            }
        });
        
        $A.enqueueAction(action);
        
    },
    
    statusChangeUpdate : function(component,taskDid,tskstatus){
        var chAction=component.get("c.statusChangeUpdate");
        chAction.setParams({ DTaskId : taskDid ,
                          DTaskStatus : tskstatus});
        
        chAction.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue()=='OK'){
                    console.log('=========='+response.getReturnValue());
                     //$('#calendar').fullCalendar('removeEvents');
                     //$('#calendar').fullCalendar("rerenderEvents");
                     //$('#calendar').fullCalendar("refetchEvents");
                    
                    this.fetchCalenderEvents(component);
                   
                    //alert('completed');
                  /*  var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "success",
                        "message": "The record has been updated successfully."
                    });
                    toastEvent.fire(); */
                    
                }
                else{
                  /*  var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type" :"error",
                        "message" : response.getReturnValue()
                    });
                     toastEvent.fire();   */
                }
            } else if (state === "ERROR") {
                
            }
        });
        
        $A.enqueueAction(chAction);
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
})