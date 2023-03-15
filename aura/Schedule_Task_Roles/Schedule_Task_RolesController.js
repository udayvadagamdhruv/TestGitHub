({
	doInitAddSTRoles : function(component, event, helper) {
		  helper.fetchAllSTaskWrapper(component, event, helper);
	},
    
     closeModel :function(component, event, helper) {
       component.set("v.isSTAddRolesOpen",false);     
    },
    
    refreshSTaskRoles : function(component, event, helper) {
        component.set("v.isSTAddRolesOpen",true);
         helper.fetchAllSTaskWrapper(component, event, helper);
    },
    
     AddRolestoSTask :function(component, event, helper) {
      var stWrapper= component.get("v.STaskRolesWrapper");
         if(stWrapper.length>0)
          helper.AddRolesMemberstoSTask(component, event, helper, stWrapper);
         else{
             helper.showToast({
                 'type':'error',
                 'message':'There are no roles records to assign Schedule Task.'
                 
             });    
         }
    },
    
    
})