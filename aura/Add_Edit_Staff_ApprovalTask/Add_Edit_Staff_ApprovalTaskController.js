({
	doInitforAddEdit : function(component, event, helper) {
		  helper.fetchAllStaffWrapper(component, event, helper);
          
	},
    
     closeModel :function(component, event, helper) {
       component.set("v.isEditStaffOpen",false);     
    },
    
    refreshStaffMembers : function(component, event, helper) {
         component.set("v.isEditStaffOpen",true);
         helper.fetchAllStaffWrapper(component, event, helper);
    },
    
     AddStafftoTask :function(component, event, helper) {
      var StaffWrappers= component.get("v.AllstaffWrappers");
         if(StaffWrappers.length>0)
          helper.AddtoStaffMembersToTask(component, event, helper, StaffWrappers);
         else{
             helper.showToast({
                 'type':'error',
                 'message':'There are no Job Team Members for this Job.'
                 
             });    
         }
    },
    
    
})