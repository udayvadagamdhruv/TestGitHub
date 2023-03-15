({
    doInIt : function(component, event, helper) {
        var recordId=component.get("v.recordId");
        var action=component.get("c.fetchLatestFiles");
        action.setParams({
            recordId:recordId
        });
        action.setCallback(this,function(res){
            console.log('=======Result======='+res.getReturnValue());
             console.log('=======Result======='+res.getState());
            if(res.getState()==="SUCCESS"){
                component.set("v.latestFiles",res.getReturnValue());  
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',res.getError()[0].message);
                var errors = res.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message":'Material Item Files has'+errors[0].message
                }); 
            }
        });
        
        $A.enqueueAction(action);
    }
})