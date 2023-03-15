({
    doInit : function(component, event, helper) {
        
        var checkCreate=component.get("c.getShipPermiossions");
        checkCreate.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                console.log('---response.getReturnValue()----'+JSON.stringify(response.getReturnValue()));
                component.set("v.isAccess",response.getReturnValue());
            }
        });
        $A.enqueueAction(checkCreate);
        
        helper.fetchJobShipments(component, event, helper);
        helper.FetchFieldfromFS(component, event, helper);       
        helper.getFieldLabels(component, event, helper);
        
        var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
        component.set("v.isMobile",isMobile);
        
        
      
        
    },
    
    handleRowAction: function(component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
                
            case 'Edit_Shp':
                if(component.get("v.isAccess[2]")){
                    component.set("v.isShpOpen", true);
                    component.set('v.ShpRecordid',row.Id);
                }else{
                    var ToastMsg = $A.get("e.force:showToast");
                    ToastMsg.setParams({
                        "title": "Error!!",
                        "type": "error",
                        "message":'Shipment has insufficient access to edit.'
                    });
                    ToastMsg.fire();
                }
                break;
                
            case 'Delete_Shp':
                helper.deleteShp(component, event, helper);
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
    
    ShpCreate:function(component, event, helper) {
        if(component.get("v.isAccess[1]")){
            component.set("v.isShpOpen", true); 
        }   else{
            var ToastMsg = $A.get("e.force:showToast");
            ToastMsg.setParams({
                "title": "Error!!",
                "type": "error",
                "message":'Shipment has insufficient access to create.'
            });
            ToastMsg.fire();
        }
     	  
    },
    
     closeModel: function(component, event, helper) {
        component.set("v.isShpOpen", false);
        component.set('v.ShpRecordid', null);
    },
    
    ShpOnsubmit: function(component, event, helper){
        event.preventDefault(); // Prevent default submit
        
        var Shpfields = event.getParam("fields");
        Shpfields["Job__c"] = component.get("v.jobrecordId");
        var NameField = "";
        
        var reduceReturn=component.find('JobShpField').reduce(function(validFields, inputCmp){
            if(inputCmp.get("v.fieldName") == "Shipment_Name__c")
            {
                var ShpName= inputCmp.get("v.value");
                if(ShpName == null || ShpName == '')
                    NameField="Name";
            }
        }, true);
        
        var ToastMsg=$A.get("e.force:showToast");
        ToastMsg.setParams({
            "title": NameField,
            "type": "error",
            "message": NameField + " Field is required."
        });
        if (NameField == "Name") {
            ToastMsg.fire();
            event.preventDefault();
        } 
        else {
            component.find("ShpEditform").submit(Shpfields);
        }
        
    },
    
    ShponSuccess: function(component, event, helper){
        var ShpId=component.get('v.ShpRecordid');
        var msg;
        if(ShpId=='undefined' || ShpId==null)
        {
            msg='Successfully Inserted Shipment Record';
            
            var newShpId=event.getParams().response.id;
            var navevt=$A.get("e.force:navigateToSObject");
            navevt.setParams({
                "recordId": newShpId,
            });
            navevt.fire();
        }
        else{
            msg='Successfully Updated Shipment Record';
        }
        var ToastMsg1 = $A.get("e.force:showToast");
        ToastMsg1.setParams({
            "title": "Sucess",
            "type": "success",
            "message":msg
        });
        helper.fetchJobShipments(component, event, helper);
        component.set("v.isShpOpen", false);
        component.set('v.ShpRecordid', null);
        ToastMsg1.fire();
        
    },
    
    Shpload: function(component, event, helper){
    	 console.log('===record Load===');
        var recId = component.get("v.ShpRecordid");
        if (recId != null) {
            var Shpfields = event.getParam("recordUi");
        }
    },
    
     
     /************** Mobile Action ******************************/
    
    handleShpQuickAction : function(component, event, helper) {
        var selectOption=event.getParam("value");
        var selectShpId=event.getSource().get("v.name");
        console.log('---selectShpId-'+selectShpId+'---selectOption--'+selectOption);
        
        switch (selectOption) {
                
            case 'Edit_Shp':
                component.set("v.isShpOpen", true);
                component.set('v.ShpRecordid',selectShpId);
                break;
                
            case 'Delete_Shp':
                helper.deleteShp(component, event, helper, selectShpId);
                break;
                
        }
    }
    

})