({
	deletefromDetailpage : function(component, event, helper) {
        helper.delete_ClientCon(component, event, helper);
	},
     handleClose : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire(); 
    },
})