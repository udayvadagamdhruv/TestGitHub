({
	doInit : function(component, event, helper) {
        console.log("Doinit child");
        helper.fetchJobSpec(component, event, helper);
    },
    
    FetchSpecs : function(component, event, helper) {
        console.log("FetchSpecs from aura method");
        helper.fetchJobSpec(component, event, helper);
    },
    
    
     
    
})