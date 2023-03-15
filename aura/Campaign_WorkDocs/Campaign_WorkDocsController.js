({
    fetchActivities : function(component, event, helper) {
        var action = component.get("c.getActivites");
        action.setParams({
            DocId : component.get("v.docId")
        });
        action.setCallback(this, function(res) {
            var result=res.getReturnValue();
            console.log("=====Document Activites===="+ JSON.stringify(result));
            if (res.getState() === "SUCCESS") {
               // if(result[0]=="OK"){
                    component.set("v.isActivitiesAdded",res.getReturnValue()); 
               // }
              /*  else{
                    helper.showToast({
                        "title":"Error!!",
                        "type":"error",
                        "message":result[1]
                    });   
                }*/
            }
           
        });
        $A.enqueueAction(action);
    }
})