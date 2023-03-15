({
    doInit : function(component, event, helper) {
        component.set('v.isModalOpen', true);
        console.log('>>>>>>>>>>>Job status picstate>>>>>>>>>>>>>>>'+component.get('v.isModalOpen'));
        var pickaction = component.get("c.fetchPicklistvalues");
        pickaction.setCallback(this, function(pickRes) {
            var picstate = pickRes.getState();
            console.log('>>>>>>>>>>>Job status picstate>>>>>>>>>>>>>>>'+picstate);
            console.log('>>>>>>>>>>>Job status Picklist>>>>>>>>>>>>>>>'+pickRes.getReturnValue());
            if (picstate === "SUCCESS") {
                component.set("v.statusPicklist", pickRes.getReturnValue());
            }
        });
        $A.enqueueAction(pickaction);
    },
    
     closeModel: function(component, event, helper) {
        component.set("v.isModalOpen", false);
    },
    
    WorkOrderPageRedirect : function(component, event, helper) {
        var cmo = component.find("pickJob");
        var Jobsts = cmo.get("v.value");
        console.log('>>>>>>>>>>>Job status Picklist value>>>>>>>>>>>>>>>'+Jobsts);
        var Cmpid=component.get("v.recordId");
        $A.get("e.force:closeQuickAction").fire(); 
        window.open('/one/one.app#/alohaRedirect/apex/CampaignWorkorder?id='+Cmpid+'&Status='+Jobsts,'_self'); 
    },
})