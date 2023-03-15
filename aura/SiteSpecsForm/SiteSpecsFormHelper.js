({
    fetchJobSpec : function(component, event, helper) {
        var recId = component.get("v.SpecId");
        console.log('==recId==='+recId);
        var FetchSpecs = component.get("c.getSpecrecords");
        FetchSpecs.setParams({
            recordId : recId,
        });
        
        FetchSpecs.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                console.log('>>>REsult>>>>>>', JSON.stringify(response.getReturnValue()));
                component.set("v.SpecRecords",response.getReturnValue());
            }
        });
        
        $A.enqueueAction(FetchSpecs);
    }
})