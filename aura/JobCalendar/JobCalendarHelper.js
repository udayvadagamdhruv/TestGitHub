({
    loadDataToCalendar :function(component,data){  
        //var m = moment();
        console.log('>>>>>>>>> 5. load calendar data >>>>>>>>');         
        var job=component.get("v.ShowJobCal");
        var camp=component.get("v.ShowCampCal");
        var task=component.get("v.ShowTaskCal");
        
        var d = new Date();
        var month = d.getMonth()+1;
        var day = d.getDate();
        var currentDate = d.getFullYear() + '/' +
            (month<10 ? '0' : '') + month + '/' +
            (day<10 ? '0' : '') + day;
        
        var self = this;
        var dateval=component.get('v.dateval');
        //console.log('>>>>>>>'+dateval);
        $('#'+dateval).fullCalendar({
            
            customButtons: {
                Print: {
                    text: 'Print',
                    click: function() {
                        
                        document.getElementById('calendarRightPanel').style.display = "block";
                        document.getElementById("searchLeftPanel").style.display = "none";
                        window.print();
                        document.getElementById("searchLeftPanel").style.display = "block";
                        
                    }
                }
            },
            
            header: {
                center: 'prev, title, next, today',
                
                right: 'Print',
                
                left: 'month,basicWeek,basicDay,listMonth'
            },
            
            selectable : true,
            defaultDate: currentDate,
            editable: true,
            eventLimit: true,
            events:data,
            dragScroll : true,
            droppable: true,
            
            eventDrop: function(event, delta, revertFunc) {
                
               console.log('>>>>>>> Event drop Call >>>>>>>>>>>>');
                
                var job=component.get("v.ShowJobCal");
                //console.log('>>>>>>> Job Event drop >>>>>>>>>>>>'+job);
                var camp=component.get("v.ShowCampCal");
                //console.log('>>>>>>> Camp Event drop >>>>>>>>>>>>'+camp);
                var task=component.get("v.ShowTaskCal");
                //console.log('>>>>>>> task Event drop >>>>>>>>>>>>'+task);
                
                //alert(event.title + " was dropped on " + event.start.format());
                
                /*if (!confirm("Do you want to Update this record?")) {
                    revertFunc();
                }
                else{*/
                var eventid = event.id;
                var schedcalc=event.SchedCal;
                var endeventdate;
                var starteventdate;
                
                /*console.log('>>>>Sched Cal stt>>>>>>>>>'+schedcalc);
                console.log('>>>>Start Date Drag stt>>>>>>>>>'+event.start.format());
                console.log('>>>>End Date Drag stt>>>>>>>>>'+event.end);*/
                
                if(job){
                    
                    if(schedcalc=='Start Date')
                    {
                        //console.log('>>>>1');
                        if(event.start!=null && event.end!=null)
                        {
                            //console.log('>>>>1.1');
                            starteventdate = event.start.format();
                            endeventdate = event.end;
                            endeventdate = moment(endeventdate).subtract(1, 'days');
                        }
                        else if(event.start!=null && event.end==null){
                            //console.log('>>>>1.2');
                            starteventdate = event.start.format();
                            endeventdate=null;
                        }
                        
                    }
                    
                    if(schedcalc=='End Date')
                    {
                        //console.log('>>>>2');
                        if(event.start!=null &&  event.end!=null)
                        {
                            //console.log('>>>>2.1');
                            starteventdate = event.start.format();
                            endeventdate = event.end;
                            endeventdate = moment(endeventdate).subtract(1, 'days');
                        }
                        else if(event.start==null && event.end!=null){
                            //console.log('>>>>2.2');
                            starteventdate=null;
                            endeventdate =  event.start.format();
                        }
                            else if(event.start!=null && event.end==null){
                                //console.log('>>>>2.3');
                                starteventdate=null;
                                endeventdate =  event.start.format();
                            }
                        
                    }
                    
                    //console.log('>>>>Start Date Drag>>>>>>>>>'+starteventdate);
                    //console.log('>>>>End Date Drag>>>>>>>>>'+endeventdate);
                    
                    if (!confirm("Would you also like to recreate the schedule?")) {
                        self.editEvent(component,eventid,starteventdate,endeventdate,'false');
                    }
                    else{
                        //console.log('edit---event---');
                        self.editEvent(component,eventid,starteventdate,endeventdate,'true');
                    }                        
                }
                if(camp){
                    var Cmpstarteventdate = event.start.format();
                    var Cmpendeventdate = event.end.format();
                    Cmpendeventdate = moment(Cmpendeventdate).subtract(1, 'days').format();
                    self.editCampEvent(component,eventid,Cmpstarteventdate,Cmpendeventdate);
                }
                if(task){
                    var tskfinalduedateval = event.start.format();
                    if (!confirm("Do you want to update the rest of the schedule?")) {
                        self.edittskEvent(component,eventid,tskfinalduedateval,'false');
                    }
                    else{
                        //console.log('edit---event---');
                        self.edittskEvent(component,eventid,tskfinalduedateval,'true');
                    }  
                    
                }
                
                //}
                
            },
            eventResize: function(event, delta, revertFunc) {
                //alert(event.title + " was dropped on " + event.end.format());
                console.log('>>>>>>> Event Resize Call >>>>>>>>>>>>');
                
                var job=component.get("v.ShowJobCal");
                //console.log('>>>>>>>Job Event Resize>>>>>>>>>>>>'+job);
                var camp=component.get("v.ShowCampCal");
                //console.log('>>>>>>>Camp Event Resize >>>>>>>>>>>>'+camp);
                var task=component.get("v.ShowTaskCal");
                //console.log('>>>>>>>task Event Resize >>>>>>>>>>>>'+task);
                
                if(task){
                    alert('You cannot resize tasks.');
                    revertFunc();
                }
                
                var eventid = event.id;
                var starteventdate = event.start.format();
                var endeventdate = event.end.format();
                endeventdate = moment(endeventdate).subtract(1, 'days').format();
                if(job){
                    // self.editEvent(component,eventid,starteventdate,endeventdate,'');
                    
                    if (!confirm("Would you also like to recreate the schedule?")) {
                        self.editEvent(component,eventid,starteventdate,endeventdate,'','false');
                    }
                    else{
                        //console.log('edit---event---');
                        self.editEvent(component,eventid,starteventdate,endeventdate,'','true');
                    } 
                    
                }
                if(camp){
                    //console.log('edit---event---');
                    self.editCampEvent(component,eventid,starteventdate,endeventdate);
                }
                
            },
            
            dayClick :function(date, jsEvent, view) {
                
                console.log('>>>>>>> day Click Call >>>>>>>>>>>>');
                
                var job=component.get("v.ShowJobCal");
                //console.log('>>>>>>> Job >>>>>>>>>>>>'+job);
                var camp=component.get("v.ShowCampCal");
                //console.log('>>>>>>> Camp >>>>>>>>>>>>'+camp);
                
                /* if (!confirm("Do you want to create a new record?")) {
                    
                }
                else{*/
                
                var datelist = date.format().toString().split('-');
                
                var datetime = new Date(datelist[0],parseInt(datelist[1])-1,parseInt(datelist[2])+1,0,0,0,0);
                
                var months = {jan:'01',feb:'02',mar:'03',apr:'04',may:'05',jun:'06',jul:'07',aug:'08',sep:'09',oct:'10',nov:'11',dec:'12'};
                var b = date.toString().split(' ');
                var d1 = b[3]+'-'+months[b[1].toLowerCase()]+'-'+b[2];
                var d = b[3]+'-'+months[b[1].toLowerCase()]+'-'+b[2];
                //alert('>>>>'+d);
                if(job){
                    //console.log('navigate---event--fire-');
                    var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef : "c:CreateJobfromCalendar",
                        componentAttributes: {
                            startDate : d
                        }
                    });
                    evt.fire();
                }
                if(camp){
                    //console.log('navigate---event--fire-');
                    var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef : "c:CreateCampfromCalendar",
                        componentAttributes: {
                            startDate : d
                        }
                    });
                    evt.fire();
                }
                
                //}
                
            },
            
            /* eventClick: function(event, jsEvent, view) {
                
               var editRecordEvent = $A.get("e.force:editRecord");
                editRecordEvent.setParams({
                    "recordId": event.id
                });
                    editRecordEvent.fire();
                
            },*/
            
            eventMouseover : function(event, jsEvent, view) {
                
                //  console.log('>>>>>>> event Mouseover Call >>>>>>>>>>>>');
                
                var job=component.get("v.ShowJobCal");
                //console.log('>>>>>>>Mouse over event Job >>>>>>>>>>>>'+job);
                var camp=component.get("v.ShowCampCal");
                //console.log('>>>>>>>Mouse over event Camp >>>>>>>>>>>>'+camp);
                var task=component.get("v.ShowTaskCal");
                //console.log('>>>>>>>Mouse over event task >>>>>>>>>>>>'+task);
                
                var schedcal=event.SchedCal;
                //console.log('>>>>>>> sched cal >>>>>>>>>>>>'+schedcal);
                
                var Cdescription=event.CampDesc;
                //console.log('>>>>>>> Campaign Desc >>>>>>>>>>>>'+Cdescription);
                
                var duedate;
                var startdate;
                
                if(schedcal=='Start Date')
                {
                    //console.log('>>>>1');
                    if(event.start!=null && event.end!=null)
                    {
                        //console.log('>>>>1.1');
                        startdate=event.start.format();
                        duedate=event.end.format();
                        duedate = moment(duedate).subtract(1, 'days').format();
                        duedate = duedate.split('T')[0];
                    }
                    else if(event.start!=null && event.end==null){
                        //console.log('>>>>1.2');
                        startdate=event.start.format();
                        duedate='';
                    }
                    
                }
                
                if(schedcal=='End Date')
                {
                    //console.log('>>>>2');
                    if(event.start!=null &&  event.end!=null)
                    {
                        //console.log('>>>>2.1');
                        startdate=event.start.format();
                        duedate=event.end.format();
                        duedate = moment(duedate).subtract(1, 'days').format();
                        duedate = duedate.split('T')[0];
                    }
                    else if(event.start==null && event.end!=null){
                        duedate=event.end.format();
                        duedate = moment(duedate).subtract(1, 'days').format();
                        duedate = duedate.split('T')[0];
                        startdate='';
                    }
                        else if(event.start!=null && event.end==null){
                            //console.log('>>>>2.3');
                            startdate='';
                            duedate=event.start.format();
                        }
                    
                }
                
                if(job){
                    var tooltip = '<div class="tooltipevent" style="box-shadow: 4px 4px 4px 4px '+event.color+';padding:10px;background-color:'+event.color+';color:white;position:absolute;z-index:10001;">' +
                        '<B>Name: </B>' + event.title +
                        '<br>' + '<B>Campaign : </B>' + event.campaign +
                        '<br>' + '<B>Client : </B>' + event.client +
                        '<br>' + '<B>Start Date: </B>' + startdate +
                        '<br>' + '<B>Due Date: </B>' + duedate +
                        '</div>';
                }
                
                if(camp){
                    var enddate=event.end.format();
                    duedate = moment(enddate).subtract(1, 'days').format();
                    duedate = duedate.split('T')[0];
                    
                    var tooltip = '<div class="tooltipevent" style="box-shadow: 4px 4px 4px 4px '+event.color+';padding:10px;background-color:'+event.color+';color:white;position:absolute;z-index:10001;">' +
                        '<B>Name: </B>' + event.title +
                        '<br>' + '<B>Start Date: </B>' + event.start.format() +
                        '<br>' + '<B>End Date: </B>' +duedate +
                        '<br>' + '<B>Description: </B>' +event.CampDesc +
                        '</div>';
                }
                
                if(task){
                    var tooltip = '<div class="tooltipevent" style="box-shadow: 4px 4px 4px 4px '+event.color+';padding:10px;background-color:'+event.color+';color:white;position:absolute;z-index:10001;">' +
                        '<B>Job: </B>' + event.taskJob +
                        '<br>' + '<B>Name: </B>' + event.title +
                        '<br>' + '<B>Due Date: </B>' + event.start.format() +
                        '<br>' + '<B>Campaign: </B>' + event.taskcamp +
                        '<br>' + '<B>Client: </B>' + event.taskclient +
                        '<br>' + '<B>Staff: </B>' + event.staff +
                        '</div>';
                }
                
                //document.getElementsByTagName('body')[]
                //tooltip.appendTo();
                $("body.desktop").append(tooltip);
                $(this).mouseover(function(e) {
                    $(this).css('z-index', 10000);
                    $('.tooltipevent').fadeIn('500');
                    $('.tooltipevent').fadeTo('10', 1.9);
                }).mousemove(function(e) {
                    $('.tooltipevent').css('top', e.pageY + 10);
                    $('.tooltipevent').css('left', e.pageX + 40);
                });
            },
            
            eventMouseout: function(event, jsEvent) {
                $(this).css('z-index', 8);
                $('.tooltipevent').remove();
            },
        });
        
    },
    
    formatFullCalendarData : function(component,events) {
        
        
        
        try{
            
            console.log('>>>>>>>>> 4. Format Full Calendar Data >>>>>>>>'); 
            var josnDataArray = [];
            
            var color=['Blue','BlueViolet','Brown','CadetBlue','Chocolate','Coral','CornflowerBlue','Crimson','DarkBlue','DarkCyan','DarkGoldenRod','DarkGreen','DarkMagenta','DarkOliveGreen',
                       'Black','Darkorange','DarkOrchid','DarkSlateBlue','DarkViolet','DeepPink','DeepSkyBlue','DodgerBlue','FireBrick','ForestGreen','GoldenRod','Gray','Green',
                       'HotPink','IndianRed','Indigo','Magenta','Maroon','MediumBlue','MediumOrchid','MediumPurple','MediumSeaGreen','MediumSlateBlue','MediumVioletRed','MidnightBlue','Navy',
                       'Olive','Orange','OrangeRed','Orchid','PaleVioletRed','Peru','Purple','Red','RoyalBlue','SaddleBrown','Salmon','SandyBrown','SeaGreen','Sienna','SlateBlue',
                       'SteelBlue','Teal','Tomato','OliveDrab','Blue','BlueViolet','Brown','CadetBlue','Chocolate','Coral','CornflowerBlue','Crimson','DarkBlue','DarkCyan','DarkGoldenRod',
                       'DarkGreen','DarkMagenta','DarkOliveGreen','Black','Darkorange','DarkOrchid','DarkSlateBlue','DarkViolet','DeepPink','DeepSkyBlue','DodgerBlue','FireBrick',
                       'ForestGreen','GoldenRod','Gray','Green','HotPink','IndianRed','Indigo','Magenta','Maroon','MediumBlue','MediumOrchid','MediumPurple','MediumSeaGreen','MediumSlateBlue',
                       'MediumVioletRed','MidnightBlue','Navy','Olive','Orange','OrangeRed','Orchid','PaleVioletRed','Peru','Purple','Red','RoyalBlue','SaddleBrown','Salmon','SandyBrown',
                       'SeaGreen','Sienna','SlateBlue','SteelBlue','Teal','Tomato','OliveDrab','Blue','BlueViolet','Brown','CadetBlue','Chocolate','Coral','CornflowerBlue','Crimson',
                       'DarkBlue','DarkCyan','DarkGoldenRod','DarkGreen','DarkMagenta','DarkOliveGreen','Black','Darkorange','DarkOrchid','DarkSlateBlue','DarkViolet','DeepPink',
                       'DeepSkyBlue','DodgerBlue','FireBrick','ForestGreen','GoldenRod','Gray','Green','HotPink','IndianRed','Indigo','Magenta','Maroon','MediumBlue','MediumOrchid','MediumPurple',
                       'MediumSeaGreen','MediumSlateBlue','MediumVioletRed','MidnightBlue','Navy','Olive','Orange','OrangeRed','Orchid','PaleVioletRed','Peru','Purple','Red','RoyalBlue','SaddleBrown',
                       'Salmon','SandyBrown','SeaGreen','Sienna','SlateBlue','SteelBlue','Teal','Tomato','OliveDrab','Blue','BlueViolet','Brown','CadetBlue','Chocolate','Coral','CornflowerBlue',
                       'Crimson','DarkBlue','DarkCyan','DarkGoldenRod','DarkGreen','DarkMagenta','DarkOliveGreen','Black','Darkorange','DarkOrchid','DarkSlateBlue','DarkViolet','DeepPink','DeepSkyBlue',
                       'DodgerBlue','FireBrick','ForestGreen','GoldenRod','Gray','Green','HotPink','IndianRed','Indigo','Magenta','Maroon','MediumBlue','MediumOrchid','MediumPurple','MediumSeaGreen','MediumSlateBlue',
                       'MediumVioletRed','MidnightBlue','Navy','Olive','Orange','OrangeRed','Orchid','PaleVioletRed','Peru','Purple','Red','RoyalBlue','SaddleBrown','Salmon','SandyBrown','SeaGreen',
                       'Sienna','SlateBlue','SteelBlue','Teal','Tomato','OliveDrab','Blue','BlueViolet','Brown','CadetBlue','Chocolate','Coral','CornflowerBlue','Crimson','DarkBlue','DarkCyan','DarkGoldenRod','DarkGreen','DarkMagenta','DarkOliveGreen',
                       'Black','Darkorange','DarkOrchid','DarkSlateBlue','DarkViolet','DeepPink','DeepSkyBlue','DodgerBlue','FireBrick','ForestGreen','GoldenRod','Gray','Green',
                       'HotPink','IndianRed','Indigo','Magenta','Maroon','MediumBlue','MediumOrchid','MediumPurple','MediumSeaGreen','MediumSlateBlue','MediumVioletRed','MidnightBlue','Navy',
                       'Olive','Orange','OrangeRed','Orchid','PaleVioletRed','Peru','Purple','Red','RoyalBlue','SaddleBrown','Salmon','SandyBrown','SeaGreen','Sienna','SlateBlue',
                       'SteelBlue','Teal','Tomato','OliveDrab','Blue','BlueViolet','Brown','CadetBlue','Chocolate','Coral','CornflowerBlue','Crimson','DarkBlue','DarkCyan','DarkGoldenRod',
                       'DarkGreen','DarkMagenta','DarkOliveGreen','Black','Darkorange','DarkOrchid','DarkSlateBlue','DarkViolet','DeepPink','DeepSkyBlue','DodgerBlue','FireBrick',
                       'ForestGreen','GoldenRod','Gray','Green','HotPink','IndianRed','Indigo','Magenta','Maroon','MediumBlue','MediumOrchid','MediumPurple','MediumSeaGreen','MediumSlateBlue',
                       'MediumVioletRed','MidnightBlue','Navy','Olive','Orange','OrangeRed','Orchid','PaleVioletRed','Peru','Purple','Red','RoyalBlue','SaddleBrown','Salmon','SandyBrown',
                       'SeaGreen','Sienna','SlateBlue','SteelBlue','Teal','Tomato','OliveDrab','Blue','BlueViolet','Brown','CadetBlue','Chocolate','Coral','CornflowerBlue','Crimson',
                       'DarkBlue','DarkCyan','DarkGoldenRod','DarkGreen','DarkMagenta','DarkOliveGreen','Black','Darkorange','DarkOrchid','DarkSlateBlue','DarkViolet','DeepPink',
                       'DeepSkyBlue','DodgerBlue','FireBrick','ForestGreen','GoldenRod','Gray','Green','HotPink','IndianRed','Indigo','Magenta','Maroon','MediumBlue','MediumOrchid','MediumPurple',
                       'MediumSeaGreen','MediumSlateBlue','MediumVioletRed','MidnightBlue','Navy','Olive','Orange','OrangeRed','Orchid','PaleVioletRed','Peru','Purple','Red','RoyalBlue','SaddleBrown',
                       'Salmon','SandyBrown','SeaGreen','Sienna','SlateBlue','SteelBlue','Teal','Tomato','OliveDrab','Blue','BlueViolet','Brown','CadetBlue','Chocolate','Coral','CornflowerBlue',
                       'Crimson','DarkBlue','DarkCyan','DarkGoldenRod','DarkGreen','DarkMagenta','DarkOliveGreen','Black','Darkorange','DarkOrchid','DarkSlateBlue','DarkViolet','DeepPink','DeepSkyBlue',
                       'DodgerBlue','FireBrick','ForestGreen','GoldenRod','Gray','Green','HotPink','IndianRed','Indigo','Magenta','Maroon','MediumBlue','MediumOrchid','MediumPurple','MediumSeaGreen','MediumSlateBlue',
                       'MediumVioletRed','MidnightBlue','Navy','Olive','Orange','OrangeRed','Orchid','PaleVioletRed','Peru','Purple','Red','RoyalBlue','SaddleBrown','Salmon','SandyBrown','SeaGreen',
                       'Sienna','SlateBlue','SteelBlue','Teal','Tomato','OliveDrab',
                       'Blue','BlueViolet','Brown','CadetBlue','Chocolate','Coral','CornflowerBlue','Crimson','DarkBlue','DarkCyan','DarkGoldenRod','DarkGreen','DarkMagenta','DarkOliveGreen',
                       'Black','Darkorange','DarkOrchid','DarkSlateBlue','DarkViolet','DeepPink','DeepSkyBlue','DodgerBlue','FireBrick','ForestGreen','GoldenRod','Gray','Green',
                       'HotPink','IndianRed','Indigo','Magenta','Maroon','MediumBlue','MediumOrchid','MediumPurple','MediumSeaGreen','MediumSlateBlue','MediumVioletRed','MidnightBlue','Navy',
                       'Olive','Orange','OrangeRed','Orchid','PaleVioletRed','Peru','Purple','Red','RoyalBlue','SaddleBrown','Salmon','SandyBrown','SeaGreen','Sienna','SlateBlue',
                       'SteelBlue','Teal','Tomato','OliveDrab','Blue','BlueViolet','Brown','CadetBlue','Chocolate','Coral','CornflowerBlue','Crimson','DarkBlue','DarkCyan','DarkGoldenRod',
                       'DarkGreen','DarkMagenta','DarkOliveGreen','Black','Darkorange','DarkOrchid','DarkSlateBlue','DarkViolet','DeepPink','DeepSkyBlue','DodgerBlue','FireBrick',
                       'ForestGreen','GoldenRod','Gray','Green','HotPink','IndianRed','Indigo','Magenta','Maroon','MediumBlue','MediumOrchid','MediumPurple','MediumSeaGreen','MediumSlateBlue',
                       'MediumVioletRed','MidnightBlue','Navy','Olive','Orange','OrangeRed','Orchid','PaleVioletRed','Peru','Purple','Red','RoyalBlue','SaddleBrown','Salmon','SandyBrown',
                       'SeaGreen','Sienna','SlateBlue','SteelBlue','Teal','Tomato','OliveDrab','Blue','BlueViolet','Brown','CadetBlue','Chocolate','Coral','CornflowerBlue','Crimson',
                       'DarkBlue','DarkCyan','DarkGoldenRod','DarkGreen','DarkMagenta','DarkOliveGreen','Black','Darkorange','DarkOrchid','DarkSlateBlue','DarkViolet','DeepPink',
                       'DeepSkyBlue','DodgerBlue','FireBrick','ForestGreen','GoldenRod','Gray','Green','HotPink','IndianRed','Indigo','Magenta','Maroon','MediumBlue','MediumOrchid','MediumPurple',
                       'MediumSeaGreen','MediumSlateBlue','MediumVioletRed','MidnightBlue','Navy','Olive','Orange','OrangeRed','Orchid','PaleVioletRed','Peru','Purple','Red','RoyalBlue','SaddleBrown',
                       'Salmon','SandyBrown','SeaGreen','Sienna','SlateBlue','SteelBlue','Teal','Tomato','OliveDrab','Blue','BlueViolet','Brown','CadetBlue','Chocolate','Coral','CornflowerBlue',
                       'Crimson','DarkBlue','DarkCyan','DarkGoldenRod','DarkGreen','DarkMagenta','DarkOliveGreen','Black','Darkorange','DarkOrchid','DarkSlateBlue','DarkViolet','DeepPink','DeepSkyBlue',
                       'DodgerBlue','FireBrick','ForestGreen','GoldenRod','Gray','Green','HotPink','IndianRed','Indigo','Magenta','Maroon','MediumBlue','MediumOrchid','MediumPurple','MediumSeaGreen','MediumSlateBlue',
                       'MediumVioletRed','MidnightBlue','Navy','Olive','Orange','OrangeRed','Orchid','PaleVioletRed','Peru','Purple','Red','RoyalBlue','SaddleBrown','Salmon','SandyBrown','SeaGreen',
                       'Sienna','SlateBlue','SteelBlue','Teal','Tomato','OliveDrab','Blue','BlueViolet','Brown','CadetBlue','Chocolate','Coral','CornflowerBlue','Crimson','DarkBlue','DarkCyan','DarkGoldenRod','DarkGreen','DarkMagenta','DarkOliveGreen',
                       'Black','Darkorange','DarkOrchid','DarkSlateBlue','DarkViolet','DeepPink','DeepSkyBlue','DodgerBlue','FireBrick','ForestGreen','GoldenRod','Gray','Green',
                       'HotPink','IndianRed','Indigo','Magenta','Maroon','MediumBlue','MediumOrchid','MediumPurple','MediumSeaGreen','MediumSlateBlue','MediumVioletRed','MidnightBlue','Navy',
                       'Olive','Orange','OrangeRed','Orchid','PaleVioletRed','Peru','Purple','Red','RoyalBlue','SaddleBrown','Salmon','SandyBrown','SeaGreen','Sienna','SlateBlue',
                       'SteelBlue','Teal','Tomato','OliveDrab','Blue','BlueViolet','Brown','CadetBlue','Chocolate','Coral','CornflowerBlue','Crimson','DarkBlue','DarkCyan','DarkGoldenRod',
                       'DarkGreen','DarkMagenta','DarkOliveGreen','Black','Darkorange','DarkOrchid','DarkSlateBlue','DarkViolet','DeepPink','DeepSkyBlue','DodgerBlue','FireBrick',
                       'ForestGreen','GoldenRod','Gray','Green','HotPink','IndianRed','Indigo','Magenta','Maroon','MediumBlue','MediumOrchid','MediumPurple','MediumSeaGreen','MediumSlateBlue',
                       'MediumVioletRed','MidnightBlue','Navy','Olive','Orange','OrangeRed','Orchid','PaleVioletRed','Peru','Purple','Red','RoyalBlue','SaddleBrown','Salmon','SandyBrown',
                       'SeaGreen','Sienna','SlateBlue','SteelBlue','Teal','Tomato','OliveDrab','Blue','BlueViolet','Brown','CadetBlue','Chocolate','Coral','CornflowerBlue','Crimson',
                       'DarkBlue','DarkCyan','DarkGoldenRod','DarkGreen','DarkMagenta','DarkOliveGreen','Black','Darkorange','DarkOrchid','DarkSlateBlue','DarkViolet','DeepPink',
                       'DeepSkyBlue','DodgerBlue','FireBrick','ForestGreen','GoldenRod','Gray','Green','HotPink','IndianRed','Indigo','Magenta','Maroon','MediumBlue','MediumOrchid','MediumPurple',
                       'MediumSeaGreen','MediumSlateBlue','MediumVioletRed','MidnightBlue','Navy','Olive','Orange','OrangeRed','Orchid','PaleVioletRed','Peru','Purple','Red','RoyalBlue','SaddleBrown',
                       'Salmon','SandyBrown','SeaGreen','Sienna','SlateBlue','SteelBlue','Teal','Tomato','OliveDrab','Blue','BlueViolet','Brown','CadetBlue','Chocolate','Coral','CornflowerBlue',
                       'Crimson','DarkBlue','DarkCyan','DarkGoldenRod','DarkGreen','DarkMagenta','DarkOliveGreen','Black','Darkorange','DarkOrchid','DarkSlateBlue','DarkViolet','DeepPink','DeepSkyBlue',
                       'DodgerBlue','FireBrick','ForestGreen','GoldenRod','Gray','Green','HotPink','IndianRed','Indigo','Magenta','Maroon','MediumBlue','MediumOrchid','MediumPurple','MediumSeaGreen','MediumSlateBlue',
                       'MediumVioletRed','MidnightBlue','Navy','Olive','Orange','OrangeRed','Orchid','PaleVioletRed','Peru','Purple','Red','RoyalBlue','SaddleBrown','Salmon','SandyBrown','SeaGreen',
                       'Sienna','SlateBlue','SteelBlue','Teal','Tomato','OliveDrab'];
            
            
            var job=component.get("v.ShowJobCal");
            var campai=component.get("v.ShowCampCal");
            var task=component.get("v.ShowTaskCal");
            //newly added for custom settings
            var dataa=component.get("v.data");
            alert('dataa==='+dataa)
            /*console.log('>>>>>>Job>>>>>>>'+job);
            console.log('>>>>>>camp>>>>>>>'+campai);
            console.log('>>>>>>task>>>>>>>'+task);*/
            var Cdesc,title,SchCal,camp,Clnt,startdate,enddate,endate;
            
            
            console.log('>>>>>>>Events Length >>>>>>>>>>>>>>'+events.length);
            //  console.log('>>>>>>>Task Events Length >>>>>>>>>>>>>>'+events.Job_Task__r.length);
            for(var i = 0;i < events.length;i++){
                
                /*console.log('>>>>>>>events>>>>>>>>>>'+JSON.stringify(events[i]));
                console.log('>>>>>>>Tasks'+JSON.stringify(events[i].Job_Task__r));
                console.log('>>>>>>>1startdate'+events[i].Start_Date__c);
                console.log('>>>>>>>1End Date'+events[i].Due_Date__c);*/
           
               
                
                if(job){
                    //newly added for custom settings
                    /*if(dataa=='Start Date'){
                        alert('data==== '+dataa[0].Dates__c);
                        */
                    
                    
                    //console.log('>>>>Job if starts>>>>'+job);
                    
                    if((events[i].Start_Date__c!=null && (events[i].Due_Date__c!=null || events[i].Due_Date__c!=NaN))){
                        //console.log('>>>>>>>Job Start end 1>>>>>>>>');
                        startdate = $A.localizationService.formatDate(events[i].Start_Date__c);
                        //startdate=$A.localizationService.formatDate(events[i].Due_Date__c);
                        endate = $A.localizationService.formatDate(events[i].Due_Date__c);
                        enddate = moment(endate).add(1, 'days');
                    }
                    
                    if((events[i].Start_Date__c!=null && (events[i].Due_Date__c==null || events[i].Due_Date__c==NaN))){
                        //console.log('>>>>>>>Job Start end 2>>>>>>>>');
                        startdate = $A.localizationService.formatDate(events[i].Start_Date__c);
                        enddate =  $A.localizationService.formatDate(events[i].Start_Date__c);
                    }
                    
                    if((events[i].Start_Date__c==null && (events[i].Due_Date__c!=null || events[i].Due_Date__c!=NaN))){
                        //console.log('>>>>>>>Job Start end 3>>>>>>>>');
                        startdate =$A.localizationService.formatDate(events[i].Due_Date__c);
                        enddate = $A.localizationService.formatDate(events[i].Due_Date__c);
                    }
                    
                    if(events[i].JS_Client__r!=null){
                        Clnt=events[i].JS_Client__r.Name;
                    }
                    if(events[i].Campaign__r!=null){
                        camp=events[i].Campaign__r.Name;
                    }
                    if(events[i].Schedule_Calc__c!=null){
                        SchCal=events[i].Schedule_Calc__c;
                    }
                    
                    title=events[i].Name +' - '+ events[i].Job_Auto_Number__c;
                    
                    /*console.log('>>>>>>>Job Name>> '+title);
                    console.log('>>>>>>>Job startdate>> '+startdate);
                    console.log('>>>>>>>Job End Date>> '+enddate);
                    console.log('>>>>>>>Job Client>> '+Clnt);
                    console.log('>>>>>>>Job camp>> '+camp);
                    console.log('>>>>>>>Job SchedCal>> '+SchCal);*/
                    
                    josnDataArray.push({
                        'title':title,
                        'start':startdate,
                        'end':enddate,
                        'id':events[i].Id,
                        'url':'/'+events[i].Id,
                        'allDay':true,
                        'color':color[i],
                        'client': Clnt,
                        'campaign': camp,
                        'SchedCal':SchCal,
                    });
                //}
            }
                
                
                if(campai){
                    
                    //console.log('>>>>campaign if starts>>>>'+campai);
                    
                    title=events[i].Name;
                    if(events[i].Start_Date__c!=null){
                        startdate=$A.localizationService.formatDate(events[i].Start_Date__c);
                    }
                    if(events[i].End_Date__c!=null){
                        // console.log('>>>>>>>Cmp end >>>>>>>>');
                        endate=$A.localizationService.formatDate(events[i].End_Date__c);
                        enddate = moment(endate).add(1, 'days');
                    }
                    if(events[i].Campaign_Description__c!=null){
                        Cdesc=events[i].Campaign_Description__c;
                    }
                    else{
                        Cdesc ='';
                    }
                    
                    /*console.log('>>>>>>>Camp Name>> '+title);
                    console.log('>>>>>>>Camp start Date>> '+startdate);
                    console.log('>>>>>>>Camp End Date>> '+enddate);
                    console.log('>>>>>>>Camp Cdesc>> '+Cdesc);*/
                    
                    josnDataArray.push({
                        'title':title,
                        'start':startdate,
                        'end':enddate,
                        'id':events[i].Id,
                        'url':'/'+events[i].Id,
                        'allDay':true,
                        'color':color[i],
                        'CampDesc':Cdesc,
                    });
                }
                
                
                if(task){
                    
                    //console.log('>>>>task if starts>>>>'+campai);
                    
                    var tskid,tsktitle,tskstartdate,tskenddate,tskjob,tskjobnum,tskjobCamp,tskStaff,tskjobClient;
                    
                    //console.log('>>>>>>>Task Events Length >>>>>>>>>>>>>>'+events[i].Job_Task__r.length);
                    
                    for(var j = 0;j < events[i].Job_Task__r.length;j++)
                    {
                        
                        //console.log('>>>>>>>inner for loop>>>>>>>>'+JSON.stringify(events[i].Job_Task__r[j].Revised_Due_Date__c));
                        
                        tskid=events[i].Job_Task__r[j].Id;
                        tsktitle=events[i].Job_Task__r[j].Name +' - '+ events[i].Job_Task__r[j].Job__r.Job_Auto_Number__c;
                        
                        if(events[i].Job_Task__r[j].Revised_Due_Date__c!=null)
                        {
                            tskstartdate=$A.localizationService.formatDate(events[i].Job_Task__r[j].Revised_Due_Date__c);
                            tskenddate=$A.localizationService.formatDate(events[i].Job_Task__r[j].Revised_Due_Date__c);
                        }
                        
                        if(events[i].Job_Task__r[j].Assigned_Users__c!=null){
                            tskStaff=events[i].Job_Task__r[j].Assigned_Users__c;
                        } 
                        else{
                            tskStaff='';
                        }
                        
                        tskjob=events[i].Job_Task__r[j].Job__r.Name +' - '+ events[i].Job_Task__r[j].Job__r.Job_Auto_Number__c;
                        
                        if(events[i].Job_Task__r[j].Job__r.Campaign__c!=null && events[i].Job_Task__r[j].Job__r.Campaign__c!=undefined){        
                            tskjobCamp=events[i].Job_Task__r[j].Job__r.Campaign__r.Name;
                        }
                        else{
                            tskjobCamp='';
                        }
                        if(events[i].Job_Task__r[j].Job__r.JS_Client__c!=null && events[i].Job_Task__r[j].Job__r.JS_Client__c!=undefined){
                            
                            tskjobClient=events[i].Job_Task__r[j].Job__r.JS_Client__r.Name;
                        }
                        else{
                            tskjobClient='';
                        }
                        
                        josnDataArray.push({
                            'title':tsktitle,
                            'start':tskstartdate,
                            'end':tskenddate,
                            'id':tskid,
                            'url':'/'+events[i].Id,
                            'allDay':true,
                            'color':color[i],
                            'staff':tskStaff,
                            'taskJob':tskjob,
                            'taskcamp':tskjobCamp,
                            'taskclient':tskjobClient,
                        });
                    }
                }
                
                
            }
            
            return josnDataArray;
        }
        catch (e) {
            console.error(e);
            
            var ToastMsg = $A.get("e.force:showToast");
            ToastMsg.setParams({
                "title": "Error!!",
                "type": "error",
                "duration":'4000',
                "message":e.Message
            });
            ToastMsg.fire();
        }
        
    },
    
    /*********************************************Intial(Job) Calendar Event load****************************************************/
    fetchCalenderEvents : function(component, event, helper) {
         //newly added for custommetadata     
            var action = component.get("c.getCustomMetadata");
        	action.setCallback( this, function( response ) {
            var state = response.getState();
            alert('state == '+state);
            if( state === "SUCCESS") {
                var result = response.getReturnValue();
                alert('result' + JSON.stringify(result));
                //console.log( response.getReturnValue() );
                component.set( "v.data", result );
                //var ddd=component.get("v.data");
                //alert('ddd==='+JSON.stringify(ddd));
            }
            
        });
        
        $A.enqueueAction( action );
        //ends
        try{
            
            console.log('>>>>>>>>> 3. Intial(Job) Calendar Event load >>>>>>>>');
            
            console.log('>>>>>>>>>First load spinner event start>>>>>>>>');
            component.set("v.showSpinner", true);
            //component.set("v.selectedCal",'Job Calendar');
            var dateval=component.get('v.dateval');
            //console.log('>dateval>>>>>>>'+dateval);
            
            var JobStatus=component.get("v.JobStatusVal");
            //console.log('>Job Calendar Status>>>>>>>'+JobStatus);
            
            var Camp=component.get("v.CampaignVal");
            //console.log('>Job Calendar Campaign>>>>>>>'+Camp);
            
            var Cnt=component.get("v.ClientVal");
            //console.log('>Job Calendar Client>>>>>>'+Cnt);
            
            var media=component.get("v.MediaVal");
            //console.log('>Job Calendar media>>>>>>'+media);
            
            var Sched=component.get("v.SchedVal");
            //console.log('>Job Calendar Sched>>>>>>'+Sched);
            
            var JobName=component.get("v.JobVal");
            //console.log('>Job Calendar Name>>>>>>>>'+JobName);
            
            var action=component.get("c.getCalJobs");
            action.setParams({
                status:JobStatus,
                Campaign:Camp,
                Client:Cnt,
                Mediatype:media,
                ScheduleTemp:Sched,
                Name:JobName,
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                console.log('>>>>>>>>>>>Job Calendar State>>>>>>>>>>>>>>>>>>'+state);
                if (state === "SUCCESS") {
                    var data= response.getReturnValue();
                    if(data.length > 0)
                    {
                        //console.log('>>>>>>>>>>>Job Calendar Res>>>>>>>>>>>>>>>>>>'+JSON.stringify(data));
                        var josnArr = this.formatFullCalendarData(component,response.getReturnValue());
                        this.loadDataToCalendar(component,josnArr);
                        $('#'+dateval).fullCalendar('rerenderEvents');
                        console.log('>>>>>>>>>First Load spinner event end>>>>>>>>');
                        component.set("v.showSpinner", false);
                        
                    }
                    else{
                        
                        $('#'+dateval).fullCalendar('removeEvents');
                        $('#'+dateval).fullCalendar('rerenderEvents');
                        
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title : 'Info',
                            message: 'No records to display with this search criteria',
                            duration:' 5000',
                            type: 'Info',
                        });
                        toastEvent.fire();
                        console.log('>>>>>>>>>First Load spinner event end>>>>>>>>');
                        component.set("v.showSpinner", false);
                    }
                    
                } else if (state === "ERROR") {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message: response.getReturnValue(),
                        duration:' 5000',
                        type: 'Error',
                    });
                    toastEvent.fire();
                    console.log('>>>>>>>>>First Load spinner event end>>>>>>>>');
                    component.set("v.showSpinner", false);
                }
            });
            
            $A.enqueueAction(action);
            
        }
        catch (e) {
            console.error(e);
        }
    }, 
    
    /*********************************************Campaign Calendar Event****************************************************/
    fetchCampCalenderEvents : function(component, event, helper) {
        try{
            
            console.log('>>>>>>>>> 3. Campaign Calendar Event load >>>>>>>>');
            
            console.log('>>>>>>>>>Campaign spinner event start>>>>>>>>');
            component.set("v.showSpinner", true); 
            
            var dateval=component.get('v.dateval');
            
            var CampStatus=component.get("v.CampStatusVal");
            //console.log('>Campaign Calendar Status>>>>>>>'+CampStatus);
            
            var Name=component.get("v.CampNameVal");
            //console.log('>Campaign Calendar Name>>>>>>>'+Name);
            
            var createdbycmp=component.get("v.Campcreatedbyval");
            //console.log('>Campaign Created by>>>>>>>'+createdbycmp);
            
            var action=component.get("c.getCalCamp");
            action.setParams({
                status:CampStatus,
                Name:Name,
                cmpCreatedby:createdbycmp,
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                console.log('>>>>>>>>>>>Camp Calendar State>>>>>>>>>>>>>>>>>>'+state);
                if (state === "SUCCESS") {
                    var data= response.getReturnValue();
                    if(data.length > 0)
                    {
                        //console.log('>>>>>>>>>>>Camp Calendar Res>>>>>>>>>>>>>>>>>>'+JSON.stringify(data));
                        var josnArr = this.formatFullCalendarData(component,response.getReturnValue());
                        //this.loadDataToCalendar(component,josnArr);
                        
                        //$('#'+dateval).fullCalendar('removeEvents');
                        $('#'+dateval).fullCalendar('addEventSource', josnArr);         
                        //$('#'+dateval).fullCalendar('rerenderEvents');
                        
                        //component.set("v.Objectlist",josnArr);
                        
                        console.log('>>>>>>>>>Campaign spinner event end>>>>>>>>');
                        component.set("v.showSpinner", false); 
                    }
                    else{
                        
                        $('#'+dateval).fullCalendar('removeEvents');
                        //$('#'+dateval).fullCalendar('addEventSource', josnArr);         
                        $('#'+dateval).fullCalendar('rerenderEvents');
                        
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title : 'Info',
                            message: 'No records to display with this search criteria',
                            duration:' 5000',
                            type: 'Info',
                        });
                        toastEvent.fire();
                        console.log('>>>>>>>>>Campaign spinner event end>>>>>>>>');
                        component.set("v.showSpinner", false); 
                    }
                    
                } else if (state === "ERROR") {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message: response.getReturnValue(),
                        duration:' 5000',
                        type: 'Error',
                    });
                    toastEvent.fire();
                    console.log('>>>>>>>>>Campaign spinner event end>>>>>>>>');
                    component.set("v.showSpinner", false); 
                }
            });
            
            $A.enqueueAction(action);
            
        }
        catch (e) {
            console.error(e);
        }
    }, 
    
    /*********************************************Job Calendar Event****************************************************/
    fetchjobEvents : function(component, event, helper) {
        try{
            
            console.log('>>>>>>>>> 3. Job Calendar Event load >>>>>>>>');
            
            console.log('>>>>>>>>>Job spinner event start>>>>>>>>');
            component.set("v.showSpinner", true); 
            
            var dateval=component.get('v.dateval');
            //console.log('>>>>fetch>>job events>'+dateval);
            
            var JobStatus=component.get("v.JobStatusVal");
            //console.log('>Job Calendar Status>>>>>>>'+JobStatus);
            
            var Camp=component.get("v.CampaignVal");
            //console.log('>Job Calendar Campaign>>>>>>>'+Camp);
            
            var Cnt=component.get("v.ClientVal");
            //console.log('>Job Calendar Client>>>>>>'+Cnt);
            
            var media=component.get("v.MediaVal");
            //console.log('>Job Calendar media>>>>>>'+media);
            
            var Sched=component.get("v.SchedVal");
            //console.log('>Job Calendar Sched>>>>>>'+Sched);
            
            var JobName=component.get("v.JobVal");
            //console.log('>Job Calendar Name>>>>>>>>'+JobName);
            
            var action=component.get("c.getCalJobs");
            action.setParams({
                status:JobStatus,
                Campaign:Camp,
                Client:Cnt,
                Mediatype:media,
                ScheduleTemp:Sched,
                Name:JobName,
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                console.log('>>>>>>>>>>>Job Calendar State>>>>>>>>>>>>>>>>>>'+state);
                if (state === "SUCCESS") {
                    var data= response.getReturnValue();
                    if(data.length > 0)
                    {
                        //console.log('>>>>>>>>>>>Job Calendar Res>>>>>>>>>>>>>>>>>>'+JSON.stringify(data));
                        var josnArr = this.formatFullCalendarData(component,response.getReturnValue());
                        //this.loadDataToCalendar(component,josnArr);
                        
                        $('#'+dateval).fullCalendar('addEventSource', josnArr);         
                        
                        //component.set("v.Objectlist",josnArr);
                        console.log('>>>>>>>>>job spinner event end>>>>>>>>');
                        component.set("v.showSpinner", false); 
                    }
                    else{
                        
                        $('#'+dateval).fullCalendar('removeEvents');
                        $('#'+dateval).fullCalendar('rerenderEvents');
                        
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title : 'Info',
                            message: 'No records to display with this search criteria',
                            duration:' 5000',
                            type: 'Info',
                        });
                        toastEvent.fire();
                        console.log('>>>>>>>>>Job spinner event end>>>>>>>>');
                        component.set("v.showSpinner", false); 
                    }
                    
                } else if (state === "ERROR") {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message: response.getReturnValue(),
                        duration:' 5000',
                        type: 'Error',
                    });
                    toastEvent.fire();
                    console.log('>>>>>>>>>Job spinner event end>>>>>>>>');
                    component.set("v.showSpinner", false); 
                }
            });
            
            $A.enqueueAction(action);
            
        }
        catch (e) {
            console.error(e);
        }
    },
    
    
    
    /*********************************************Task Calendar Event****************************************************/
    fetchtskCalenderEvents : function(component, event, helper) {
        try{
            
            console.log('>>>>>>>>> 3. Task Calendar Event load >>>>>>>>'); 
            
            console.log('>>>>>>>>>task spinner event start>>>>>>>>');
            component.set("v.showSpinner", true);
            
            var dateval=component.get('v.dateval');
            //console.log('>>>>>>>'+dateval);
            
            var JobStatus=component.get("v.tskJobStatusVal");
            //console.log('>Task Calendar Status>>>>>>>'+JobStatus);
            
            var Camp=component.get("v.tskCampaignVal");
            //console.log('>Task Calendar Campaign>>>>>>>'+Camp);
            
            var Cnt=component.get("v.tskClientVal");
            //console.log('>Task Calendar Client>>>>>>'+Cnt);
            
            var media=component.get("v.tskMediaVal");
            //console.log('>Task Calendar media>>>>>>'+media);
            
            var Sched=component.get("v.tskSchedVal");
            //console.log('>Task Calendar Sched>>>>>>'+Sched);
            
            var JobName=component.get("v.tskJobVal");
            //console.log('>Task Calendar Job Name>>>>>>>>'+JobName);
            
            var task=component.get("v.taskval");
            //console.log('>Task Calendar Name>>>>>>'+task);
            
            var role=component.get("v.roleval");
            //console.log('>Task Calendar role>>>>>>'+role);
            
            var staff=component.get("v.staffval");
            //console.log('>Task Calendar staff>>>>>>>>'+staff);
            
            var action=component.get("c.getCalTasks");
            action.setParams({
                Jobstatus:JobStatus,
                Campaign:Camp,
                Client:Cnt,
                Mediatype:media,
                ScheduleTemp:Sched,
                JobName:JobName,
                taskName:task,
                taskRole:role,
                staff:staff,
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                console.log('>>>>>>>>>>>Task Calendar State>>>>>>>>>>>>>>>>>>'+state);
                if (state === "SUCCESS") {
                    var data= response.getReturnValue();
                    console.log('>>>>>>Length of Data>>>>>>>>>'+data.length);
                    if(data.length > 0)
                    {
                        //console.log('>>>>>>>>>>>Task Calendar Res>>>>>>>>>>>>>>>>>>'+JSON.stringify(data));
                        var josnArr = this.formatFullCalendarData(component,response.getReturnValue());
                        //this.loadDataToCalendar(component,josnArr);
                        
                        //$('#'+dateval).fullCalendar('removeEvents');
                        $('#'+dateval).fullCalendar('addEventSource', josnArr);         
                        //$('#'+dateval).fullCalendar('rerenderEvents');
                        
                        //component.set("v.Objectlist",josnArr);
                        console.log('>>>>>>>>>task spinner event end>>>>>>>>');
                        component.set("v.showSpinner", false);
                    }
                    else{
                        
                        $('#'+dateval).fullCalendar('removeEvents');
                        //$('#calendar').fullCalendar('addEventSource', josnArr);         
                        $('#'+dateval).fullCalendar('rerenderEvents');
                        
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title : 'Info',
                            message: 'No records to display with this search criteria',
                            duration:' 5000',
                            type: 'Info',
                        });
                        toastEvent.fire();
                        console.log('>>>>>>>>>task spinner event end>>>>>>>>');
                        component.set("v.showSpinner", false);
                    }
                    
                } else if (state === "ERROR") {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message: response.getReturnValue(),
                        duration:' 5000',
                        type: 'Error',
                    });
                    toastEvent.fire();
                    console.log('>>>>>>>>>task spinner event end>>>>>>>>');
                    component.set("v.showSpinner", false);
                }
            });
            
            $A.enqueueAction(action);
        }
        catch (e) {
            console.error(e);
        }
        
    },
    
    /*********************************************** Job update method ************************************************/
    
    editEvent : function(component,eventid,starteventdate,endeventdate,resched){
        try{
            var action=component.get("c.updateJob");
            console.log('edit job method start date>>>>>>>>>>>>'+starteventdate);
            console.log('edit job method End date>>>>>>>>>>>>'+endeventdate);
            action.setParams({ eventid : eventid ,
                              starteventdate : starteventdate,
                              endeventdate  : endeventdate,
                              reschedule:resched
                             });
            
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    
                    
                } else if (state === "ERROR") {
                    
                }
            });
            
            $A.enqueueAction(action);
            
        }
        catch (e) {
            console.error(e);
        }
    },
    
    /*********************************************** Campaign update method ************************************************/
    
    editCampEvent : function(component,eventid,starteventdate,endeventdate){
        try{
            var action=component.get("c.updateCamp");
            console.log('edit campaign method start date>>>>>>>>>>>>'+starteventdate);
            console.log('edit campaign method End date>>>>>>>>>>>>'+endeventdate);
            action.setParams({ eventid : eventid ,
                              starteventdate : starteventdate,
                              endeventdate  : endeventdate
                             });
            
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    
                    
                } else if (state === "ERROR") {
                    
                }
            });
            
            $A.enqueueAction(action);
            
        }
        catch (e) {
            console.error(e);
        }
    },
    
    /*********************************************** Task update method ************************************************/
    
    edittskEvent : function(component,eventid,tskfinalduedateval,recalc){
        try{
            var action=component.get("c.updateTask");
            console.log('edit task method final due date>>>>>>>>>>>>'+tskfinalduedateval);
            action.setParams({ eventid : eventid ,
                              starteventdate : tskfinalduedateval,
                              endeventdate  : tskfinalduedateval,
                              isUpdateAll:recalc,
                             });
            
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    
                } else if (state === "ERROR") {
                    
                }
            });
            
            $A.enqueueAction(action);
            
        }
        catch (e) {
            console.error(e);
        }
    }
    
})