({
    doInit: function(component, event, helper) {
        
        var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
        console.log('--isMobile'+isMobile);
        if(isMobile){
            component.set("v.isMobile",true);
        }
        
        helper.fetchFieldLabels(component, event, helper);
        var action = component.get("c.findjobsandnotes");
        var pickaction = component.get("c.fetchPicklistvalues");
        var campTempAction = component.get("c.getCampaignTemplates");
        action.setParams({
            recordId: component.get("v.recordId")
        });
        
        var headerActions = [
            {label: 'Active', checked: true, name:'Show_Active'},
            {label: 'Completed',checked: false,name:'Show_Completed'},
            {label: 'Canceled',checked: false, name:'Show_Canceled'},
            {label: 'On Hold',checked: false, name:'Show_OnHold'},
            {label: 'Requested',checked: false, name:'Show_Requested'}
        ];
        
        action.setCallback(this, function(response) {
            console.log('==== response.getReturnValue()=='+ response.getReturnValue());
            var state = response.getState();
            if (state === "SUCCESS") {
                var jobdata = [];
                var jobs = [];
                var jobnotes = [];
                var jobattchs = [];
                var JobChatfiles= [];
                var conts = response.getReturnValue();
                console.log('==== conts=='+ conts);
                for (var key in conts) {
                    if (key == "Jobs") {
                        jobs.push({
                            key: key,
                            value: conts[key]
                        });
                        jobdata=conts[key];
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
                console.log("====job data records===" + JSON.stringify(Object.values(jobs)));
                console.log("====job Notes===" + jobnotes);
                console.log("====job Job__Attachment===" + jobattchs);
                console.log("====job JobChatfiles===" + JobChatfiles);
                component.set("v.jobRecords", jobs);
                //component.set("v.data", jobdata);
                component.set("v.jobNotes", jobnotes);
                component.set("v.jobAttachs", jobattchs);
                component.set("v.jobChatterFiles", JobChatfiles);
                
                
                var rows=jobdata;
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    row.JobNameLink = '/'+row.Id;    
                }
                component.set("v.data",rows);
                
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',response.getError()[0].message);
                var errors = response.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
            
        });
        
        pickaction.setCallback(this, function(pickRes) {
            var picstate = pickRes.getState();
            if (picstate === "SUCCESS") {
                component.set("v.statusPicklist", pickRes.getReturnValue());
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',pickRes.getError()[0].message);
                var errors = pickRes.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                }); 
            }
        });
        
        campTempAction.setCallback(this, function(campTempResponse) {
            console.log('===CmapTemp======'+JSON.stringify(campTempResponse.getReturnValue()));
            var CmpTempState = campTempResponse.getState();
            if (CmpTempState === "SUCCESS") {
                /* var cmpTmp=campTempResponse.getReturnValue();
                var cmpTmpList=[];
                for(var key in cmpTmp){
                    cmpTmpList.push({ key: key, value:cmpTmp[key]});
                }*/                
                component.set("v.CampTempList",campTempResponse.getReturnValue()); 
            }
            else {
                console.log('>>>>>> Error >>>>>>>>>>',campTempResponse.getError()[0].message);
                var errors = campTempResponse.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": 'Campaign Template has '+errors[0].message
                }); 
            }
        });
        
        $A.enqueueAction(action);
        $A.enqueueAction(pickaction);
        $A.enqueueAction(campTempAction);
    },
    
    WorkOrderPageRedirect : function(component, event, helper) {
        var Cmpid=component.get("v.recordId");
        var cmo = component.find("pickJob");
        var Jobsts = cmo.get("v.value");
        $A.get("e.force:closeQuickAction").fire(); 
        window.open('/one/one.app#/alohaRedirect/apex/CampaignWorkorder?id='+Cmpid+'&Status='+Jobsts,'_self'); 
    },
    
    updateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },
    
    StatusChange: function(component, event, helper) {
        var cmo = component.find("pickJob");
        var selectd = cmo.get("v.value");
        console.log("====selectd==" +selectd );
        
        helper.Jobrecordsfetch(component,event,selectd);
    },
    NewJobRedirect:function(component, event, helper){
        
        var CampObj={"Id":component.get("v.recordId"), "Name":component.get("v.simpleRecord.Name")};
        console.log('=====Campaign Object============='+JSON.stringify(CampObj));
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef: "c:Job_New_Edit_Cmp",
            componentAttributes: {
                sObjectName : "Job__c",
                CampPopulate : CampObj
            },
            isredirect:true
        });
        
        evt.fire();
        
        
        /*      
            
          
           var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
            "url": "/lightning/o/Job__c/new"
            });
            urlEvent.fire();   
       
        
          
            var createRecordEvent = $A.get("e.force:createRecord");
            createRecordEvent.setParams({
            "entityApiName": "Job__c"
            });
            createRecordEvent.fire();
          */   
      
  },
    
    ImportTemplate:function(component, event, helper) {
        
        console.log(typeof(component.find("campSelectId").get("v.value")));
        console.log('---->',component.find("campSelectId").get("v.value"));
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