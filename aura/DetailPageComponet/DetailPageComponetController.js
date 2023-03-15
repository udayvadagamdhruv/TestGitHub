({
    doInit: function(component, event, helper) {
        var action = component.get("c.findjobsandnotes");
        var pickaction = component.get("c.fetchPicklistvalues");
        var campTempAction = component.get("c.getCampaignTemplates");
        action.setParams({
            recordId: component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            //console.log('==== response.getReturnValue()=='+ response.getReturnValue());
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
        
        pickaction.setCallback(this, function(pickRes) {
            var picstate = pickRes.getState();
            if (picstate === "SUCCESS") {
                component.set("v.statusPicklist", pickRes.getReturnValue());
            }
        });
        
        campTempAction.setCallback(this, function(campTempResponse) {
            console.log('===CmapTemp======'+campTempResponse.getReturnValue());
            var CmpTempState = campTempResponse.getState();
            if (CmpTempState === "SUCCESS") {
                var cmpTmp=campTempResponse.getReturnValue();
                var cmpTmpList=[];
                for(var key in cmpTmp){
                    cmpTmpList.push({ key: key, value:cmpTmp[key]});
                }
                component.set("v.CampTempList",cmpTmpList); 
            }
        });
        
        $A.enqueueAction(action);
        $A.enqueueAction(pickaction);
        $A.enqueueAction(campTempAction);
    },
    
    StatusChange: function(component, event, helper) {
        var cmo = component.find("pickJob");
        var selectd = cmo.get("v.value");
        console.log("====selectd==" +selectd );
        
        helper.Jobrecordsfetch(component,event,selectd);
    },
    NewJobRedirect:function(component, event, helper){
         var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
              "url": "/apex/CreateNewJobNewLightning",
              "isredirect": "true"
            });
            urlEvent.fire();
    },
    
    ImportTemplate:function(component, event, helper) {
       
        var importaction = component.get("c.ImpCampTempJobs");
        var ToastMsg=$A.get("e.force:showToast");
        console.log('=recid=='+component.get("v.recordId"));
        importaction.setParams({
            CmpId: component.get("v.recordId"),
            selectedCTemp:component.find("campSelectId").get("v.value")
        });
        
        importaction.setCallback(this, function(res) {
            console.log('==== ImportTemplate before=='+ res.getReturnValue());
            var state11 = res.getState();
            if (state11 === "SUCCESS" && res.getReturnValue()==="Sucessfully Imported Campaign Template Jobs") {
                console.log('====ImportTemplate  sucess=='+ res.getReturnValue());
                ToastMsg.setParams({
                    "title":"Import Jobs",
                    "type": "success",
                    "message":  res.getReturnValue()
                    
                });
                
               helper.Jobrecordsfetch(component,event,'All Jobs');
               ToastMsg.fire();
               
            }
            else{
                ToastMsg.setParams({
                    "title":"Error",
                    "type": "error",
                    "message":  res.getReturnValue()
                    
                }); 
                
                ToastMsg.fire();
                
            }
        });
        $A.enqueueAction(importaction); 
    }
    
    
})