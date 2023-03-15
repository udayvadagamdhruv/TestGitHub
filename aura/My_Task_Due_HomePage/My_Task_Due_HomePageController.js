({
    afterScriptsLoadedinHomePage :function(component, event, helper) {
        helper.fetchCalenderEvents(component, event, helper);
    },
    doInit: function(component, event, helper) {
        helper.fetchFieldLabels(component,event,helper);
        //alert('init');
        var taskview='MyTaskDues';
        helper.MyTaskrecordsfetch(component,event,helper,taskview);
        var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
        console.log('--isMobile'+isMobile);
        if(isMobile){
            component.set("v.isMobile",true);
        }
    },
    
    handleRowAction: function(component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'Task_Done':
                helper.TaskDone(component, event, helper);
                break;
                
            case 'Timesheet_Entry':
                component.set("v.LogTaskId",row.jobTaskrole.Job_Task__r.Id);
                component.set("v.isTaskLogTime",true); 
                component.find("LogTimeId").refreshTaskData();
                break;
        }
    },
    
    updateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },
    
    handleTasksView :function (component, event, helper) {
        helper.fetchCalenderEvents(component, event, helper);
    },
    
    handleTasksViewSel:function (component, event, helper) {
        //alert('>>>>>>>>>handleTasksViewSel>>>>>>>>>>>');
        var taskview=component.find("TaskVId").get("v.value");
        console.log('>>>>>>>>>taskview>>>>>>>>>>>'+taskview);
        helper.MyTaskrecordsfetch(component, event, helper,taskview);
    },
    
    CalenderView : function (component, event, helper) {
        // window.open('/one/one.app#/alohaRedirect/apex/TaskCalendarNewHome','_blank'); 
        console.log('========Button Name============'+event.getSource().get("v.label"));
        if(component.get("v.isListview")){
            component.set("v.isListview",false);
            component.set("v.isListview1",true);
            event.getSource().set("v.label","My Do List");
        }
        else{
            helper.MyTaskrecordsfetch(component,event,helper);
            component.set("v.isListview",true); 
            event.getSource().set("v.label","My Calender");
        }
        
    },
    
    handleTaskQuickAction : function(component, event, helper) {
        var selectOption=event.getParam("value");
        var selectTskId=event.getSource().get("v.name");
        // console.log('---selectTskId-'+selectTskId+'---selectOption--'+selectOption);
        if(selectOption == 'TaskDoneMobile'){
            //alert('---selectTskId-'+selectTskId+'---selectOption--'+selectOption);
            var TSKDone=component.get("c.assignMarkedDone");
            if(selectTskId!=null || selectTskId!=undefined || selectTskId != ''){
                //alert('selectTskId ===' +selectTskId );
                TSKDone.setParams({
                    strJTID :selectTskId
                });
            }
            TSKDone.setCallback(this, function(Taskres){
                var Tskstate = Taskres.getState();
                console.log('===Tskstate=='+Tskstate);
                if(Tskstate === "SUCCESS"){
                    if(Taskres.getReturnValue() === 'OK')
                    {
                        $A.get('e.force:refreshView').fire();
                        // helper.MyTaskrecordsfetch(component, event, helper,taskview);
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
            /*   switch (selectOption) {
            case 'TaskDone':
                helper.TaskDoneMobile(component, event, helper, selectTskId);
                break;
            case 'Log_Time':
                component.set("v.LogTaskId",selectTskId);
                component.set("v.isTaskLogTime",true); 
                component.find("LogTimeId").refreshTaskData();
                break;
        }*/
         }
    }
    
})