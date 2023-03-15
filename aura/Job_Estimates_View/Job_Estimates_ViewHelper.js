({
    fetchFieldLabels : function(component, event , helper){
        
        var rowActions = helper.getRowActions.bind(this, component);
        var action=component.get("c.getObjectType");
        action.setParams({
            ObjNames:['Estimate_Spec_Item__c']
        });
        
        action.setCallback(this, function(res){
            if(res.getState() === "SUCCESS"){
                console.log('===Estimate_Spec_Item__c====='+JSON.stringify(JSON.parse(res.getReturnValue())));
                component.set("v.ObjectType",JSON.parse(res.getReturnValue()));
                
                var tableHeader=component.get('v.ObjectType');
                console.log('>>>Field Name Dynamically >>>>>>>>>>>>>'+tableHeader);
                
                component.set('v.columns', [
                    {type: 'action', typeAttributes: {rowActions: rowActions}},
                    {label: tableHeader.Estimate_Spec_Item__c.Name.label, fieldName: 'Name', sortable: true, type: 'text'},
                    {label: tableHeader.Estimate_Spec_Item__c.Description__c.label, fieldName: 'Description__c', type: 'text'}
                   
                ]);  
                var labels = {'Desc':  tableHeader.Estimate_Spec_Item__c.Description__c.label
                             };
                component.set('v.DynamicLabels',labels);
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',res.getError()[0].message);
                var errors = res.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
            
            
        });
        $A.enqueueAction(action);
    },
    
    EstSpecRecordsfetch : function(component, event, helper) {
        var EstrecId = component.get("v.recordId");
        //alert(EstrecId);
        console.log("==== EstrecId   ===="+EstrecId);
        var action = component.get("c.getestimateSpecItems");
        action.setParams({
            estRecId : EstrecId
        });
        action.setCallback(this, function(response) {
            console.log("=====Estimate spec records===="+response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                //var rows=response.getReturnValue();
                component.set("v.EstSpecRecords",response.getReturnValue());
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction(action);
    },
    
    getRowActions: function (component, row, doneCallback) {
        var actions = [];
        
        var editAction = {
            'label': 'Edit',
            'iconName': 'utility:edit',
            'name': 'Edit_EstSpec'
        };
        
        var deleteAction = {
            'label': 'Delete',
            'iconName': 'utility:delete',
            'name': 'Delete_EstSpec'
        };
        
        actions.push(editAction,deleteAction);
        // simulate a trip to the server
        setTimeout($A.getCallback(function () {
            doneCallback(actions);
        }), 200);
    },
    
    deleteEstSpec : function(component, event, helper, selectEstSpecId) {  
        
        var DelEstSpecAction = component.get("c.DeleteEstSpecRecord");
        if(selectEstSpecId!=null || selectEstSpecId!=undefined){
            DelEstSpecAction.setParams({
                EstspecrecId :selectEstSpecId
            });
        }
        else{
            var row = event.getParam('row');
            DelEstSpecAction.setParams({
                EstspecrecId :row.Id
            });
            console.log('===Delete Est Spec Id=='+row.Id);
        }  
        
        DelEstSpecAction.setCallback(this, function(DelEstSpecResponse) {
            console.log('===Dele spec Reuturn==' + DelEstSpecResponse.getReturnValue());
            if (DelEstSpecResponse.getState() === "SUCCESS") {
                console.log('===Dele spec Reuturn==' + DelEstSpecResponse.getReturnValue());
                 var DeleteEstSpecMsg = $A.get("e.force:showToast");
                if(DelEstSpecResponse.getReturnValue()=='OK'){
                    helper.EstSpecRecordsfetch(component, event, helper);                    
                    DeleteEstSpecMsg.setParams({
                        "type": "success",
                        "message": "Estimate Spec Item Deleted Successfully"
                        
                    });
                    DeleteEstSpecMsg.fire(); 
                }else{
                     DeleteEstSpecMsg.setParams({
                        "type": "error",
                        "message": DelEstSpecResponse.getReturnValue()
                        
                    });
                    DeleteEstSpecMsg.fire(); 
                }
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',DelEstSpecResponse.getError()[0].message);
                var errors = DelEstSpecResponse.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction(DelEstSpecAction);
        
    },
    
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.EstSpecRecords");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.EstSpecRecords", data);
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
    
    productiontempList : function(component, event, helper) {
        var proTempaction = component.get("c.getProductionSpecTemplate");
        
        proTempaction.setCallback(this, function(proTempres){
            if (proTempres.getState() === "SUCCESS") {
                var proTempList=[];
                var res=proTempres.getReturnValue();
                for(var key in res){
                    proTempList.push({key:key,value:res[key]});
                }
                component.set("v.proTempList",proTempList);
            }
             else {
                console.log('>>>>>> Error >>>>>>>>>>',proTempres.getError()[0].message);
                var errors = proTempres.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
            
        });
        $A.enqueueAction(proTempaction);
    },
    
    getfieldsetvalues :  function(component, event, helper){
        var action = component.get("c.getFieldsforObject");
       // console.log("=====second time sobjname==="+sobjname);
        action.setParams({
            sObjName : 'Estimate_Spec_Item__c'
        });
        action.setCallback(this, function(response) {
            console.log("===Quote_Spec_Item__c==Field set====", response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                component.set("v.fieldset",response.getReturnValue()); 
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction(action);
        
    }
})