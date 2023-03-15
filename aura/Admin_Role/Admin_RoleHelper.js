({
    fetchRol : function(component, event, helper) {
        
        var RolRec = component.get("c.getRoles");
        
        RolRec.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var rows=response.getReturnValue();
                console.log('>>>>>>>>> Rowsssss >>>>>>>>>>>>'+JSON.stringify(rows));
                component.set("v.data",rows);
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
        $A.enqueueAction(RolRec);
    },
    
    
    getRowActions: function (component, row, doneCallback) {
        var actions = [];
        
        var editAction = {
            'label': 'Edit',
            'iconName': 'utility:edit',
            'name': 'Edit_Rol'
        };
        
        var deleteAction = {
            'label': 'Delete',
            'iconName': 'utility:delete',
            'name': 'Delete_Rol'
        };
        
        actions.push(deleteAction);
        
        // simulate a trip to the server
        setTimeout($A.getCallback(function () {
            doneCallback(actions);
        }), 200);
    },
    
    
    reloadDataTable : function(){
        console.log('==========reloadData Table======');
        var refreshEvent = $A.get("e.force:refreshView");
        $A.get('e.force:refreshView').fire();
        if(refreshEvent){
            refreshEvent.fire();
        }
    },
    
     /*
     * This function get called when user clicks on Save button
     * user can get all modified records
     * and pass them back to server side controller
     * */
    saveDataTable : function(component, event, helper) {
        var editedRecords =  component.find("RoleDataTable").get("v.draftValues");
        var totalRecordEdited = editedRecords.length;
        var action = component.get("c.updateRole");
        action.setParams({
            'editRoleList' : editedRecords
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //if update is successful
                if(response.getReturnValue() === 'true'){
                    this.showToast({
                        "title": "Record Update",
                        "type": "success",
                        "message": totalRecordEdited+" Records Updated"
                    });
                    
                   // helper.reloadDataTable();
                    helper.fetchRol(component, event, helper);
                    component.find("RoleDataTable").set("v.draftValues", null);
                    
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
    
    deleteRol: function(component, event, helper){
        var row = event.getParam('row');
        console.log('===Delete Role Id=='+row.Id);     
        var DeleteRole=component.get("c.DeleteRol");
        DeleteRole.setParams({RolId :row.Id });
        DeleteRole.setCallback(this, function(DeleteRoleres){
            var delstate = DeleteRoleres.getState();
            if(delstate === "SUCCESS"){
                if(DeleteRoleres.getReturnValue()=='OK'){             
                    helper.fetchRol(component, event, helper);
                    var ToastMsg = $A.get("e.force:showToast");
                    ToastMsg.setParams({
                        "type": "success",
                        "message":'Record Deleted Successfully.'
                    });
                    ToastMsg.fire();
                }
                if(DeleteRoleres.getReturnValue()=='Error'){ 
                    var ToastMsg = $A.get("e.force:showToast");
                    ToastMsg.setParams({
                        "title": "Error!!",
                        "type": "error",
                        "message":"Role has insufficient access to delete"
                    });
                    ToastMsg.fire();
                }
                else{
                    var ToastMsg = $A.get("e.force:showToast");
                    ToastMsg.setParams({
                        "title": "Error!!",
                        "type": "error",
                        "message":DeleteRoleres.getReturnValue()
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
                    "message":DeleteRoleres.getReturnValue()
                });
                ToastMsg.fire();
                
            }
        });
        $A.enqueueAction(DeleteRole);  
    },
    
    
    validateRoleForm: function(component) {
        var validRole = true;
         // Show error messages if required fields are blank
        var allValid = component.find('RoleName').reduce(function (validFields, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validFields && inputCmp.get('v.validity').valid;
        }, true);
        if (allValid) {
            // Verify we have an Name to attach it to
            var Name = component.get("v.record");
            if($A.util.isEmpty(Name)) {
                validContact = false;
                console.log("Quick action context doesn't have a valid Name.");
            }
        return(validContact);
            
        }  
	}
    
})