({
    fetchFieldSet:  function(component, event, helper){
        var actionToday=component.get("c.gettodaydate");
        actionToday.setCallback(this,function(response){
            console.log("=====today()====", response.getReturnValue());
             if (response.getState() === "SUCCESS") {
                component.set("v.today",response.getReturnValue()); 
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message":'Material Inventory Item has'+errors[0].message
                }); 
            }
        });
        
        var actionMInv = component.get("c.getFieldsforObject");
        actionMInv.setParams({
            sObjName : "Material_Inventory_Item__c"
        });
        actionMInv.setCallback(this, function(res) {
            console.log("=====Field set for Materail Inventory====", res.getReturnValue());
            if (res.getState() === "SUCCESS") {
                component.set("v.MInvFieldSet",res.getReturnValue()); 
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',res.getError()[0].message);
                var errors = res.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message":'Material Inventory Item has'+errors[0].message
                }); 
            }
        });
        
        $A.enqueueAction(actionMInv);
        $A.enqueueAction(actionToday);
    },
   
    showToast:function(params){
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams(params);
            toastEvent.fire();  
        }
        else{
            alert(params.message);
        }
    },
    
   
})