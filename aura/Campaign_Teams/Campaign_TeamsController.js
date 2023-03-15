({
    doInIt : function(component, event, helper){
        helper.JobTeamsfetch(component, event, helper);
    },
    
    CancelAddEditModal : function(component, event, helper){
        component.set("v.isAddEditTeamMembers",false);
    },
    
    onChangeStaffType : function(component, event, helper){
        var selectType=component.find("staffselect").get("v.value");
        var recId = component.get("v.recordId");
        
        console.log('===JobTeamAddEditStaff===recId=='+recId+'  '+typeof(recId));
        var serchStaff = component.get("c.SerachStaffforCampaignTeam");
        serchStaff.setParams({
            CTempId: recId,
            StatusString:selectType
            
        });
        
        serchStaff.setCallback(this, function(searchResponse) {
            var searchState = searchResponse.getState();
            console.log("===searchState==" + searchState);
            if (searchState === "SUCCESS") {
                console.log('===searchState All Staff Wrappers====='+ JSON.stringify(searchResponse.getReturnValue()));
                component.set("v.AllstaffWrappersJobTeam",searchResponse.getReturnValue());
            }
            else if (searchState === "ERROR") {
                var errors = searchResponse.getError(); 
                console.log("Error message: " + errors);
                if (errors) { 
                    if (errors[0] && errors[0]) { 
                        console.log("Error message --: " + JSON.stringify(errors));
                    }
                } 
                else { 
                    console.log("Unknown error"); 
                } 
            }
            
        });
        
        $A.enqueueAction(serchStaff);
    },
    
    
    addStafftoJobTeam : function(component, event, helper){
        var recId = component.get("v.recordId");
        var allstaffWrappers=component.get("v.AllstaffWrappersJobTeam");
        var StaffWrapperString = JSON.stringify(allstaffWrappers);
        console.log('====allstaffWrappers====='+allstaffWrappers);
        console.log('====Json String====='+StaffWrapperString);
        var AddStaffMembers = component.get("c.AddstafftoJobTeam");
        AddStaffMembers.setParams({
            CTempId: recId,
            selectedJobTeam: StaffWrapperString
        });
        
        AddStaffMembers.setCallback(this, function(addResponse) {
            var addResState = addResponse.getState();
            console.log("=====addResState===" + addResState);
            if (addResState === "SUCCESS") {
                if(addResponse.getReturnValue()==='OK'){
                    helper.JobTeamsfetch(component, event, helper);
                    //helper.JobTeamsfetch(component, event, helper);
                    //helper.JobTasksfetch(component, event);
                    component.set("v.isAddEditTeamMembers",false);
                    helper.showToast({
                        "type": "success",
                        "message": "Campaign Team Members are Updated."
                    });
                }
                else{
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": response.getReturnValue()
                    });   
                }
            }
            else if (addResState === "ERROR") {
                var errors = addResState.getError(); 
                console.log("Error message: " + errors);
                if (errors) { 
                    if (errors[0] && errors[0]) { 
                        console.log("Error message --: " + JSON.stringify(errors));
                    }
                } 
                else { 
                    console.log("Unknown error"); 
                } 
            }
            
        });
        
        $A.enqueueAction(AddStaffMembers);
        
    }, 
    
	CampaignTeamAddEditStaff : function(component, event, helper){
        component.set("v.isAddEditTeamMembers",true);
        var recId = component.get("v.recordId");
        var teamEdit = component.get("c.JobTeamAddEditStaffCont");
        teamEdit.setParams({
            recordId: recId
        });
        
        teamEdit.setCallback(this, function(TeamEditresponse) {
            var TeamEditstate = TeamEditresponse.getState();
            console.log("Campaign Team" + TeamEditstate);
            if (TeamEditstate === "SUCCESS") {
                console.log('===All Staff Wrappers====='+ JSON.stringify(TeamEditresponse.getReturnValue()));
                component.set("v.AllstaffWrappersJobTeam",TeamEditresponse.getReturnValue());
            }
            else if (TeamEditstate === "ERROR") {
                var errors = TeamEditresponse.getError(); 
                console.log("Error message: " + errors);
                if (errors) { 
                    if (errors[0] && errors[0]) { 
                        console.log("Error message --: " + JSON.stringify(errors));
                    }
                } 
                else { 
                    console.log("Unknown error"); 
                } 
            }
            
        });
        
        $A.enqueueAction(teamEdit);
    },
    
    
    
})