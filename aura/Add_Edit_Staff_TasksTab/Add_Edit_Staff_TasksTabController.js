({
    doInitforAddEdit : function(component, event, helper) {
        helper.fetchAllStaffWrapper(component, event, helper);
    },
    
    closeModel :function(component, event, helper) {
        component.set("v.isEditStaffOpen",false);     
    },
    
    refreshStaffMembers : function(component, event, helper) {
        component.set("v.isEditStaffOpen",true);
        helper.fetchAllStaffWrapper(component, event, helper);
    },
    
    AddStafftoTask :function(component, event, helper) {
        var StaffWrappers= component.get("v.AllstaffWrappers");
        if(StaffWrappers.length>0)
            helper.AddtoStaffMembersToTask(component, event, helper, StaffWrappers);
        else{
            helper.showToast({
                'type':'error',
                'message':'There are no Job Team Members for this Job.'
                
            });    
        }
    },
    
    //The below function is for filter in job team
    onChangeStaffType : function(component, event, helper){
        var selectType=component.find("staffselect").get("v.value");
        var jtkid = component.get("v.TaskId");
        var allstaffWrappers=component.get("v.AllstaffWrappersJobTeam");
        var StaffWrapperString = JSON.stringify(allstaffWrappers);
        console.log('====onChangeStaffType allstaffWrappers====='+JSON.stringify(allstaffWrappers));
        //console.log('===JobTeamAddEditStaff===recId=='+recId+'  '+typeof(recId));
        var serchStaff = component.get("c.SerachStaff");
        serchStaff.setParams({
            jobtkId: jtkid,
            StatusString:selectType
        });
        serchStaff.setCallback(this, function(searchResponse) {
            var searchState = searchResponse.getState();
            console.log("===searchState==" + searchState);
            if (searchState === "SUCCESS") {
                //console.log('===searchState All Staff Wrappers====='+ JSON.stringify(searchResponse.getReturnValue()));
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
    
    //The below function is for load date and display data for job team members
    JobTeamAddEditStaff : function(component, event, helper){
        //  if(component.get("v.JobDetailAccessible[3]")){      
        component.set("v.isAddEditTeamMembers",true);
        var jtkid = component.get("v.TaskId");
        var teamEdit = component.get("c.JobTeamAddEditStaffCont");
        teamEdit.setParams({
            rcdId : jtkid
        });
        teamEdit.setCallback(this, function(TeamEditresponse) {
            var TeamEditstate = TeamEditresponse.getState();
            console.log("State of Team Eidt" + TeamEditstate);
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
        /* }         
        else{
            helper.showToast({
                "title": "Error!!",
                "type": "error",
                "message": 'Team has insufficient access to create'
            });   
        }*/
    },
    
    //The below function is for save button for job team members
    addStafftoJobTeam : function(component, event, helper){
        var jtkid = component.get("v.TaskId");
        var allstaffWrappers=component.get("v.AllstaffWrappersJobTeam");
        var StaffWrapperString = JSON.stringify(allstaffWrappers);
        console.log('====allstaffWrappers====='+allstaffWrappers);
        console.log('====Json String====='+StaffWrapperString);
        var AddStaffMembers = component.get("c.AddstafftoJobTeam");
        AddStaffMembers.setParams({
            jobtkId: jtkid,
            selectedJobTeam: StaffWrapperString
        });
        AddStaffMembers.setCallback(this, function(addResponse) {
            var addResState = addResponse.getState();
            console.log("=====addResState===" + addResState);
            if (addResState === "SUCCESS") {
                if(addResponse.getReturnValue()==='OK'){
                    //helper.JobTeamsfetch(component, event, helper);
                    //helper.JobTasksfetch(component, event);
                    helper.fetchAllStaffWrapper(component, event, helper);
                    component.set("v.isAddEditTeamMembers",false);
                    // helper.navigatetothis(component,event,helper);
                    helper.showToast({ 
                        "type": "success",
                        "message": "Job Team Members are Updated."
                    });
                    /*  var appEvent=$A.get("e.JobSuite:UpdateRecordsforChanges");
                    if(appEvent)
                    {
                        appEvent.fire();
                    }*/
                }
                else{
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": addResponse.getReturnValue()
                    });   
                }
            }
            else if (addResState === "ERROR") {
                var errors = addResponse.getError(); 
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
    
    //The below function is for cancel button for job team members
    CancelAddEditModal : function(component, event, helper){
        component.set("v.isAddEditTeamMembers",false);
    },
    
})