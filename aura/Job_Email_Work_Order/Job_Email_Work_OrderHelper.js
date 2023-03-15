({
	FetchJobTeam :function(component, event, helper){
        var recId = component.get("v.recordId");
        console.log('>>>>FetchJobTeam Enter>>>>>');
        var JobTeamList=component.get("c.JobRelatedTeamlist");
        JobTeamList.setParams({
            JobId:recId  
        });
        
        JobTeamList.setCallback(this, function(response){ 
            if (response.getState() === "SUCCESS") {
                var emaillist=[];
                //var eamillistdtring;
                var emailListString;
                var rows=response.getReturnValue();
                console.log('--rows--'+JSON.stringify(rows));               
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    emaillist.push(row.Email__c);
                }
                console.log('--rows--'+JSON.stringify(emaillist));             
                emailListString=emaillist.join();              
                console.log('===email rowsss======'+emaillist.length);
                component.set("v.email",emailListString);
                console.log('--email rowsss--'+component.get("v.email"));
            } else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            } 
        }); 
        $A.enqueueAction(JobTeamList); 
    },
        
    
    showToast : function(params){
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams(params);
            toastEvent.fire();
        } else{
            alert(params.message);
        }
    },
})