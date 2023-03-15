({
    doInit : function(component, event, helper) {
        helper.fetchFieldSet(component, event, helper);       
    },
    
    doCancel: function(component, helper) {
        if(component.get("v.recordId")!=null)
        {
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": component.get("v.recordId")
            });
        }
        else
        {
            var navEvt = $A.get("e.force:navigateToObjectHome");
            navEvt.setParams({
                "scope":component.get("v.sObjectName")
            });
        }
        navEvt.fire();
    },
    
    
    MInvOnSubmit :function(component, event, helper) {
        event.preventDefault();
        var MInvfields=event.getParam("fields");
        MInvfields["Material_Item__c"]=component.get("v.recordId");
         MInvfields["Name"]='Inventory-('+component.get('v.today')+')';
         MInvfields["Mfg_Item_Number__c"]=component.get("v.simpleRecord.Manufacturer_Item_No__c");
        var missField;
        var missField1;
        var reduceReutrn = component.find('MInvField').reduce(function(validFields, inputCmp) {   
            if(inputCmp.get("v.fieldName") == "Name"){
                var MInvName = inputCmp.get("v.value");
                if (MInvName == null || MInvName == ''){
                    missField = "Name";
                }
            } 
            else if(inputCmp.get("v.fieldName") == "Qty_On_Shelf__c" ){
                var QtyOnSelf = inputCmp.get("v.value");
                if (QtyOnSelf == null ) {
                    missField1= "Qty_On_Shelf";
                }
            } 
        }, true);
        
        var ToastMsg=$A.get("e.force:showToast");    
        if(missField=="Name"){
            ToastMsg.setParams({
                "title":"Name",
                "type": "error",
                "message":"Name Field is required."
            }); 
            ToastMsg.fire();
            event.preventDefault();
        }
        else if(missField1=="Qty_On_Shelf"){
            ToastMsg.setParams({
                "title":"Qty On Shelf",
                "type": "error",
                "message":"Qty On Shelf Field is required."
            }); 
            ToastMsg.fire();
            event.preventDefault();
        }
            else{
                component.find("MInvEditform").submit(MInvfields);
                console.log('===Material Invenotry OnSubmit fields===='+JSON.stringify(MInvfields));
            }
    },
    
    MInvOnSuccess :function(component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject"); 
        var resultsToast = $A.get("e.force:showToast");
        navEvt.setParams({ 
            "recordId": component.get("v.recordId")
        }); 
        navEvt.fire(); 
        resultsToast.setParams({
            "title": "Saved",
            "type" : "success",
            "message": "The record was saved."
        });
        resultsToast.fire();
    }
    
})