({
	doinItEmailWorkOrder : function(component, event, helper) {
        console.log('>>>>>doinit>>>>>');
        helper.FetchJobTeam(component, event, helper);
    },
    
    SendEmailWorkOrder : function(component, event, helper) {
        console.log('===do init======');
        var recId = component.get("v.recordId");
        var emaillist = component.get("v.email");
        var mSubject = component.find("subject").get("v.value");
        var mBody = component.find("body").get("v.value");
        console.log('===emaillist======'+emaillist);
        console.log('===emaillist Length======'+emaillist.length);
        console.log('===Subject======'+mSubject);
        console.log('===Body======'+mBody);
     
        
        var emailAction=component.get("c.sendEmailWorkOrderToJobTeam");
        emailAction.setParams({
            JobId : recId,
            emails:emaillist,
            sub:mSubject,
            body:mBody
        });
        
        emailAction.setCallback(this, function(emRes) {
            var emailState = emRes.getState();
            console.log('===email response state======' + emRes.getState());
            console.log('=== email JSON respones======' +JSON.stringify(emRes.getReturnValue()));
            
            if (emailState === "SUCCESS") {
                if(emRes.getReturnValue() == "OK"){
                    helper.showToast({
                        "type": "success",
                        "message": 'Mail sent Sucessfully to the Job Team.'
                    });     
                    
                    $A.get("e.force:closeQuickAction").fire(); 
                }
                else{
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": emRes.getReturnValue()
                    });     
                }    
                
            }
            else{
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": emRes.getReturnValue()
                });     
            }
        });
        
        $A.enqueueAction(emailAction);
    },
    
    handleClose : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire(); 
    },
	
})