({
    fetchCustomSettingdata :function(component, event , helper){
        var csAction = component.get("c.CustomSettingvalues");
        csAction.setCallback(this, function(response){
            var state = response.getState();
            console.log("custom setting response===" + JSON.stringify(response.getReturnValue()));
            if(state === "SUCCESS"){
                var PECSData=response.getReturnValue();
                console.log("lenght===" + JSON.stringify(PECSData.length));
                component.set("v.PECustomSetting",PECSData[0]);
                component.set("v.OrgInfo",PECSData[1]); 
                //component.set("v.ProInfo",PECSData[2]);
            }
           else {
               console.log('>>>>>> Error >>>>>>>>>>',response.getError());
               var errors = response.getError();
               var toastEvent = $A.get("e.force:showToast");
               toastEvent.setParams({
                   "title": "Error!",
                   "type": "error",
                   "message":errors[0].message
               });
               toastEvent.fire();
           }
        });
        
        var JobCostAccess = component.get("c.getisAccessable");
        JobCostAccess.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                console.log('Job Cost Accessable'+response.getReturnValue());
                component.set("v.JobCostAccessable",response.getReturnValue());
            }
        });
        
        $A.enqueueAction(JobCostAccess);
        $A.enqueueAction(csAction);
    },
})