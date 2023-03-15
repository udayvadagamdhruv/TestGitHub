({
    profileInformation : function(component, event, helper) {
        var proInfo=component.get("c.ProfileInformation");
        proInfo.setCallback(this, function(proInfoRes) {
            console.log('====proInfoRes======'+proInfoRes.getReturnValue());
            var proState = proInfoRes.getState();
            if (proState === "SUCCESS") {
                component.set("v.ProfileInfo",proInfoRes.getReturnValue());  
            }
        }); 
        
         $A.enqueueAction(proInfo);
    },
    
	dodeleteJOb : function(component, event, helper) {
        var recId = component.get("v.recordId");
        var navService = component.find("navService");
        var delAction=component.get("c.checkDelete");
        delAction.setParams({
            JobId : recId
        });
        delAction.setCallback(this, function(delRes) {
            var delState = delRes.getState();
            console.log('===Delete response state======' + delRes.getState());
            console.log('===Delete respones======' +JSON.stringify(delRes.getReturnValue()));
            if (delState === "SUCCESS") {
                if(delRes.getReturnValue() == "OK"){
                    helper.showToast({
                        "type": "success",
                        "message": 'Job Deleted Sucessfully.'
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
                    
                    //$A.get("e.force:closeQuickAction").fire(); 
                }else if(delRes.getReturnValue()=='Error'){
                     helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": 'Record has insufficient access to delete'
                    }); 
                }
                else{
                    component.set("v.error",true);
                    component.set("v.errorMsg",delRes.getReturnValue());
                    /*  helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": delRes.getReturnValue()
                    });     
                    */
                }    
                
            }
            else{
                component.set("v.error",true);
                component.set("v.errorMsg",delRes.getReturnValue());
                /*  helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": delRes.getReturnValue()
                    });     
                    */ 
            }
        });
        
        $A.enqueueAction(delAction);
    },
    
    doContinuedeleteJOb : function(component, event, helper) {
        var recId = component.get("v.recordId");
        var navService = component.find("navService");
        
        var forcedelAction=component.get("c.ContinuetoDelete");
        forcedelAction.setParams({
            JobId : recId
        });
        
        forcedelAction.setCallback(this, function(delRes) {
            var delState = delRes.getState();
            console.log('===Contiune Delete response state======' + delRes.getState());
            console.log('===Continue Delete respones======' +JSON.stringify(delRes.getReturnValue()));
            
            if (delState === "SUCCESS") {
                if(delRes.getReturnValue() == "OK"){
                    helper.showToast({
                        "type": "success",
                        "message": 'Job and It\'s Related Records are Sucessfully Deleted.'
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
                    
                    //$A.get("e.force:closeQuickAction").fire(); 
                }
                else{
                    component.set("v.error",true);
                    component.set("v.errorMsg",delRes.getReturnValue());
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": delRes.getReturnValue()
                    });     
                }    
                
            }
            else{
                component.set("v.error",true);
                component.set("v.errorMsg",delRes.getReturnValue());
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": delRes.getReturnValue()
                });     
            }
        });
        
        $A.enqueueAction(forcedelAction);
    },
    
    
    
    
    handleClose : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire(); 
    },
})