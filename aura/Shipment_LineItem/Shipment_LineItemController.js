({
    doInit : function(component, event, helper) {
        
        var checkCreate=component.get("c.getShipPermiossions");
        checkCreate.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                console.log('---response.getReturnValue()----'+JSON.stringify(response.getReturnValue()));
                component.set("v.isAccess",response.getReturnValue());
                if(component.get("v.isAccess[0]")){
                    helper.fetchShipmentLI(component, event, helper);
                    helper.getFieldLabels(component, event, helper);
                }
            }
        });
        $A.enqueueAction(checkCreate);
        
      
        var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
        component.set("v.isMobile",isMobile);
    },
    
    handleRowAction: function(component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'Edit_ShpLI':
                if(component.get("v.isAccess[5]")){
                    component.set("v.isShpLIEditOpen", true);
                    component.set('v.ShpLIRecordid',row.Id);
                }else{
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": 'Shipment Line Item has insufficient access to edit'
                    }); 
                }
                break;
            case 'Delete_ShpLI':
                helper.deleteJobShpLI(component, event, helper);
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
    
    addLineItems: function (component, event, helper) {
        if(component.get("v.isAccess[4]")){
            helper.AddShipmentLI(component, event, helper);
            component.set("v.isaddClick",true);
        }else{
            helper.showToast({
                "title": "Error!!",
                "type": "error",
                "message": 'Shipment Line Item has insufficient access to create'
            }); 
        }
       
    },
    
    updateSelectedTextShpLI: function (component, event) {
        var selectedRows = event.getParam('selectedRows');
        component.set('v.Selected_PELI', selectedRows);
        console.log('>>>>>> Event Selected Row Values >>>>>>>>>>>>',+JSON.stringify(selectedRows));
        console.log('>>>>>> Selected Row Values >>>>>>>>>>>>',+JSON.stringify(component.get('v.Selected_PELI')));
        component.set('v.ShpLiselectedRowsCount', selectedRows.length);
        console.log('>>>>>> Event Selected Row Values >>>>>>>>>>>>',+component.get('v.ShpLiselectedRowsCount'));
    },
    
    closeModelForAddLineItems: function (component, event, helper) {
        component.set("v.Selected_PELI",null); 
        component.set("v.ShpLiselectedRowsCount",null);
        component.set("v.isaddClick",false);
    },
    
     closeModelForEditLI: function (component, event, helper) {
        component.set("v.isShpLIEditOpen",false);
    },

    saveSelectedLineItems :function(component, event, helper) { 
        console.log('>>>>>>> Save Line Items >>>>>>');
        if(component.get("v.Selected_PELI")!=null && component.get("v.Selected_PELI")!=''){
            console.log('>>>>>>> Save Line Items Enter If>>>>>>');
            console.log('>>>>>>> Save Line Items Enter If selected>>>>>>',+component.get("v.Selected_PELI"));
            var SaveShpLIaction=component.get("c.SaveShpLineItems");
            SaveShpLIaction.setParams({
                selRecords : component.get("v.Selected_PELI"),
                Shpid:component.get("v.recordId")
            });
            
            SaveShpLIaction.setCallback(this, function(res) {
                if (res.getState() === "SUCCESS") {
                    if(res.getReturnValue()=="OK"){
                        console.log('====Ok response==='+res.getReturnValue());
                        
                        console.log('=====scucesffully inserted Est and PE the records from the Detail page===');
                        var ToastMsg5=$A.get("e.force:showToast");    
                        ToastMsg5.setParams({
                            "type": "success",
                            "message": "Line Items  added to this Shipment."
                            
                        });   
                        ToastMsg5.fire();
                        
                        helper.fetchShipmentLI(component, event, helper);;
                        component.set("v.Selected_PELI",null);   
                        component.set("v.isaddClick",false);  
                        
                    }
                    else{
                        console.log('====fale  response==='+res.getReturnValue());               
                        event.preventDefault();
                        var ToastMsg111 = $A.get("e.force:showToast");
                        ToastMsg111.setParams({
                            "type": "error",
                            "message":res.getReturnValue()
                        }); 
                        ToastMsg111.fire();
                    }
                    
                }
            });
            $A.enqueueAction(SaveShpLIaction);   
        }
        else{
            var ToastMsg22 = $A.get("e.force:showToast");
            ToastMsg22.setParams({
                "type": "error",
                "message":"No Line Items are Selected."
            }); 
            ToastMsg22.fire();
        }
        
    },
    
    
    ShpLIOnsubmit: function(component, event, helper){
        event.preventDefault(); // Prevent default submit
        var ShpLIfields = event.getParam("fields");
        component.find("ShpLIEditform").submit(ShpLIfields);
    },
    
    ShpLIonSuccess: function(component, event, helper){
        var ShpId=component.get('v.ShpLIRecordid');
        var msg;
        if(ShpId=='undefined' || ShpId==null)
        {
          
        }
        else{
            msg='Successfully Updated Shipment Line Item Record';
        }
        var ToastMsg1 = $A.get("e.force:showToast");
        ToastMsg1.setParams({
            "title": "Sucess",
            "type": "success",
            "message":msg
        });
        helper.fetchShipmentLI(component, event, helper);
        component.set("v.isShpLIEditOpen", false);
        component.set('v.ShpLIRecordid', null);
        ToastMsg1.fire();
        
    },
    
    ShpLIload: function(component, event, helper){
    	 console.log('===record Load===');
        var recId = component.get("v.ShpLIRecordid");
        if (recId != null) {
            var ShpLIfields = event.getParam("recordUi");
        }
    }
    
    
})