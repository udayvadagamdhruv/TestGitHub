({
	doInIt : function(component, event, helper) {
        var recordTypeId = component.get("v.pageReference").state.recordTypeId;
        console.log("=======recordTypeId======"+recordTypeId);
        componet.set("v.recordTypeId",recordTypeId);
		helper.fetchMIfieldset(component, event, helper);
	},
    
    doCancel:function(component, event, helper) {
        if(component.get("v.recordId")!=null){
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": component.get("v.recordId")
            });
            navEvt.fire();
        }
        else
        {
            var navEvt = $A.get("e.force:navigateToObjectHome");
            navEvt.setParams({
                "scope":component.get("v.sObjectName")
            });
            navEvt.fire();
        }
        
    },
    
})