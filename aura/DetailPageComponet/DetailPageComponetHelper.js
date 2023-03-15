({
	Jobrecordsfetch : function(component, event,selectd) {
        if(selectd=='All Jobs'){
          component.find("pickJob").set("v.value",'All Jobs');
        }
        
        var action = component.get("c.RefreshJobNotes");
        action.setParams({
            "recordId": component.get("v.recordId"),
            "JobStatus": selectd
        });
        
        action.setCallback(this, function(response) {
            console.log('====Job Status response.getReturnValue()==' + response.getReturnValue());
            var state = response.getState();
            if (state === "SUCCESS") {
                var jobs = [];
                var jobnotes = [];
                var jobattchs = [];
                var JobChatfiles= [];
                var conts = response.getReturnValue();
                for (var key in conts) {
                    if (key == "Jobs") {
                        jobs.push({
                            key: key,
                            value: conts[key]
                        });
                    } else if (key == "Job__Notes") {
                        jobnotes.push({
                            key: key,
                            value: conts[key]
                        });
                    } else if (key == "Job__Attachments") {
                        jobattchs.push({
                            key: key,
                            value: conts[key]
                        });
                    } else if (key == "Job__ChatterFiles") {
                        JobChatfiles.push({
                            key: key,
                            value: conts[key]
                        });
                    }
                    
                }
                console.log("====job records===" + jobs);
                console.log("====job Notes===" + jobnotes);
                console.log("====job Job__Attachment===" + jobattchs);
                console.log("====job JobChatfiles===" + JobChatfiles);
                component.set("v.jobRecords", jobs);
                component.set("v.jobNotes", jobnotes);
                component.set("v.jobAttachs", jobattchs);
                component.set("v.jobChatterFiles", JobChatfiles);
                
            }
            
        });
        $A.enqueueAction(action);
	}
})