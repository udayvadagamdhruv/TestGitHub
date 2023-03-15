({
    init: function (cmp, event, helper) {
        var rowActions = [];
        var EditAction = {
            'label': 'Edit',
            'iconName': 'utility:edit',
            'name': 'Task_Edit'
        };
        var InsertAction = {
            'label': 'Insert Above',
            'iconName': 'utility:arrowup',
            'name': 'Task_Above'
        }; 
        var DeleteAction = {
            'label': 'Delete',
            'iconName': 'utility:delete',
            'name': 'Task_Delete'
        };
        rowActions.push(EditAction,InsertAction,DeleteAction);
        
        cmp.set('v.mycolumns', [
            {type: 'action', typeAttributes: { rowActions: rowActions }} ,
            {label: 'Task Order',		fieldName: 'Task_Order__c',			type: 'number'},
            {label: 'Task Name',		fieldName: 'Task_Name__c',			type: 'text'},
            {label: 'Staff',			fieldName: 'Assigned_Users__c',		type: 'text'},
            {label: 'Days',				fieldName: 'Days__c',				type: 'number'},
            {label: 'Final Due Date',	fieldName: 'Revised_Due_Date__c',	type: 'date-local'},
            {label: 'Completion Date',	fieldName: 'Completion_Date__c',	type: 'date-local'},
            {label: 'Marked Done',		fieldName: 'Marked_Done__c',		type: 'boolean'}
            
        ]);
        helper.getData(cmp);
    },
    
    handleRowAction : function(component, event, helper) {
        // DeleteTask  ActiveTask CompleteTask tskid
        var action = event.getParam('action');
        console.log('==action==='+action)
        var row = event.getParam('row');
        console.log('==row==='+row)
        console.log('==action.name==='+action.name)
        switch (action.name) {      
            case 'Task_Edit':
        
            component.set("v.EditTaskId",row.Id);
            console.log('==row.Id==='+row.Id)
            component.set("v.isTaskEdit",true);
            console.log('==isTaskEdit==='+isTaskEdit)
        }
      
    },
    
      closeModel: function(component, event, helper) {
      // Set isModalOpen attribute to false  
      component.set("v.isTaskEdit", false);
   },
    
})