({
    getData : function(cmp) {
        var recId = cmp.get("v.recordId");
        console.log('===recId&&&==='+recId);
        var action = cmp.get('c.GetTaskData');
        action.setParams({"RecId" : cmp.get("v.recordId") });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set('v.mydata', response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    }
})