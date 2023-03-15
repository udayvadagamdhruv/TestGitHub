({
	deleteRecordsfromDetilapge : function(component, event, helper) {
        helper.deleteFromDetailpage(component, event, helper);
	},
    handleClose : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire(); 
    },
})