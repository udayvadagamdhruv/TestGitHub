({
	doInit : function(component, event, helper) {
        helper.UnApproveQuote(component, event, helper);
    },
    
    handleClose : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire(); 
    },
})