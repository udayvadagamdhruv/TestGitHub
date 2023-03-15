({
    getFieldsforObject : function(component, sObj){
        
        var action = component.get("c.getFieldsforJobObject");
        action.setParams({
            sObjName : sObj,
            fieldsetname : "Job_Field_sets"
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log("list of fiels name===" + response.getReturnValue());
            if(state === "SUCCESS"){
                component.set("v.fieldSet", response.getReturnValue());
                console.log(">>>>>>>list of fiels name===" + response.getReturnValue());
            } 
        });
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
        $A.enqueueAction(action);
    },
    
    fetchCustomSettingdata :function(component, event , helper){
        var csAction = component.get("c.CustomSettingvalues");
        csAction.setCallback(this, function(response){
            var state = response.getState();
            console.log("custom setting response===" + JSON.stringify(response.getReturnValue()));
            if(state === "SUCCESS"){
                var PECSData=response.getReturnValue();
                console.log("lenght===" + JSON.stringify(PECSData.length));
                component.set("v.PECustomSetting",PECSData[0]);
                component.set("v.OrgInfo",PECSData[1]); 
                component.set("v.ProInfo",PECSData[2]);
                if(PECSData.length==4){
                  component.set("v.ClientInfo",PECSData[3]);  
                }
                
            }
        });
         $A.enqueueAction(csAction);
    },
    
    
     
})