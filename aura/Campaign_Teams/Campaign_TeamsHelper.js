({
	 JobTeamsfetch : function(component,event,helper) {
        var recId = component.get("v.recordId");
        var teamPhotos = component.get("c.getTeamPhotos");
        
        teamPhotos.setParams({
            recordId: recId
        });
        
        teamPhotos.setCallback(this, function(teamPhotosResponse) {
            console.log('===state======' + teamPhotosResponse.getState());
            var teamPhotosState = teamPhotosResponse.getState();
            if (teamPhotosState === "SUCCESS") {
                var teamPhotos = teamPhotosResponse.getReturnValue();
                console.log('====CampaignTeamPhotos==='+JSON.stringify(teamPhotos));
                component.set("v.CampaignTeamPhotos",teamPhotosResponse.getReturnValue());
            }
        });
        $A.enqueueAction(teamPhotos);    //call the job Team Edit button records.
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