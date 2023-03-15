({
	deletefromDetailpage : function(component, event, helper) {
        helper.delete_Staff(component, event, helper);
	},
      handleClose : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire(); 
    },
})