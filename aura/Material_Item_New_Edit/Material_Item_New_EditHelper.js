({
	fetchMIfieldset : function(component, event, helper) {
        var recordTypeId = component.get("v.pageReference").state.recordTypeId;
        console.log("=======recordTypeId======"+recordTypeId);
        
		var action=component.get("c.getFieldsetsForMIWithRecordType");
        action.setParams({
            "sObjectName":component.get("v.sObjectName"),
            "recordTypeId":recordTypeId
        });
        action.setCallback(this,function(res){
              console.log("=======response of fieldset======"+JSON.stringify(res.getReturnValue()));
            if(res.getState()==="SUCCESS"){
                component.set("v.FieldSet",res.getReturnValue());
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',res.getError()[0].message);
                var errors = res.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        $A.enqueueAction(action);
	},
    
    
    showToast : function(params){
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams(params);
            toastEvent.fire();
        } else{
            alert(params.message);
        }
    },
})