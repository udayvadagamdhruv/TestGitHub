({
	 /*
     * Show toast with provided params
     * */
    showToast : function(params){
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams(params);
            toastEvent.fire();
        } else{
            alert(params.message);
        }
    },
    
     getProfile: function(component, event, helper){
        var ProfileAct = component.get("c.getProfile");
        ProfileAct.setCallback(this, function(response1) {
            console.log("=====Profile List====", response1.getReturnValue());
            var Pro=response1.getReturnValue();
            var Profiles=[];
            if(response1.getState() === "SUCCESS"){
                for (var key in Pro) {
                    Profiles.push({
                        key: key,
                        value: Pro[key]
                    });
                }
                component.set("v.ProfileRec", Profiles); 
            } 
        });
        $A.enqueueAction(ProfileAct);
    },
    
    getRoles: function(component, event, helper){
        var RolesAct = component.get("c.getSURoles");
        RolesAct.setCallback(this, function(response1) {
            console.log("=====Roles List====", response1.getReturnValue());
            var Rol=response1.getReturnValue();
            var Roles=[];
            if(response1.getState() === "SUCCESS"){
                for (var key in Rol) {
                    Roles.push({
                        key: key,
                        value: Rol[key]
                    });
                }
                component.set("v.RolesRec", Roles); 
            } 
        });
        $A.enqueueAction(RolesAct);
    }
   
})