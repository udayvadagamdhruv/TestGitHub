({
	setPagref : function(component, event, helper) {
        var homeEvent= $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "Campaign__c"
        });
        homeEvent.fire();
	}
})