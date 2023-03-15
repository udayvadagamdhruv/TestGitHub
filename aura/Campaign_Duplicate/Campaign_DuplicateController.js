({
	doInitduplicateCampaign : function(component, event, helper) {
        
        var recId = component.get("v.recordId");
        
        var CampDupAction=component.get("c.duplicateCampain");
        CampDupAction.setParams({
            OldcampId : recId
        });
        
        CampDupAction.setCallback(this, function(dupres) {
             console.log('===Campaign duplicate state======' + dupres.getState());
          
            var dupState = dupres.getState();
            var reslist = dupres.getReturnValue();
               console.log('===duplicate respones======' +JSON.stringify(reslist));
            if (dupState === "SUCCESS") {
                if(reslist[0]=="false"){
                    helper.showToast({
                        "type": "success",
                        "message": 'Record Duplicated Successfully.'
                    });     
                    
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": reslist[1],
                        "slideDevName": "detail"
                    });
                    navEvt.fire();
                }
                else if(reslist[0]=="true"){
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": reslist[2]
                    });     
                }    
                
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',dupres.getError()[0].message);
                var errors = dupres.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        
         $A.enqueueAction(CampDupAction);
    },
    
    handleClose : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire(); 
    },
		
})