({
    doInit : function(component, event, helper) {
        
        var rowActions = helper.getRowActions.bind(this, component);
        
        helper.fetchRol(component, event, helper);
       
        component.set('v.columns', [
            {type: 'action', typeAttributes: {rowActions: rowActions}},
            {label: 'Name', fieldName: 'Name', sortable: true,editable:true, type: 'text' }
            
        ]); 
       
    },
    
    handleSaveRecord: function(component, event, helper) {
        console.log('>>>>>>>>save record>>>>>>');
        var CreateRecords =  component.find("RoleName").get("v.value");
        console.log('>>>>>>>>Create Records>>>>>>'+CreateRecords);
        
        if(CreateRecords==null || CreateRecords=='')
        {
            var ToastMsg=$A.get("e.force:showToast");
            ToastMsg.setParams({
                "title":"Name",
                "type": "error",
                "message":"Please enter the Name."
            });   
            ToastMsg.fire();
            event.preventDefault(); 
        } 
        
        else
        {
            var action = component.get("c.CreatenewRole");
            action.setParams({
                'CreateRole' : CreateRecords
            });
            action.setCallback(this,function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    if(response.getReturnValue() === 'true'){
                        helper.showToast({
                            "title": "Record Created",
                            "type": "success",
                            "message": " Record Created Successfully"
                        });
                        
                        helper.fetchRol(component, event, helper);
                    } else{
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!!",
                            "type": "error",
                            "message": response.getReturnValue()
                        });
                        toastEvent.fire();
                    }      
                }
                else {
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
            $A.enqueueAction(action);
            component.set("v.isRolOpen", false);
            component.set('v.RolRecordid', null);
        }
    },
    
    handleRowAction: function(component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'Edit_Rol':
                component.set("v.isRolOpen", true);
                component.set('v.RolRecordid',row.Id);
                break;
            case 'Delete_Rol':
                helper.deleteRol(component, event, helper);
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
    
    onSave : function (component, event, helper) {
        helper.saveDataTable(component, event, helper);
    },
    
    NewRole:function (component, event, helper) {
        component.set("v.isRolOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.isRolOpen", false);
        component.set('v.RolRecordid', null); 
    }
   
})