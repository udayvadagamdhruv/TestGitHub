({
	doInit: function(component, event, helper) {
        helper.fetchFieldLabels(component, event, helper);
        helper.ScheduleTasksfetch(component, event, helper);//fetch the Scheudle Tasks.
    },
    
    updateColumnSorting: function(cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },
    
    refreshScheduleTasks : function(component, event, helper) {
        helper.ScheduleTasksfetch(component, event, helper);
    },
    
     onSave: function(component, event, helper) {
        helper.saveDataTable(component, event, helper);
    },
    
    InsertScheduleTaskBelow : function(component, event, helper) {
        helper.getTaskOrderforBelowTask(component, event, helper);
        component.set("v.isSTBelowInsert",true);
    },
    closeBelowSTaskModel : function(component, event, helper) {
        component.set("v.isSTBelowInsert",false);
    },
    
     closeEditSTaskModel : function(component, event, helper) {
        component.set("v.isSTEdit",false);
    },
     closeAboveSTaskModel : function(component, event, helper) {
        component.set("v.isSTAboveInsert",false);
    },
    
    
    
    handleRowAction : function(component, event, helper) {
        var action = event.getParam('action');
         var row = event.getParam('row');
        switch (action.name) {
            case 'ST_Edit':
                component.set("v.EditSTaskId",row.Id);
                component.set("v.isSTEdit",true);
                break;
            case 'ST_Delete':
                helper.DeleteScheuleTask(component, event, helper);
                break;
            case 'ST_AddEditRoles':
                component.set("v.AddRolesEditSTaskId",row.Id);
                component.set("v.isRolesAddingtoTask",true);
                component.find("STRoleCompId").refreshSTaskRoles();
                break;
           case 'ST_Above':
                component.set("v.AboveSTaskRow",row);
                component.set("v.AboveSTaskId",row.Id);
                component.set("v.isSTAboveInsert",true);
                break;
        }
    },
    
    
    STaskBelowOnsubmit: function(component, event, helper) {
        event.preventDefault(); // Prevent default submit
        var STFields = event.getParam("fields");
        //STFields["Job__c"] = component.get("v.recordId");
        var NameField=component.find("NameSTaskBelowFields").get("v.value");
        if(NameField==null || NameField==''){
            var ToastMsg = $A.get("e.force:showToast");
            ToastMsg.setParams({
                "title": "Name",
                "type": "error",
                "message": "Name Field is required."
                
            });
            ToastMsg.fire();
             event.preventDefault();
        }
        else{
          component.find("STaskBelowEditForm").submit(STFields);  
         }
    },
    
    STaskBelowOnSuccess :function(component, event, helper) {
        var ToastMsg1 = $A.get("e.force:showToast");
        ToastMsg1.setParams({
            "type": "success",
            "message": "Successfully Inserted Schedule Task Record."

        });
         ToastMsg1.fire();
        component.set("v.isSTBelowInsert",false);
         helper.ScheduleTasksfetch(component, event, helper);
    },
    
     STaskEditOnsubmit: function(component, event, helper) {
        event.preventDefault(); // Prevent default submit
        var STFields = event.getParam("fields");
        //STFields["Job__c"] = component.get("v.recordId");
        var NameField=component.find("NameSTaskEditFields").get("v.value");
        if(NameField==null || NameField==''){
            var ToastMsg = $A.get("e.force:showToast");
            ToastMsg.setParams({
                "title": "Name",
                "type": "error",
                "message": "Name Field is required."
                
            });
            ToastMsg.fire();
             event.preventDefault();
        }
        else{
          component.find("STaskEditForm").submit(STFields);  
         }
    },
    
    STaskEditOnSuccess :function(component, event, helper) {
        var ToastMsg1 = $A.get("e.force:showToast");
        ToastMsg1.setParams({
            "type": "success",
            "message": "Successfully Updated Schedule Task Record."

        });
         ToastMsg1.fire();
        component.set("v.isSTEdit",false);
         helper.ScheduleTasksfetch(component, event, helper);
    },
    
   
     STaskAboveOnsubmit: function(component, event, helper) {
        event.preventDefault(); // Prevent default submit
         var staskrow=component.get("v.AboveSTaskRow");
         console.log('====taskrow==='+JSON.stringify(staskrow));
        var STFields = event.getParam("fields");
        //STFields["Job__c"] = component.get("v.recordId");
         if(staskrow.Task_Order__c!=null){
             STFields["Task_Order__c"]=staskrow.Task_Order__c;
         }
        var NameField=component.find("NameSTaskAboveFields").get("v.value");
        if(NameField==null || NameField==''){
            var ToastMsg = $A.get("e.force:showToast");
            ToastMsg.setParams({
                "title": "Name",
                "type": "error",
                "message": "Name Field is required."
                
            });
            ToastMsg.fire();
             event.preventDefault();
        }
        else{
          component.find("STaskAboveForm").submit(STFields);  
         }
    },
    
    STaskAboveOnSuccess :function(component, event, helper) {
        
        var AboveSTaskId=event.getParam("response").id;
        var staskrow=component.get("v.AboveSTaskRow");
        var ToastMsg1 = $A.get("e.force:showToast");
        ToastMsg1.setParams({
            "type": "success",
            "message": "Successfully Inserted Schedule Task Record."

        });
         if(staskrow.Task_Order__c!=null){
              helper.ReamingSTaskUpdate(component, event, helper,AboveSTaskId);
         }
        
         ToastMsg1.fire();
         component.set("v.isSTAboveInsert",false);
         helper.ScheduleTasksfetch(component, event, helper);
    },
    
    
})