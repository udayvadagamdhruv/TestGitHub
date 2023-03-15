({
	 doInit : function(component, event, helper) {
        var Action=component.get("c.loadrecordsTasks");
        Action.setCallback(this, function(Response) {
            console.log('===state======' + Response.getState());
            var result=Response.getReturnValue();
            console.log('======response===='+JSON.stringify(result));
            //helper.nextCall(component, event, helper, result);
       });
        $A.enqueueAction(Action);
    }
})