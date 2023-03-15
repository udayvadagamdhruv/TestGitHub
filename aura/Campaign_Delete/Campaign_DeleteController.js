({ 
    dodeleteCampaign : function(component, event, helper) {
        var recId = component.get("v.recordId");
        var navService = component.find("navService");
        
        var delAction=component.get("c.CampaignDelete");
        delAction.setParams({
            CampId : recId
        });
        
        delAction.setCallback(this, function(delRes) {
            var delState = delRes.getState();
            console.log('===Delete response state======' + delRes.getState());
            console.log('===Delete respones======' +JSON.stringify(delRes.getReturnValue()));
            
            if (delState === "SUCCESS") {
                if(delRes.getReturnValue() == "OK"){
                    helper.showToast({
                        "type": "success",
                        "message": 'Campaign Deleted Sucessfully.'
                    });   
                    
                     // Uses the pageReference definition in the init handler
                    var pageReference = {
                        type: 'standard__objectPage',
                        attributes: {
                            objectApiName: component.get("v.sObjectName"),
                            actionName: 'home'
                        },
                    };
                    navService.navigate(pageReference);
                   
                }
                else{
                    component.set("v.error",true);
                    component.set("v.errorMsg",delRes.getReturnValue());
                }    
                
            }
            else{
                component.set("v.error",true);
                component.set("v.errorMsg",delRes.getReturnValue());
            }
        });
        
        $A.enqueueAction(delAction);
    },
    
    gotoCampaignView : function(component, event, helper) {
        var navService = component.find("navService");
        var pageReference = {
            type: 'standard__objectPage',
            attributes: {
                objectApiName: component.get("v.sObjectName"),
                actionName: 'home'
            },
        };
        navService.navigate(pageReference);
        
    },
    
    handleClose : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire(); 
    },
})