({
    getMoreRecords: function(component , rows){
        return new Promise($A.getCallback(function(resolve, reject) {
            var action=component.get("c.getJobs");    
            var recordOffset = component.get("v.currentCount");
            //alert('recordoffset '+recordOffset);
            var recordLimit = component.get("v.initialRows");
            action.setParams({
                "recordLimit": recordLimit,
                "recordOffset": recordOffset 
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS"){
                    var resultData = response.getReturnValue();
                    resolve(resultData);
                    recordOffset = recordOffset+recordLimit;
                    // alert('recordoffset '+recordOffset);
                    component.set("v.currentCount", recordOffset);   
                }                
            });
            $A.enqueueAction(action);
        }));
    },
    getTotalNumberOfrecords : function(component) {
        var action = component.get("c.getTotalrcds");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" ) {
                var resultData = response.getReturnValue();
                //alert('getTotalNumberOfrecords'+resultData);
                component.set("v.totalNumberOfRows", resultData);
            }
        });
        $A.enqueueAction(action);
    },
})