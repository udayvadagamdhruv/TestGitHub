({
    
    fetchFieldLabels : function(component, event , helper){
        var action=component.get("c.getObjectFieldLabels");
        action.setParams({
            ObjNames:['Job_Task__c','Job__c']
        });
        
        action.setCallback(this, function(res){
            if(res.getState() === "SUCCESS"){
                var tableHeaders=JSON.parse(res.getReturnValue());
                console.log('===Job_Task__c and JOb====='+JSON.stringify(JSON.parse(res.getReturnValue())));
                component.set("v.ObjectType",JSON.parse(res.getReturnValue()));
            }
            else {
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
    
    fetchfiltervaluesandcustomsettingsdata : function(component, event, helper) {
        var action = component.get("c.getfiltervals");
        action.setCallback(this, function(response) {
            var state = response.getState();
            var rows=response.getReturnValue();
            // alert('>>rows>>>'+JSON.stringify(rows.jobwrp));
            if (state === "SUCCESS") {
                component.set("v.StaffsNames",rows.stfwrp);
                component.set("v.RolesNames",rows.rolewrp);
                component.set("v.ClientNames",rows.clientwrp);
                component.set("v.JobNames",rows.jobwrp);
                //component.set("v.fileattach",rows.custmsettingboolean);
                // component.set("v.taskdata",rows.jbtkwrp);
            }
            else {
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
        var actionaccess = component.get("c.getisAccessable");
        actionaccess.setCallback(this, function(response) {
            var state = response.getState();
            var access=response.getReturnValue();
            if (state === "SUCCESS") {
                component.set('v.JobDetailAccessible',access);  
            }
            else {
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
        var ctm = component.get("c.CustomSettingvalues");
        ctm.setCallback(this, function(response) {
            var state = response.getState();
            var vals=response.getReturnValue();
            // alert('>>rows>>>'+JSON.stringify(vals));
            if (state === "SUCCESS") {
                // alert(vals);
                if(vals == true){
                    component.set('v.fileattach',true);
                }
                else{
                    component.set('v.fileattach',false);
                    /* var ToastMsg = $A.get("e.force:showToast");
                    ToastMsg.setParams({
                        "title": "Error!!",
                        "type": "error",
                        "message": 'No access to upload job task file.'              
                    });
                    ToastMsg.fire();*/    
                }
            }
            else {
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
        $A.enqueueAction(ctm);
        $A.enqueueAction(actionaccess);
        $A.enqueueAction(action);
    },
    
    sortBy: function(component, event, sortFieldName) {
        
        var currentDir = component.get("v.arrowDirection");
        if (currentDir == 'arrowdown') {
            // set the arrowDirection attribute for conditionally rendred arrow sign  
            component.set("v.arrowDirection", 'arrowup');
            // set the isAsc flag to true for sort in Assending order.
            component.set("v.sortAsc", true);  
            component.set("v.sortField", sortFieldName);
        } else {
            component.set("v.arrowDirection", 'arrowdown');
            component.set("v.sortAsc", false);
            component.set("v.sortField", sortFieldName);
        }
        // call the onLoad function for call server side method with pass sortFieldName
        this.onSortResult(component, event, sortFieldName);
    },
    
    onSortResult: function(component, event, sortField) {
        console.log('sortField--->'+sortField)
        var result=[];
        result=component.get("v.taskdata");
        var key = function(a) {
            if(sortField == 'Job_Task__r.Name'){
                console.log('sorting--'+a['Job_Task__r']['Name'])
                return a['Job_Task__r']['Name'];
            }
            else if(sortField == 'Job_Task__r.Job__r.Name'){
                console.log('sorting--'+a['Job_Task__r']['Job__r']['Name'])
                return a['Job_Task__r']['Job__r']['Name'];
            }
                else if(sortField == 'Job_Task__r.Job__r.Job_Auto_Number__c'){
                    console.log('sorting--'+a['Job_Task__r']['Job__r']['Job_Auto_Number__c'])
                    return a['Job_Task__r']['Job__r']['Job_Auto_Number__c'];
                }
                    else if(sortField == 'Job_Task__r.Revised_Due_Date__c'){
                        console.log('sorting--'+a['Job_Task__r']['Revised_Due_Date__c'])
                        return a['Job_Task__r']['Revised_Due_Date__c'];
                    }
                        else if(sortField == 'Job_Task__r.Job__r.Next_Tasks_Due__c'){
                            console.log('sorting--'+a['Job_Task__r']['Job__r']['Next_Tasks_Due__c'])
                            return a['Job_Task__r']['Job__r']['Next_Tasks_Due__c'];
                        }
                            else if(sortField == 'Job_Task__r.Job__r.Campaign__r.Name'){
                                /* console.log('sorting--'+a['Job_Task__r']['Job__r']['Campaign__r']['Name'])
                        return a['Job_Task__r']['Job__r']['Campaign__r']['Name'];   */    
                                console.log('sorting--'+a['campaignrcd']);
                                return a['campaignrcd'];    
                            }
                                else if(sortField == 'Job_Task__r.Job__r.JS_Client__r.Name'){
                                    console.log('sorting--'+a['clientrcd']);
                                    return a['clientrcd'];  
                                }
                                    else{
                                        return a[sortField];
                                    }
        }
        var reverse = component.get("v.sortAsc") ? 1: -1;
        result.sort(function(a,b){
            var a = key(a) ? key(a) : '';
            var b = key(b) ? key(b) : '';
            return reverse * ((a>b) - (b>a));
        });
        component.set('v.taskdata',result);
        
    },
    
    getfilterrcds : function(component,event,helper){
        var tkselctn = component.find('TaskVId').get('v.value');
        var stfname =  component.find('Staffsval').get('v.value');
        var rolname =  component.find('rolesval').get('v.value');
        var clientname = component.find('clientval').get('v.value');
        var jobrcdname = component.find('Jobval').get('v.value');
        var myObjectMap = [];
        var myMap =new Map();
        var action = component.get("c.getfiltervalsrcd");
        action.setParams({
            tkselection:tkselctn,
            stf:stfname,
            rol :rolname,
            clnt :clientname,
            jobrcdval:jobrcdname
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result=response.getReturnValue();
            // alert('>>rows>>>'+JSON.stringify(rows.jobwrp));
            if (state === "SUCCESS") {
                /*  The Below For loop is used when grouped staff member using map but later with list wed
                 for(var i=0; i<result.length; i++)
                {
                    var myRecord = result[i];
                                var color = '#'+(0x1000000+(Math.random())*0xffffff).toString(16).substr(1,6);
                                var myKey = myRecord.User__c;
                                var found = false;
                                for(var x=0; x<myObjectMap.length; x++) {
                                    if("key" in myObjectMap[x] && myObjectMap[x]["key"] == myKey) {
                                        var totalsvar = myObjectMap[x]["list"];
                                        //  alert(totalsvar.length);
                                        for(var c = 0 ; c < totalsvar.length ; c++){
                                            totalsvar[c].colorval = color;
                                            console.log ('rcd is === '+ totalsvar[c].Job_Task__r.Name);
                                            console.log ('c is === '+c+''+'color is '+  totalsvar[c].colorval);
                                        }
                                        myObjectMap[x]["list"].push(myRecord);
                                        found = true;
                                        break;
                                    }
                                }
                                if(!found) {
                                    var temp = { "key": myKey, "list": [myRecord] };
                                    myObjectMap.push(temp);
                                }
                            }*/
                for(var i=0; i<result.length; i++)
                {
                    var myRecord = result[i];
                    if(myMap.has(result[i].User__c)){
                        result[i].tdcolor =  myMap.get(result[i].User__c);
                        // alert('If contains result[i].tdcolor '+result[i].User__c+''+result[i].tdcolor);
                    }
                    else{
                        // var color = '#'+(0x1000000+(Math.random())*0xffffff).toString(16).substr(1,6);
                        var x=Math.round(0xffffff * Math.random()).toString(16); // working random color formula
                        var y=(6-x.length);
                        var z='000000';
                        var z1 = z.substring(0,y);
                        var color= '#' + z1 + x;
                        result[i].tdcolor = color;
                        // alert('else result[i].tdcolor '+result[i].User__c+''+result[i].tdcolor);
                        myMap.set(result[i].User__c, color);      
                    }
                    if(result[i].Job_Task__r.Job__r.Campaign__c == null){
                        result[i].campaignrcdid = '';
                        result[i].campaignrcd = '';
                    }
                    else{
                        result[i].campaignrcdid = result[i].Job_Task__r.Job__r.Campaign__c;
                        result[i].campaignrcd = result[i].Job_Task__r.Job__r.Campaign__r.Name;
                    }
                    if(result[i].Job_Task__r.Job__r.JS_Client__c == null){
                        result[i].clientrcdid = '';
                        result[i].clientrcd = '';
                    }
                    else{
                        result[i].clientrcdid = result[i].Job_Task__r.Job__r.JS_Client__c;
                        result[i].clientrcd = result[i].Job_Task__r.Job__r.JS_Client__r.Name;
                    }
                    
                    // result[i].jobautonumber = result[i].Job_Task__r.Job__r.Job_Auto_Number__c;
                    
                    result[i].dteformat = this.dateFormat(new Date(result[i].Job_Task__r.Revised_Due_Date__c));
                    myObjectMap.push(result[i]) ;
                }  
                component.set("v.spinner",false);
                component.set("v.taskdata", myObjectMap);
                
                //alert('filter spinner'+s);
            }
            else {
                component.set("v.spinner",false);
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
    
    MyTaskrecordsfetchfortablevals  : function(component, event , helper){
        var myObjectMap = [];
        var myMap =new Map();
        var action = component.get("c.getMyTaskDatafortablevals");
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result=response.getReturnValue();
            if (state === "SUCCESS") {
                /*  The Below For loop is used when grouped staff member using map but later with list wed
            for(var i=0; i<result.length; i++)
                {
                    var myRecord = result[i];
                                var color = '#'+(0x1000000+(Math.random())*0xffffff).toString(16).substr(1,6);
                                var myKey = myRecord.User__c;
                                var found = false;
                                for(var x=0; x<myObjectMap.length; x++) {
                                    if("key" in myObjectMap[x] && myObjectMap[x]["key"] == myKey) {
                                        var totalsvar = myObjectMap[x]["list"];
                                        //  alert(totalsvar.length);
                                        for(var c = 0 ; c < totalsvar.length ; c++){
                                            totalsvar[c].colorval = color;
                                            console.log ('rcd is === '+ totalsvar[c].Job_Task__r.Name);
                                            console.log ('c is === '+c+''+'color is '+  totalsvar[c].colorval);
                                        }
                                        myObjectMap[x]["list"].push(myRecord);
                                        found = true;
                                        break;
                                    }
                                }
                                if(!found) {
                                    var temp = { "key": myKey, "list": [myRecord] };
                                    myObjectMap.push(temp);
                                }
                            }*/
                for(var i=0; i<result.length; i++)
                {
                    var myRecord = result[i];
                    if(myMap.has(result[i].User__c)){
                        result[i].tdcolor =  myMap.get(result[i].User__c);
                        // alert('If contains result[i].tdcolor '+result[i].User__c+''+result[i].tdcolor);
                    }
                    else{
                        //var color = '#'+(0x1000000+(Math.random())*0xffffff).toString(16).substr(1,6);
                        // var color = this.generateDarkColorHex(component,event,helper);
                        var x=Math.round(0xffffff * Math.random()).toString(16); // working random color formula
                        var y=(6-x.length);
                        var z='000000';
                        var z1 = z.substring(0,y);
                        var color= '#' + z1 + x;
                        result[i].tdcolor = color;
                        // alert('else result[i].tdcolor '+result[i].User__c+''+result[i].tdcolor);
                        myMap.set(result[i].User__c, color);      
                    }
                    if(result[i].Job_Task__r.Job__r.Campaign__c == null){
                        result[i].campaignrcdid = '';
                        result[i].campaignrcd = '';
                    }
                    else{
                        result[i].campaignrcdid = result[i].Job_Task__r.Job__r.Campaign__c;
                        result[i].campaignrcd = result[i].Job_Task__r.Job__r.Campaign__r.Name;
                    }
                    if(result[i].Job_Task__r.Job__r.JS_Client__c == null){
                        result[i].clientrcdid = '';
                        result[i].clientrcd = '';
                    }
                    else{
                        result[i].clientrcdid = result[i].Job_Task__r.Job__r.JS_Client__c;
                        result[i].clientrcd = result[i].Job_Task__r.Job__r.JS_Client__r.Name;
                    }
                    //we can use this. or helper. for below line.
                    result[i].dteformat = this.dateFormat(new Date(result[i].Job_Task__r.Revised_Due_Date__c));
                    myObjectMap.push(result[i]) ;
                }  
                component.set("v.spinner",false);
                component.set("v.taskdata", myObjectMap);
                
                //alert('MyTaskrecordsfetchfortablevals spinner'+s);
            }
            else {
                component.set("v.spinner",false);
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
    
    dateFormat  : function (fromdate){
        var dd = fromdate.getDate();
        var mm = fromdate.getMonth()+1;
        var yyyy = fromdate.getFullYear();
        if(dd<10)
        {
            dd='0'+dd;
        }
        if(mm<10)
        {
            mm='0'+mm;
        }
        var ftdate = mm+'-'+dd+'-'+yyyy;
        return ftdate;
    },
    
    generateDarkColorHex :   function (component, event , helper) {
        const red = Math.floor(Math.random() * 256);
        const green = Math.floor(Math.random() * 256);
        const blue = Math.floor(Math.random() * 256);
        return "rgb(" + red + ", " + green + ", " + blue + ")";
        
    },
    
    
    TaskDone: function(component, event, helper, selectTskId){
        var taskview=component.find("TaskVId").get("v.value");
        //alert(taskview);
        console.log('===Task Done==');
        var action=component.get("c.assignMarkedDone");
        action.setParams({
            strJTID : selectTskId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result=response.getReturnValue();
            if (state === "SUCCESS") {
                if(response.getReturnValue() == 'OK'){
                    helper.showToast({
                        "type":"success",
                        "message":  "Job Task Record Mark Done Successfully."
                    });  
                    /* var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef : "c:Tasks_Tab",
                    });
                    evt.fire();*/
                    this.getfilterrcds(component,event,helper); 
                    
                }
            }
            else{
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
    
    deletetask : function(component,event,helper,tkid){
        var action = component.get("c.dltetk");
        action.setParams({
            taskid :  tkid
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result=response.getReturnValue();
            if (state === "SUCCESS") {
                if(result == 'ok'){
                    this.getfilterrcds(component,event,helper);
                    helper.showToast({
                        "type":"success",
                        "message":  "Job Task Record Deleted Successfully."
                    });  
                    /* var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef : "c:Tasks_Tab",
                    });
                    evt.fire();*/
                    
                }
            }
            else {
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
                    //   helper.JobTasksfetch(component,event);
                    
                    //helper.reloadDataTable();
                    component.set("v.isTaskEdit",false);
                    component.set("v.EditTaskId",null);
                    component.set("v.isDaysChanged",false);
                    component.set("v.isDueDateChanged",false);
                    helper.showToast({
                        "type": "success",
                        "message": "Successfully Updated the Job Task."
                    });
                    /* var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef : "c:Tasks_Tab",
                    });
                    evt.fire();*/
                    this.getfilterrcds(component,event,helper);
                    
                    /* var isListView=component.get("v.isListview");
                                    if(!isListView){
                                        this.fetchCalenderEvents(component,event, helper);
                                    }*/
                    /*   var appEvent=$A.get("e.c:UpdateRecordsforChanges");
                    if(appEvent){
                        appEvent.fire();  
                    }*/
                    
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
                    /* var appEvent=$A.get("e.c:UpdateRecordsforChanges");
                    if(appEvent){
                        appEvent.fire();  
                    }*/
                    
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
                    helper.showToast({
                        "type": "success",
                        "message": "File is attached to the task record."
                    });
                    this.getfilterrcds(component,event,helper);
                    /*    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": tskId,
                        "slideDevName": "related"
                    });
                    navEvt.fire();*/
                    /* var appEvent=$A.get("e.c:UpdateRecordsforChanges");
                                    if(appEvent){
                                        appEvent.fire();  
                                    }*/
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
    
    
    showToast : function(params){
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams(params);
            toastEvent.fire();
        } else{
            alert(params.message);
        }
    },
    
    navigate : function(component,event,helper){
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:Tasks_Tab",
        });
        evt.fire();
    }
    
    
    /*
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
        console.log('>>>>>>>>>taskview>>>>>>>>>>>'+taskview);
       
        var action = component.get("c.getMyTaskData");
        action.setCallback(this, function(response) {
            var state = response.getState();
            var rows=response.getReturnValue();
            console.log('>>>>>>>>>>>Taskssssssssssss>>>>>>>>>>>>>>>'+JSON.stringify(rows));
           
            if (state === "SUCCESS") {
                for (var i = 0; i < rows.length; i++) {
                   
                    console.log('>>>>>>>>>>>>>>>>rows.length>>>>>>>>>>>>>>>>'+rows.length);
                    var row = rows[i];
                 //   alert('>>>>>>>>>>>> data is '+JSON.stringify(row));
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
    /*  row.TaskColorcode=row.color+'_color';
                    row.TaskName=row.jobTaskrole.Job_Task__r.Name;
                    row.TaskDue=row.jobTaskrole.Job_Task__r.Revised_Due_Date__c;
                    row.JobNum=row.jobTaskrole.Job_Task__r.Job__r.Job_Auto_Number__c;
                }
                component.set("v.data",rows);
            }
            else {
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
    }*/
})