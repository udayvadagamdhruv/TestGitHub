({
	doInit : function(component, event, helper) {
		helper.fetchCustomSettingdata(component, event, helper);
          var helpTextRec= component.get("c.getHelpTextrecords"); 
        helpTextRec.setCallback(this, function(helpTextResponse){
            if (helpTextResponse.getState() === "SUCCESS") {
                console.log('=Help Text Values=='+JSON.stringify(helpTextResponse.getReturnValue()));
                component.set("v.helpText",helpTextResponse.getReturnValue());
                
               
            }
        }); 
        $A.enqueueAction(helpTextRec); 
	}
})