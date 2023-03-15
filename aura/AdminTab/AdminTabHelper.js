({
	 FetchObjPrefix:  function(component, event, Sobj){
        var action = component.get("c.getObjPrefix");
        action.setParams({
            Obj : Sobj
        });
        action.setCallback(this, function(response) {
            console.log("====Resss=====", response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": '/'+response.getReturnValue()
                });
                urlEvent.fire();
            }
             else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
               toastEvent.fire();
            }
        });
       
        $A.enqueueAction(action);
    },
})