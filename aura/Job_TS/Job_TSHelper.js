({
    
    getFieldLabels: function(component, event, helper) {
        var rowActions = helper.getRowActions.bind(this, component);
        var Objaction = component.get( "c.getObjectType" );
        Objaction.setParams({
            ObjNames : 'Timesheet_Entries__c'
        }); 
        Objaction.setCallback( helper, function( response ) {
            console.log('>>>>>> Enter >>>>>>>>>>');
            if(component.isValid() && response.getState() === 'SUCCESS' ) {
                // Parse the JSON string into an object
                component.set( 'v.ObjectType', JSON.parse(response.getReturnValue()));
                console.log('>>>>>> Result of labels 1   >>>>>>>>>>'+JSON.parse( response.getReturnValue()));
                console.log('>>>>>> Result of labels >>>>>>>>>>'+JSON.stringify(JSON.parse( response.getReturnValue() )));
                var tableHeader=component.get('v.ObjectType');
                console.log('>>>Field Name Dynamically >>>>>>>>>>>>>'+tableHeader);
                component.set('v.columns', [
                    {type: 'action', typeAttributes: {rowActions: rowActions}},
                    {label: tableHeader.Timesheet_Entries__c.Name.label, fieldName: 'TSLink', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: '_self' ,tooltip:{ fieldName: 'Name' }}},
                    {label: tableHeader.Timesheet_Entries__c.Task_Name__c.label, fieldName: 'Task_Name__c', sortable: true, type: 'text'},
                    {label: tableHeader.Timesheet_Entries__c.Hours_Worked__c.label, fieldName: 'Hours_Worked__c', editable:'true',sortable: true, type: 'number'},
                    {label: tableHeader.Timesheet_Entries__c.Date__c.label, fieldName: 'Date__c', editable:'true', sortable: true, type: 'date-local' , cellAttributes: { iconName: 'utility:event', iconAlternativeText: 'Invoice Date'}},
                    {label: tableHeader.Timesheet_Entries__c.User__c.label, fieldName: 'UserLink', sortable: true, type: 'url',typeAttributes: { label: { fieldName: 'User__c' }, target: '_self' ,tooltip:{ fieldName: 'User__c' }}}
                    
                ]);  
                var labels = {'Date':  tableHeader.Timesheet_Entries__c.Date__c.label,
                              'Hours':tableHeader.Timesheet_Entries__c.Hours_Worked__c.label,
                              'Staff':tableHeader.Timesheet_Entries__c.User__c.label
                             };
                component.set('v.DynamicLabels',labels);
                console.log('-----labels--'+JSON.stringify(labels));
            } else {
                console.log('>>>>>> else >>>>>>>>>>');
                /* var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Timesheet has '+errors[0].message
                });
                toastEvent.fire();*/
                // console.error( 'Error calling action "' + actionName + '" with state: ' + response.getState() );
            }
        });
        $A.enqueueAction( Objaction );   
        var action1 = component.get("c.geLabelforObject");
        action1.setParams({
            sObjName :  "Timesheet_Entries__c"
        });
        action1.setCallback(this, function(response){
            var state = response.getState();
            console.log("label name" + response.getReturnValue());
            if(state === "SUCCESS"){
                component.set("v.Labelname", response.getReturnValue());
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Timesheet has '+errors[0].message
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action1);
    },
    
    fetchJobTS : function(component, event, helper) {
        var recId = component.get("v.recordId");
        console.log('==recId==='+recId);
        var TotalHours=component.get("c.getTotalHoursWorkedSum");
        TotalHours.setParams({
            recordId : recId
        });
        TotalHours.setCallback(this, function(response) {
            var state = response.getState();
            console.log('>>>>>>>>>>>Total Hours TS>>>>>>>>>>>'+response.getReturnValue());
            if (state === "SUCCESS" ) {
                var resultData = response.getReturnValue();
                console.log('>>>>>>>>>>>Total Hours TS>>>>>>>>>>>'+resultData);
                component.set("v.TotalTimesheetHours", resultData);
            }
            /* else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Timesheet has '+errors[0].message
                }); 
            }*/
        });
        var TSRec = component.get("c.getTSrecords");
        TSRec.setParams({
            recordId : recId,
            recordLimit: component.get("v.initialRows"),
            recordOffset: component.get("v.rowNumberOffset")
        });
        TSRec.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var rows=response.getReturnValue();
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    //console.log('>>>>>Timesheet records>>>>>>>'+JSON.stringify(row));
                    row.TSLink = '/'+row.Id;    
                    if(row.User__c){
                        row.UserLink='/'+row.User__c;
                        row.User__c=row.User__r.Name;
                    }
                    
                }
                component.set("v.data",rows);
                component.set("v.currentCount", component.get("v.initialRows"));
            }
            else {
                console.log('>>>>>> TS Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Timesheet has '+errors[0].message
                });
                toastEvent.fire();
            }
        });
        
        
        var TSJobRec = component.get("c.getJobName");
        TSJobRec.setParams({
            recordId : recId 
        });
        TSJobRec.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.JobName",response.getReturnValue());
            }
            else {
                console.log('>>>>>> getJobName Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Timesheet has '+errors[0].message
                });
                toastEvent.fire();
            }
            
        });
        
        var systoday = component.get("c.gettodaydate");
        systoday.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.today",response.getReturnValue());
            }
        });
        var userinfo = component.get("c.getUserName");
        userinfo.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.loginUserId",response.getReturnValue());
            }
        });
        $A.enqueueAction(userinfo);
        $A.enqueueAction(systoday);
        $A.enqueueAction(TSRec);
        $A.enqueueAction(TSJobRec);
        $A.enqueueAction(TotalHours);
    },
    
    fetchJobAllTS : function(component, event, helper) {
        var recId = component.get("v.recordId");
        console.log('==recId==='+recId);
        var TotalHours=component.get("c.getTotalHoursWorkedSum");
        TotalHours.setParams({
            recordId : recId
        });
        TotalHours.setCallback(this, function(response) {
            var state = response.getState();
            console.log('>>>>>>>>>>>Total Hours TS>>>>>>>>>>>'+response.getReturnValue());
            if (state === "SUCCESS" ) {
                var resultData = response.getReturnValue();
                console.log('>>>>>>>>>>>Total Hours TS>>>>>>>>>>>'+resultData);
                component.set("v.TotalTimesheetHours", resultData);
            }
        });
        
        var TSAllRec = component.get("c.getTSAllrecords");
        TSAllRec.setParams({
            recordId : recId,
            recordLimit: component.get('v.data').length
        });
        
        TSAllRec.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var rows=response.getReturnValue();
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    //console.log('>>>>>Timesheet records>>>>>>>'+JSON.stringify(row));
                    row.TSLink = '/'+row.Id;    
                    if(row.User__c){
                        row.UserLink='/'+row.User__c;
                        row.User__c=row.User__r.Name;
                    }
                    
                }
                component.set("v.data",rows);
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Timesheet has '+errors[0].message
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(TSAllRec);
        $A.enqueueAction(TotalHours);
    },
    
    getTotalNumberOfRecords : function(component) {
        
        var recId = component.get("v.recordId");
        console.log('==recId==='+recId);
        
        var TotalRecaction = component.get("c.getTotalRecords");
        TotalRecaction.setParams({
            recordId : recId
        });
        TotalRecaction.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" ) {
                var resultData = response.getReturnValue();
                console.log('>>>>>>>>>>>totalNumberOfRows TS>>>>>>>>>>>'+resultData);
                component.set("v.totalNumberOfRows", resultData);
            }
            /* else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Timesheet has '+errors[0].message
                }); 
            }*/
        });
        $A.enqueueAction(TotalRecaction);
        
    },
    
    loadingInstiate :function (component, event, helper){
        //event.getSource().set("v.isLoading", true);
        component.set('v.loadMoreStatus', 'Loading....');
        if (component.get('v.data').length != component.get('v.totalNumberOfRows')) {
            event.getSource().set("v.isLoading", true);
            helper.getMoreRec(component, component.get('v.rowsToLoad')).then($A.getCallback(function (data) {
                if (component.get('v.data').length == component.get('v.totalNumberOfRows')) {
                    event.getSource().set("v.isLoading", false);
                    component.set('v.enableInfiniteLoading', false);
                    component.set('v.loadMoreStatus', 'No more data to load');
                } else {
                    var currentData = component.get('v.data');
                    var newData = currentData.concat(data);
                    for (var i = 0; i < newData.length; i++) {
                        var row = newData[i];
                        row.TSLink= '/'+row.Id;
                        if(row.User__c){
                            row.UserLink='/'+row.User__c;
                            row.User__c=row.User__r.Name;
                        }
                    }
                    component.set('v.data', newData);
                    component.set('v.loadMoreStatus', 'Please scroll down to load more data');
                }
                event.getSource().set("v.isLoading", false);
            }));
        }
        else
        {
            //event.getSource().set("v.isLoading", false);
            component.set('v.enableInfiniteLoading', false);
            component.set('v.loadMoreStatus', 'No more data to load');
        }
    },
    
    getMoreRec: function(component , rows){
        return new Promise($A.getCallback(function(resolve, reject) {
            var recId = component.get("v.recordId");
            console.log('==recId==='+recId);
            var action = component.get('c.getTSrecords');
            var recordOffset = component.get("v.currentCount");
            console.log('>>>>>recordOffset>>>'+recordOffset);
            var recordLimit = component.get("v.initialRows");
            console.log('>>>>>recordLimit>>>'+recordLimit);
            action.setParams({
                recordId : recId,
                recordLimit: recordLimit,
                recordOffset: recordOffset 
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS"){
                    var resultData = response.getReturnValue();
                    resolve(resultData);
                    recordOffset = recordOffset+recordLimit;
                    component.set("v.currentCount", recordOffset); 
                    
                }
                else {
                    console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                    var errors = response.getError();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!!",
                        "type": "error",
                        "message": 'Timesheet has '+errors[0].message
                    });
                    toastEvent.fire();
                }                
            });
            $A.enqueueAction(action);
        }));
    },
    
    getRowActions: function (component, row, doneCallback) {
        var actions = [];
        var editAction = {
            'label': 'Edit',
            'iconName': 'utility:edit',
            'name': 'Edit_TS'
        };
        
        var deleteAction = {
            'label': 'Delete',
            'iconName': 'utility:delete',
            'name': 'Delete_TS'
        };
        
        actions.push(editAction,deleteAction);
        // simulate a trip to the server
        setTimeout($A.getCallback(function () {
            doneCallback(actions);
        }), 200);
    },
    
    getTaskName: function(component, event, helper){
        var recId = component.get("v.recordId");
        console.log('==recId==='+recId);
        var action1 = component.get("c.getTaskName");
        action1.setParams({
            recordId : recId 
        });
        action1.setCallback(this, function(response1) {
            console.log("=====Tasksss====", response1.getReturnValue());
            if(response1.getState() === "SUCCESS"){
                // helper.getFieldLabels(component, event, helper);
                var TaskNames=response1.getReturnValue();
                console.log('>>>>>>>>>>>>Task Name>>>>>>>>>>>>'+JSON.stringify(TaskNames));
                component.set("v.TaskName", TaskNames);
            }
            /* else {
                console.log('>>>>>> Error >>>>>>>>>>',response1.getError()[0].message);
                var errors = response1.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Timesheet has '+errors[0].message
                }); 
            }*/
        });
        $A.enqueueAction(action1);
    },
    
    getTotalHrs: function(component, event, helper){
        var Start=component.find("STWatch").get('v.value');
        var End=component.find("ETWatch").get('v.value');
        console.log('==========Start======'+Start);
        console.log('==========End======'+End);
        if(Start==null && End==null)
        {	
            console.log('========entered=======true=========');
            component.set("v.isStartEnd", false);
        }
        else
        {
            console.log('========entered=false====');
            component.set("v.isStartEnd", true);
        }
    },
    
    
    getGLCode: function(component, event, helper){
        var recId = component.get("v.recordId");
        console.log('==recId==='+recId);
        var TaskName = component.find("TaskNameId").get("v.value");
        var GLCode = component.get("c.getGLCodeOfTask");
        
        GLCode.setParams({
            recordId : recId, 
            JobTaskNameStr : TaskName
        });
        GLCode.setCallback(this, function(response1) {
            console.log("=====GLCode====", +JSON.stringify(response1.getReturnValue()));
            if(response1.getState() === "SUCCESS"){
                var GLCode=response1.getReturnValue();
                console.log('>>>>>>>>>>>>GLCode>>>>>>>>>>>>'+JSON.stringify(GLCode));
                component.set("v.GLCodeofTask", GLCode[1]); 
                component.set("v.GLCodeofTaskid", GLCode[0]); 
                helper.getTotalHours(component, event, helper);
                
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response1.getError()[0].message);
                var errors = response1.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Timesheet has '+errors[0].message
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(GLCode);
    },
    
    
    getTotalHours: function(component, event, helper){
        var recId = component.get("v.recordId");
        console.log('==TotalHours recId==='+recId);
        var TaskName=component.find("TaskNameId").get('v.value');
        console.log('==TotalHours TaskName==='+TaskName);
        var GLCodeID=component.get('v.GLCodeofTaskid');
        console.log('==TotalHours GLCodeName==='+GLCodeID);
        
        var TotalHours = component.get("c.getTotalHours");
        TotalHours.setParams({
            JobNameStr : recId, 
            GLCode :GLCodeID
        });
        TotalHours.setCallback(this, function(response1) {
            console.log("=====Total Hours====", response1.getReturnValue());
            if(response1.getState() === "SUCCESS"){
                var TotalHours=response1.getReturnValue();
                console.log('>>>>>>>>>>>>Total Hours>>>>>>>>>>>>'+JSON.stringify(TotalHours));
                component.set("v.TotalHours", TotalHours); 
                helper.getRemainHours(component, event, helper);
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response1.getError()[0].message);
                var errors = response1.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Timesheet has '+errors[0].message
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(TotalHours);
    },
    
    
    getRemainHours: function(component, event, helper){
        var recId = component.get("v.recordId");
        console.log('==Remain Hours recId==='+recId);
        var GLCodeid=component.get('v.GLCodeofTaskid');
        console.log('==Remain Hours GLCode==='+GLCodeid);
        var TTH=component.get('v.TotalHours');
        
        var RemainHours = component.get("c.getRemainHours");
        RemainHours.setParams({
            JobNameStr : recId, 
            GLCodeId :GLCodeid,
            TaskTotalHr:TTH
        });
        RemainHours.setCallback(this, function(response1) {
            console.log("=====Remain Hours====", response1.getReturnValue());
            if(response1.getState() === "SUCCESS"){
                var RemainHours=response1.getReturnValue();
                console.log('>>>>>>>>>>>>Total Hours>>>>>>>>>>>>'+JSON.stringify(RemainHours));
                component.set("v.RemainHours", RemainHours); 
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response1.getError()[0].message);
                var errors = response1.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Timesheet has '+errors[0].message
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(RemainHours);
    },
    
    getTotalHoursWorked: function(component, event, helper){
        var ST = component.find("STWatch").get('v.value');
        console.log('==TotalHoursWorked Start Watch==='+ST);
        var ET = component.find("ETWatch").get('v.value');
        console.log('==TotalHoursWorked End Watch==='+ET);
        
        var HoursWorked = component.get("c.calcTimeDiff");
        HoursWorked.setParams({
            StWatch : ST, 
            EndWatch : ET
        });
        HoursWorked.setCallback(this, function(response1) {
            console.log("=====Total Hours Worked====", response1.getReturnValue());
            if(response1.getState() === "SUCCESS"){
                var HoursWorked=response1.getReturnValue();
                console.log('>>>>>>>>>>>>Total Hours Worked>>>>>>>>>>>>'+JSON.stringify(HoursWorked));
                component.set("v.TotalHoursWorked", HoursWorked); 
                var s =HoursWorked ;
                if(s!='0'){
                    console.log('>>>>>s!=0>>>>>>>');
                    if(s=='0.01'){ 
                        console.log('>>>>>s==0.01>>>>>>>');
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error",
                            "type": "Error",
                            "message": "End watch should be greater than Start watch."
                        });
                        toastEvent.fire();
                        
                    }              
                }
            }
        });
        $A.enqueueAction(HoursWorked);
    },
    
    
    /*
     * This function get called when user clicks on Save button
     * user can get all modified records
     * and pass them back to server side controller
     * */
    saveDataTable : function(component, event, helper) {
        var editedRecords =  component.find("TSDataTable").get("v.draftValues");
        var totalRecordEdited = editedRecords.length;
        var action = component.get("c.updateTS");
        action.setParams({
            'editTSList' : editedRecords
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //if update is successful
                if(response.getReturnValue() === 'true'){
                    this.showToast({
                        "title": "Record Update",
                        "type": "success",
                        "message": totalRecordEdited+" Time Sheet Records Updated"
                    });
                    // helper.reloadDataTable();
                    helper.fetchJobAllTS(component, event, helper);
                    //  helper.fetchJobTS(component, event, helper);
                    helper.loadingInstiate(component, event, helper);
                    
                    component.find("TSDataTable").set("v.draftValues", null);
                } else{ //if update got failed
                    this.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": response.getReturnValue()
                    });
                    
                }      
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                this.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'TimeSheet has '+errors[0].message
                }); 
            }
            
        });
        $A.enqueueAction(action);
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
        console.log('==========reloadData Table======');
        var refreshEvent = $A.get("e.force:refreshView");
        $A.get('e.force:refreshView').fire();
        if(refreshEvent){
            refreshEvent.fire();
        }
    },
    
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.data");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.data", data);
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
    
    /*  FetchFieldsfromFS:  function(component, event, helper){
        var action = component.get("c.getFieldsforObjectTS");
        action.setParams({
            sObjName : "Timesheet_Entries__c"
        });
        action.setCallback(this, function(response) {
            console.log("=====Field set====", response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                component.set("v.fieldset",response.getReturnValue()); 
            }
        });
        
        $A.enqueueAction(action);
    },*/
    
    deleteJobTS: function(component, event, helper,selectTsId){
        var DeleteTS=component.get("c.DeleteTS");
        if(selectTsId!=null || selectTsId!=undefined){
            DeleteTS.setParams({
                TSId :selectTsId
            });
        }
        else{
            var row = event.getParam('row');
            DeleteTS.setParams({
                TSId :row.Id 
            }); 
            console.log('===Delete TS Id=='+row.Id);
        }     
        
        
        
        DeleteTS.setCallback(this, function(DeleteTSres){
            var delresult = DeleteTSres.getReturnValue();
            console.log('===delresult=='+JSON.stringify(delresult));
            if(DeleteTSres.getState() === "SUCCESS"){
                if(delresult[0]=="OK"){
                    // helper.fetchJobTS(component, event, helper);
                    helper.fetchJobAllTS(component, event, helper);
                    helper.loadingInstiate(component, event, helper);
                    helper.getTotalNumberOfRecords(component);
                    var ToastMsg = $A.get("e.force:showToast");
                    ToastMsg.setParams({
                        "type": "success",
                        "message":'Job TimeSheet Record Deleted Successfully.'
                    });
                    ToastMsg.fire();                  
                }
                else{
                    var ToastMsg = $A.get("e.force:showToast");
                    ToastMsg.setParams({
                        "title": "Error!!",
                        "type": "error",
                        "message":delresult[0]
                    });
                    ToastMsg.fire();
                }
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',DeleteTSres.getError()[0].message);
                var errors = DeleteTSres.getError();
                this.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Timesheet has '+errors[0].message
                }); 
            }         
        });
        $A.enqueueAction(DeleteTS);  
    }
    
    
})