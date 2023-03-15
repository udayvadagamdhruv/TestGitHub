({
    setPagref : function(component, event, helper) {
        var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "Job__c"
        });
        homeEvent.fire();
    }
})