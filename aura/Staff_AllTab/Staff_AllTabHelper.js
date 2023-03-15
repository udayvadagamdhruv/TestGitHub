({
    getFieldsforObject : function(component, sObj){
        var action1 = component.get("c.geLabelforObject");
        action1.setParams({
            sObjName : sObj
        });
        action1.setCallback(this, function(response){
            var state = response.getState();
            console.log("label name" + response.getReturnValue());
            if(state === "SUCCESS"){
                component.set("v.Labelname", response.getReturnValue());
            } 
        });
        $A.enqueueAction(action1);
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