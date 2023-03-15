({
	deletefromDetailpage : function(component, event, helper) {
        helper.delete_BB(component, event, helper);
	},
    handleClose : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire(); 
    },
})