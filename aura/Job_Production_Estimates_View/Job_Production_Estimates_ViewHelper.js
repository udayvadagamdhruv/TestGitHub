({
    fetchFieldLabels : function(component, event , helper){
         var Specactions=helper.getSpecRowActions.bind(this, component);
        var action=component.get("c.getObjectType");
        action.setParams({
            ObjNames:['Production_Estimate_Spec_Item__c']
        });
        
        action.setCallback(this, function(res){
            if(res.getState() === "SUCCESS"){
                var tableHeaders=JSON.parse(res.getReturnValue());
                console.log('===Vendor Quote and Quote Specs====='+JSON.stringify(JSON.parse(res.getReturnValue())));
                component.set("v.ObjectType",JSON.parse(res.getReturnValue()));
                
                component.set('v.ProEstimateSpecColumns', [
                    {type: 'action', typeAttributes: { rowActions: Specactions }},
                    {label: tableHeaders.Production_Estimate_Spec_Item__c.Name.label, fieldName: 'Name', type: 'text',editable: true,sortable: true},
                    {label: tableHeaders.Production_Estimate_Spec_Item__c.Description__c.label, fieldName: 'Description__c', type:'text',sortable: true}
                   
                ]);
                var labels = {'Desc':  tableHeaders.Production_Estimate_Spec_Item__c.Description__c.label
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
    
    ProEstSpecRecordsfetch : function(component,event,helper) {
        var proestrecId = component.get("v.recordId");
        console.log("==== ProEstrecId   ===="+proestrecId);
        var action = component.get("c.getProductioneEstimateSpecItems");
        action.setParams({
            proestRecId : proestrecId
        });
        action.setCallback(this, function(res) {
            console.log("=====Pro Estimate spec records===="+res.getReturnValue());
            if (res.getState() === "SUCCESS") {
                component.set("v.ProEstSpecRecords",res.getReturnValue());
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
    
    fetchFieldset : function(component,event,helper) {
        var action = component.get("c.getFieldsforObject");
        action.setParams({
            sObjName : "Production_Estimate_Spec_Item__c"
        });
        action.setCallback(this, function(response) {
            console.log("==ProEstimate spec=Field set====", response.getReturnValue());
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
    },
    
    deleteProductionEstimateSpecItem : function(component,event,helper,proEstSpecId) {
        var action = component.get("c.deleteProductionEstimateSpecItem");
        action.setParams({
            ProEstSpecId :proEstSpecId
        });
        action.setCallback(this, function(res) {
            console.log("==ProEstimate Estimate====", res.getReturnValue());
            if (res.getState() === "SUCCESS") {
                if(res.getReturnValue()=="OK"){
                    var ToastMsg1 = $A.get("e.force:showToast");
                    ToastMsg1.setParams({
                        "type": "success",
                        "message":"Record Deleted successfully."
                        
                    });
                    ToastMsg1.fire();
                    helper.ProEstSpecRecordsfetch(component, event, helper); 
                }
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
    
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.ProEstSpecRecords");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.ProEstSpecRecords", data);
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
    
    
    saveDataTableofSpecs : function(component, event, helper) {
        var editedRecords1 =component.find("ProEstSpecsTableId").get("v.draftValues");
        console.log('===Production Estimate Specs=editedRecords======'+JSON.stringify(editedRecords1));
        //var totalRecordEdited = editedRecords.length;
        var action = component.get("c.updateProEstimateSpecs");
        action.setParams({
            'editProEstSpecsList' : editedRecords1
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //if update is successful
                if(response.getReturnValue() === 'OK'){
                    helper.showToast({
                        "title": "Record Update",
                        "type": "success",
                        "message": "Specs Records Updated"
                    });
                    helper.ProEstSpecRecordsfetch(component, event, helper); 
                    component.find("ProEstSpecsTableId").set("v.draftValues", null);
                    
                } else{ //if update got failed
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": response.getReturnValue()
                    });
                    
                }      
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
    
    showToast : function(params){
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams(params);
            toastEvent.fire();
        } else{
            alert(params.message);
        }
    },
    
    getSpecRowActions: function (component, row, doneCallback) {
        var approved_ProEst= component.get("v.simpleRecord.Approved__c");
       var specactions=[
            {'label': 'Edit','iconName': 'action:edit','name': 'Edit_ProEst_Spec_Item',disabled:approved_ProEst},
            {'label': 'Delete','iconName': 'action:delete','name': 'Delete_ProEst_Spec_Item',disabled:approved_ProEst} 
        ];
        setTimeout($A.getCallback(function () {
            doneCallback(specactions);
        }), 200);
    },
})