({
    fetchFieldLabels :function(component, event, helper){
        var rowActions=[
            {'label': 'Edit',   'iconName': 'utility:edit','name': 'ST_Edit'},
            {'label': 'Delete', 'iconName': 'utility:delete','name': 'ST_Delete'},
            {'label': 'Insert Above','iconName': 'utility:arrowup','name': 'ST_Above'},
            {'label': 'Add/Edit Roles','iconName': 'action:edit_groups','name': 'ST_AddEditRoles'} 
        ];
        
        var Objaction = component.get( "c.getObjectType" );
        Objaction.setParams({
            ObjNames : 'Approval_Schedule_Task__c'
        }); 
        Objaction.setCallback( helper, function( response ) {
            console.log('>>>>>> Enter >>>>>>>>>>');
            if(component.isValid() && response.getState() === 'SUCCESS' ) {
                var tableHeaders=JSON.parse(response.getReturnValue());
                console.log('=====tableHeaders======'+JSON.stringify(tableHeaders));
                component.set('v.columns', [
                    //{label: 'Name', fieldName: 'TaskLink', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: '_self', tooltip:{ fieldName: 'Name' } } },
                    { type: 'action', typeAttributes: { rowActions: rowActions }},
                    {label: tableHeaders.Approval_Schedule_Task__c.Name.label, fieldName: 'Name', type: 'text',editable: true,sortable: true},
                    {label: tableHeaders.Approval_Schedule_Task__c.Roles__c.label, fieldName: 'Roles__c', type: 'text',sortable: true,initialWidth:350},
                    {label: tableHeaders.Approval_Schedule_Task__c.Days__c.label, fieldName: 'Days__c', type: 'number',editable: true,sortable: true,initialWidth:100,cellAttributes: { alignment: 'left' }},
                    {label: tableHeaders.Approval_Schedule_Task__c.Task_Order__c.label, fieldName: 'Task_Order__c', type: 'number',editable: true,sortable: true,cellAttributes: { alignment: 'left' }}
                ]);
            }
        });
         $A.enqueueAction(Objaction);
    },
    
    ScheduleTasksfetch: function(component, event, helper){
        
       var TaskAction= component.get("c.getAppSchduleTasks");
        TaskAction.setParams({
            schId : component.get("v.recordId")
        });
        
        TaskAction.setCallback(this, function(response){ 
            if (response.getState() === "SUCCESS") {
                var rows=response.getReturnValue();
                console.log("Rows----"+rows);
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                   /* row.TaskLink = '/'+row.Id;
                    if(row.GL_Code__r!=null){
                        row.GLCodeLink='/'+row.GL_Code__r.Id;
                        row.GLCodeName=row.GL_Code__r.Name;
                    }
                    else{
                        row.GLCodeLink='';
                        row.GLCodeName='';
                    }*/
                }
                console.log('>>>>>>>rowsssss>>>>>>'+JSON.stringify(rows));
                component.set("v.data",rows);
            }   else {
                var errors = response.getError(); 
                console.log("Error message: " + errors);
                if (errors) { 
                    if (errors[0] && errors[0]) { 
                        console.log("Error message --: " + JSON.stringify(errors));
                    }
                } 
                else { 
                    console.log("Unknown error"); 
                } 
            }  
        }); 
        
           $A.enqueueAction(TaskAction);
        
    },
    
    getTaskOrderforBelowTask : function(component, event, helper) {
        var TOrder= component.get("c.getApprovalTaskBelowOrder");
        TOrder.setParams({
            schId:component.get("v.recordId")
        });
        TOrder.setCallback(this, function(response){ 
            if (response.getState() === "SUCCESS") {
                component.set("v.TaskOrderforBelowTask",response.getReturnValue());
            }  else {
                var errors = response.getError(); 
                console.log("Error message: " + errors);
                if (errors) { 
                    if (errors[0] && errors[0]) { 
                        console.log("Error message --: " + JSON.stringify(errors));
                    }
                } 
                else { 
                    console.log("Unknown error"); 
                }
            }
        }); 
             $A.enqueueAction(TOrder);                  
    },
    
    saveDataTable : function(component, event, helper) {
        var editedRecords =  component.find("STasksDataTable").get("v.draftValues");
        console.log('=====editedRecords======='+JSON.stringify(editedRecords));
        var totalRecordEdited = editedRecords.length;
        var action = component.get("c.UpdateApprovalScheuleTasks");
        action.setParams({
            'editedScheduleList' : editedRecords
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue() === 'true'){
                    helper.showToast({
                        "type": "success",
                        "message": totalRecordEdited+" Approval Schedule Tasks Records Updated"
                    });
                    
                    helper.ScheduleTasksfetch(component, event, helper);
                    component.find("STasksDataTable").set("v.draftValues", null);
                    
                }else if(response.getReturnValue() === 'Error'){
                     helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": 'Approval Schedule taks have insifficient access to update'
                    });
                } else{ //if update got failed
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": response.getReturnValue()
                    });
                    
                    var err_array =  response.getReturnValue().split(';');
                    component.set('v.errors', {
                        rows: {
                            b: {
                                title: 'We found errors.',
                                messages: [
                                     err_array[0],
                                    err_array[1].split(',')[1]
                                ],
                                fieldNames: ['Name', 'Task_Order__c']
                            }
                        },
                        table: {
                            title: 'Your entry cannot be saved. Fix the errors and try again.',
                            messages: [
                                err_array[0],
                                err_array[1].split(',')[1]
                            ]
                        }
                    });
                    
                    
                }      
            }
        });
        $A.enqueueAction(action);
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
    ReamingSTaskUpdate : function(component, event, helper,AboveSTaskId){
         var remUAction=component.get("c.UpdateReamingApprovalSTasks");
        remUAction.setParams({
            STaskId: AboveSTaskId
        });
        remUAction.setCallback(this, function(respopnse){
             var ToastMsg=$A.get("e.force:showToast");
            if (respopnse.getState() === "SUCCESS") {
                if(respopnse.getReturnValue()=="OK"){
                     helper.ScheduleTasksfetch(component, event, helper);
                    ToastMsg.setParams({
                        "type": "success",
                        "message": "Successfully re-Orderd Approval Scheduled Tasks."
                    });
                     // ToastMsg.fire(); 
                }
                else{
                     ToastMsg.setParams({
                        "title": "Error!!",
                         "type":"error",
                        "message":respopnse.getReturnValue() 
                    });
                      ToastMsg.fire();
                }
            }
             else{
                     ToastMsg.setParams({
                        "title": "Error!!",
                         "type":"error",
                        "message":respopnse.getReturnValue() 
                    });
                      ToastMsg.fire();
                }
        });
        
        $A.enqueueAction(remUAction);
    },
    
    
    DeleteScheuleTask : function(component, event, helper){
        var row = event.getParam('row');
        var DelSTAction=component.get("c.DeleteApprovalScheduleTask");
        DelSTAction.setParams({
            STaskId: row.Id
        });
        DelSTAction.setCallback(this, function(delrespopnse){
             var ToastMsg=$A.get("e.force:showToast");
            if (delrespopnse.getState() === "SUCCESS") {
                if(delrespopnse.getReturnValue()=="OK"){
                     helper.ScheduleTasksfetch(component, event, helper);
                    ToastMsg.setParams({
                        "type": "success",
                        "message": "Successfully Deleted."
                    });
                      ToastMsg.fire(); 
                }
                else{
                     ToastMsg.setParams({
                        "title": "Error!!",
                         "type":"error",
                        "message":delrespopnse.getReturnValue() 
                    });
                      ToastMsg.fire();
                }
            }
             else{
                     ToastMsg.setParams({
                        "title": "Error!!",
                         "type":"error",
                        "message":delrespopnse.getReturnValue() 
                    });
                      ToastMsg.fire();
                }
        });
        
        $A.enqueueAction(DelSTAction);
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

    
	
})