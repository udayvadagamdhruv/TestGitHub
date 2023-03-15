({
    getFieldLabels: function(component, event, helper) {
        var Objaction = component.get( "c.getObjectType" );
        Objaction.setParams({
            ObjNames : 'Vendor_Contact__c'
        }); 
        Objaction.setCallback( helper, function( response ) {
            console.log('>>>>>> Enter >>>>>>>>>>');
            if(component.isValid() && response.getState() === 'SUCCESS' ) {
                // Parse the JSON string into an object
                component.set('v.ObjectType', JSON.parse(response.getReturnValue()));
                console.log('>>>>>> Result of labels >>>>>>>>>>'+JSON.stringify(JSON.parse(response.getReturnValue())));
            } else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction( Objaction );   
    },
    
    getFieldsforObject : function(component, event, helper){
        
        var sObj = component.get("v.sObjectName");
        console.log(">>>>>>>sObj>>>>>>>>>>>>>>" + JSON.stringify(sObj));
        var action = component.get("c.getFieldsforObject");
        action.setParams({
            sObjName : sObj
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log("list of field name" + JSON.stringify(response.getReturnValue()));
            if(state === "SUCCESS"){
                component.set("v.fieldset", response.getReturnValue());
            } 
        });
        var action1 = component.get("c.geLabelforObject");
        action1.setParams({
            sObjName : sObj
        });
        action1.setCallback(this, function(response){
            var state = response.getState();
            console.log("label name: " + response.getReturnValue());
            if(state === "SUCCESS"){
                component.set("v.Labelname", response.getReturnValue());
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Vendor Contact has '+errors[0].message
                }); 
            }
        });
        
        $A.enqueueAction(action1);
        $A.enqueueAction(action);
    },
    getRoles: function(component, event, helper){
        var RolesAction = component.get("c.getRole");
        RolesAction.setCallback(this, function(Roleresponse) {
            console.log("=====Roles List====", Roleresponse.getReturnValue());
            var Rol=Roleresponse.getReturnValue();
            var Roles=[];
            if(Roleresponse.getState() === "SUCCESS"){
                for (var key in Rol) {
                    Roles.push({
                        key: key,
                        value: Rol[key]
                    });
                }
                component.set("v.roles", Roles); 
            } 
            else {
                console.log('>>>>>> Error >>>>>>>>>>',Roleresponse.getError()[0].message);
                var errors = Roleresponse.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Vendor Contact has '+errors[0].message
                }); 
            }
        });
        $A.enqueueAction(RolesAction);
    },
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
    }
})